import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/team_repo.dart';

class EmployeeDetailState extends Equatable {
  const EmployeeDetailState({this.detail, this.loading = true, this.error});

  final EmployeeDetail? detail;
  final bool loading;
  final String? error;

  @override
  List<Object?> get props =>
      [detail?.employee, detail?.metrics, loading, error];
}

class EmployeeDetailCubit extends Cubit<EmployeeDetailState> {
  EmployeeDetailCubit(this._repo) : super(const EmployeeDetailState());

  final TeamRepo _repo;

  Future<void> load(int id) async {
    if (state.detail == null) emit(const EmployeeDetailState());
    try {
      emit(EmployeeDetailState(
          detail: await _repo.getEmployee(id), loading: false));
    } catch (e) {
      emit(EmployeeDetailState(
          detail: state.detail,
          loading: false,
          error: NetworkException.from(e).message));
    }
  }
}
