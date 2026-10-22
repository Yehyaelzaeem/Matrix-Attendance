import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/models/employee_report.dart';
import '../data/reports_repo.dart';

class ReportDetailState extends Equatable {
  const ReportDetailState({this.detail, this.loading = true, this.error});

  final EmployeeReportDetail? detail;
  final bool loading;
  final String? error;

  @override
  List<Object?> get props => [detail, loading, error];
}

class ReportDetailCubit extends Cubit<ReportDetailState> {
  ReportDetailCubit(this._repo) : super(const ReportDetailState());

  final ReportsRepo _repo;

  Future<void> load(int userId, String month) async {
    emit(const ReportDetailState());
    try {
      emit(ReportDetailState(
          detail: await _repo.detail(userId, month), loading: false));
    } catch (e) {
      emit(ReportDetailState(
          loading: false, error: NetworkException.from(e).message));
    }
  }
}
