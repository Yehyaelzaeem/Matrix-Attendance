import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/paginated.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/utils/validators.dart';
import '../../auth/data/models/user_role.dart';
import '../../requests/data/models/request_model.dart';
import '../data/approvals_repo.dart';

part 'approvals_state.dart';

class ApprovalsCubit extends Cubit<ApprovalsState> {
  ApprovalsCubit(this._repo) : super(const ApprovalsInitial());

  final ApprovalsRepo _repo;
  UserRole? _role;

  UserRole? get role => _role;

  ApprovalsSuccess? get _data =>
      state is ApprovalsSuccess ? state as ApprovalsSuccess : null;

  Future<void> load() async {
    if (state is ApprovalsSuccess || state is ApprovalsLoading) return;
    await _fetch();
  }

  Future<void> setRole(UserRole? role) async {
    _role = role;
    await _fetch();
  }

  Future<void> _fetch() async {
    emit(const ApprovalsLoading());
    try {
      final (pending, summary) = await _repo.pending(role: _role);
      emit(ApprovalsSuccess(pending: pending, summary: summary, role: _role));
    } catch (e) {
      emit(ApprovalsError(NetworkException.from(e).message));
    }
  }

  Future<void> refresh() async {
    final current = _data;
    try {
      final (pending, summary) = await _repo.pending(role: _role);
      emit(current == null
          ? ApprovalsSuccess(pending: pending, summary: summary, role: _role)
          : current.copyWith(pending: pending, summary: summary));
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
    }
  }

  Future<void> loadMore() async {
    final current = _data;
    if (current == null ||
        !current.pending.hasMore ||
        current.pending.loadingMore) {
      return;
    }
    emit(
        current.copyWith(pending: current.pending.copyWith(loadingMore: true)));
    try {
      final (next, summary) =
          await _repo.pending(role: _role, page: current.pending.nextPage);
      emit(current.copyWith(
          pending: current.pending.append(next), summary: summary));
    } catch (e) {
      emit(current);
      AppOverlay.showError(NetworkException.from(e).message);
    }
  }

  Future<void> loadLog() async {
    final current = _data;
    if (current == null) return;
    emit(current.copyWith(logLoading: true));
    try {
      final (log, _) = await _repo.log(role: _role);
      emit(_data!.copyWith(log: log, logLoading: false));
    } catch (e) {
      emit(_data!.copyWith(logLoading: false));
      AppOverlay.showError(NetworkException.from(e).message);
    }
  }

  Future<void> loadMoreLog() async {
    final current = _data;
    final log = current?.log;
    if (current == null || log == null || !log.hasMore || log.loadingMore) {
      return;
    }
    emit(current.copyWith(log: log.copyWith(loadingMore: true)));
    try {
      final (next, _) = await _repo.log(role: _role, page: log.nextPage);
      emit(current.copyWith(log: log.append(next)));
    } catch (e) {
      emit(current);
      AppOverlay.showError(NetworkException.from(e).message);
    }
  }

  void _decided(RequestModel decided) {
    final current = _data;
    if (current == null) return;
    final role = decided.requesterRole == UserRole.reviewer
        ? UserRole.reviewer
        : UserRole.employee;
    final s = current.summary;
    emit(current.copyWith(
      pending: current.pending.remove((r) => r.id == decided.id),
      summary: RoleSummary(
        all: s.all > 0 ? s.all - 1 : 0,
        employee: role == UserRole.employee && s.employee > 0
            ? s.employee - 1
            : s.employee,
        reviewer: role == UserRole.reviewer && s.reviewer > 0
            ? s.reviewer - 1
            : s.reviewer,
      ),
      log: current.log?.prepend(decided),
    ));
  }

  Future<bool> approve(RequestModel request) async {
    try {
      _decided(await _repo.approve(request.id));
      AppOverlay.showSuccess(LocaleKeys.admin_toastApproved.tr(
          namedArgs: {'name': Validators.firstName(request.employee ?? '')}));
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }

  Future<bool> reject(RequestModel request, String reason) async {
    try {
      _decided(await _repo.reject(request.id, reason));
      AppOverlay.showSuccess(LocaleKeys.admin_toastRejected.tr());
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }
}
