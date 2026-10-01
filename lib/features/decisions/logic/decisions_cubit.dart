import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../data/decisions_repo.dart';
import '../data/models/decision_model.dart';

part 'decisions_state.dart';

class DecisionsCubit extends Cubit<DecisionsState> {
  DecisionsCubit(this._repo) : super(const DecisionsInitial());

  final DecisionsRepo _repo;

  List<DecisionModel> get decisions => state is DecisionsSuccess
      ? (state as DecisionsSuccess).decisions
      : const [];

  Future<void> load() async {
    if (state is DecisionsSuccess) return;
    emit(const DecisionsLoading());
    try {
      emit(DecisionsSuccess(await _repo.getDecisions()));
    } catch (_) {
      final msg = LocaleKeys.error_generic.tr();
      AppOverlay.showError(msg);
      emit(DecisionsError(msg));
    }
  }

  Future<void> _put(DecisionModel decision) async {
    await _repo.save(decision);
    final exists = decisions.any((d) => d.id == decision.id);
    emit(DecisionsSuccess(exists
        ? [for (final d in decisions) d.id == decision.id ? decision : d]
        : [decision, ...decisions]));
  }

  Future<void> acknowledge(String id) async {
    final d = decisions.firstWhere((d) => d.id == id);
    await _put(d.copyWith(acked: true, doneCount: d.doneCount + 1));
    AppOverlay.showSuccess(LocaleKeys.decisions_ackRecorded.tr());
  }

  Future<void> vote(String id, bool agree, String comment) async {
    final d = decisions.firstWhere((d) => d.id == id);
    await _put(d.copyWith(
      vote: agree,
      yes: d.yes + (agree ? 1 : 0),
      no: d.no + (agree ? 0 : 1),
    ));
    AppOverlay.showSuccess(LocaleKeys.decisions_voteRecorded.tr());
  }

  void remind(DecisionModel decision) {
    AppOverlay.showSuccess(LocaleKeys.decisions_reminderSent
        .tr(namedArgs: {'n': '${decision.pendingNames.length}'}));
  }

  Future<void> publish({
    required DecisionKind kind,
    required String title,
    required String body,
    required DecisionAudience audience,
    required String by,
  }) async {
    await _put(DecisionModel(
      id: 'd${DateTime.now().millisecondsSinceEpoch}',
      kind: kind,
      title: title,
      body: body,
      when: LocaleKeys.common_now.tr(),
      by: by,
      audience: audience,
      deadline: kind == DecisionKind.poll
          ? LocaleKeys.decisions_daysLeft.tr(namedArgs: {'n': '3'})
          : null,
    ));
    AppOverlay.showSuccess(LocaleKeys.decisions_published.tr());
  }
}
