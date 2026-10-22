import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/paginated.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../auth/data/models/user_role.dart';
import '../../auth/logic/auth_cubit.dart';
import '../data/decisions_repo.dart';
import '../data/models/decision_model.dart';

part 'decisions_state.dart';

class DecisionsCubit extends Cubit<DecisionsState> {
  DecisionsCubit(this._repo, this._auth) : super(const DecisionsInitial());

  final DecisionsRepo _repo;
  final AuthCubit _auth;

  bool get _isAdmin => _auth.currentUser?.role == UserRole.admin;

  DecisionsSuccess? get _data =>
      state is DecisionsSuccess ? state as DecisionsSuccess : null;

  List<DecisionModel> get decisions => _data?.decisions ?? const [];

  Future<void> load() async {
    if (state is DecisionsSuccess || state is DecisionsLoading) return;
    emit(const DecisionsLoading());
    await refresh();
  }

  Future<void> refresh() async {
    try {
      final (page, unread) = await _repo.list(admin: _isAdmin);
      emit(DecisionsSuccess(page, unread: unread));
      if (_isAdmin) _loadVoters(page.items);
    } catch (e) {
      final msg = NetworkException.from(e).message;
      if (_data == null) {
        emit(DecisionsError(msg));
      } else {
        AppOverlay.showError(msg);
      }
    }
  }

  Future<void> loadMore() async {
    final current = _data;
    if (current == null || !current.page.hasMore || current.page.loadingMore) {
      return;
    }
    emit(current.copyWith(page: current.page.copyWith(loadingMore: true)));
    try {
      final (next, unread) =
          await _repo.list(admin: _isAdmin, page: current.page.nextPage);
      emit(current.copyWith(page: current.page.append(next), unread: unread));
      if (_isAdmin) _loadVoters(next.items);
    } catch (e) {
      emit(current);
      AppOverlay.showError(NetworkException.from(e).message);
    }
  }

  Future<void> _loadVoters(List<DecisionModel> items) async {
    for (final d in items.where((d) => d.kind == DecisionKind.poll)) {
      if (d.voted == 0) continue;
      try {
        final voters = await _repo.voters(d.id);
        _replace(d.id, (x) => x.copyWith(voters: voters));
      } catch (_) {}
    }
  }

  void _replace(int id, DecisionModel Function(DecisionModel d) update,
      {int unreadDelta = 0}) {
    final current = _data;
    if (current == null) return;
    final d = current.decisions.where((x) => x.id == id).firstOrNull;
    if (d == null) return;
    emit(current.copyWith(
      page: current.page.replace((x) => x.id == id, update(d)),
      unread: (current.unread + unreadDelta).clamp(0, 1 << 30),
    ));
  }

  Future<void> acknowledge(int id, {bool silent = false}) async {
    try {
      final json = await _repo.acknowledge(id);
      _replace(id, (d) => d.merge(json).copyWith(acked: true), unreadDelta: -1);
      if (!silent) {
        AppOverlay.showSuccess(LocaleKeys.decisions_ackRecorded.tr());
      }
    } catch (e) {
      if (!silent) AppOverlay.showError(NetworkException.from(e).message);
    }
  }

  void markInfoSeen() {
    for (final d in decisions) {
      if (d.kind == DecisionKind.info && !d.acked) {
        acknowledge(d.id, silent: true);
      }
    }
  }

  Future<bool> vote(int id, bool agree, String comment) async {
    try {
      final json = await _repo.vote(id, agree, comment);
      _replace(id, (d) => d.merge(json).copyWith(vote: agree), unreadDelta: -1);
      AppOverlay.showSuccess(LocaleKeys.decisions_voteRecorded.tr());
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }

  Future<void> remind(DecisionModel decision) async {
    try {
      final count = await _repo.remind(decision.id);
      AppOverlay.showSuccess(
          LocaleKeys.decisions_reminderSent.tr(namedArgs: {'n': '$count'}));
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
    }
  }

  Future<bool> publish({
    required DecisionKind kind,
    required String title,
    required String body,
    required DecisionAudience audience,
    DateTime? endsAt,
  }) async {
    try {
      final created = await _repo.publish(
          kind: kind,
          title: title,
          body: body,
          audience: audience,
          endsAt: endsAt);
      final current = _data;
      if (current != null) {
        emit(current.copyWith(page: current.page.prepend(created)));
      }
      AppOverlay.showSuccess(LocaleKeys.decisions_published.tr());
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }
}
