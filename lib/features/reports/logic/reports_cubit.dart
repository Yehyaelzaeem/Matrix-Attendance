import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/utils/locale_keys.dart';
import '../data/models/employee_report.dart';
import '../data/reports_repo.dart';

part 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit(this._repo) : super(const ReportsInitial());

  final ReportsRepo _repo;

  ReportsSuccess? get data =>
      state is ReportsSuccess ? state as ReportsSuccess : null;

  Future<void> load() async {
    if (state is ReportsSuccess) return;
    emit(const ReportsLoading());
    try {
      final reports = await _repo.getMonthReports();
      emit(ReportsSuccess(
        reports: reports,
        reviewed: {
          reports[0].name,
          reports[3].name,
          reports[4].name,
          reports[8].name
        },
      ));
    } catch (_) {
      final msg = LocaleKeys.error_generic.tr();
      AppOverlay.showError(msg);
      emit(ReportsError(msg));
    }
  }

  void setMode(ReportMode mode) => _update((d) => d.copyWith(mode: mode));

  void setSortDesc(bool desc) => _update((d) => d.copyWith(sortDesc: desc));

  void viewPrevious(bool previous) =>
      _update((d) => d.copyWith(viewingPrevious: previous));

  void toggleReviewed(String name) {
    final d = data;
    if (d == null) return;
    final reviewed = {...d.reviewed};
    if (!reviewed.remove(name)) {
      reviewed.add(name);
      AppOverlay.showSuccess(
          LocaleKeys.reports_toastReviewed.tr(namedArgs: {'name': name}));
    }
    emit(d.copyWith(reviewed: reviewed));
  }

  void markAllReviewed() {
    _update((d) => d.copyWith(reviewed: {for (final r in d.reports) r.name}));
    AppOverlay.showSuccess(LocaleKeys.reports_toastAllReviewed.tr());
  }

  void closeMonth() {
    _update((d) => d.copyWith(currentClosed: true));
    AppOverlay.showSuccess(LocaleKeys.reports_toastClosed
        .tr(namedArgs: {'month': DateHelper.monthName(DateTime.now().month)}));
  }

  void reopenMonth(String reason) {
    _update((d) => d.viewingPrevious ? d : d.copyWith(currentClosed: false));
    AppOverlay.showSuccess(LocaleKeys.reports_toastReopened.tr());
  }

  void _update(ReportsSuccess Function(ReportsSuccess d) f) {
    final d = data;
    if (d != null) emit(f(d));
  }
}
