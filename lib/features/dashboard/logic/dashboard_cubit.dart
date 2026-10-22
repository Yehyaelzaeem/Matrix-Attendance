import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/json_reader.dart';
import '../../reports/data/models/employee_report.dart';
import '../../reports/data/reports_repo.dart';
import '../data/dashboard_repo.dart';
import '../data/models/dashboard_models.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repo, this._reports) : super(const DashboardState());

  final DashboardRepo _repo;
  final ReportsRepo _reports;

  Future<void> loadAdmin() async {
    emit(state.copyWith(loading: state.admin == null, clearError: true));
    try {
      emit(state.copyWith(admin: await _repo.admin(), loading: false));
    } catch (e) {
      _fail(e);
    }
  }

  Future<void> loadReviewer() async {
    emit(state.copyWith(loading: state.reviewer == null, clearError: true));
    try {
      final results = await Future.wait([
        _repo.reviewer(),
        _reports.board(
          month: JsonReader.formatMonth(DateTime.now()),
          mode: ReportMode.attendance,
          sortDesc: false,
        ),
      ]);
      emit(state.copyWith(
        reviewer: results[0] as ReviewerDashboard,
        followUp: (results[1] as ReportBoard).people.take(3).toList(),
        loading: false,
      ));
    } catch (e) {
      _fail(e);
    }
  }

  void _fail(Object e) {
    final msg = NetworkException.from(e).message;
    if (state.admin != null || state.reviewer != null) {
      AppOverlay.showError(msg);
      emit(state.copyWith(loading: false));
    } else {
      emit(state.copyWith(loading: false, error: msg));
    }
  }
}
