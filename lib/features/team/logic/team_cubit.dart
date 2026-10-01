import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/day_type.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../auth/data/models/user_role.dart';
import '../data/models/employee_model.dart';
import '../data/models/holiday_model.dart';
import '../data/team_repo.dart';

part 'team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  TeamCubit(this._repo) : super(const TeamInitial());

  final TeamRepo _repo;

  List<EmployeeModel> get employees =>
      state is TeamSuccess ? (state as TeamSuccess).employees : const [];

  Future<void> load() async {
    if (state is TeamSuccess) return;
    emit(const TeamLoading());
    try {
      final employees = await _repo.getEmployees();
      final holidays = await _repo.getHolidays();
      emit(TeamSuccess(employees: employees, holidays: holidays));
    } catch (_) {
      final msg = LocaleKeys.error_generic.tr();
      AppOverlay.showError(msg);
      emit(TeamError(msg));
    }
  }

  Future<void> updateEmployee(
    String name, {
    UserRole? role,
    WeeklySchedule? schedule,
    bool? suspended,
  }) async {
    final current = state;
    if (current is! TeamSuccess) return;
    final updated = await _repo.updateEmployee(name,
        role: role, schedule: schedule, suspended: suspended);
    emit(TeamSuccess(
      employees: [
        for (final e in current.employees) e.name == name ? updated : e
      ],
      holidays: current.holidays,
    ));
  }

  Future<void> addEmployee(EmployeeModel employee) async {
    final current = state;
    if (current is! TeamSuccess) return;
    await _repo.addEmployee(employee);
    emit(TeamSuccess(
        employees: [...current.employees, employee],
        holidays: current.holidays));
  }

  Future<void> addHoliday(DateTime date, String name) async {
    final current = state;
    if (current is! TeamSuccess) return;
    final holiday = await _repo.addHoliday(date, name);
    final holidays = [...current.holidays, holiday]
      ..sort((a, b) => a.date.compareTo(b.date));
    emit(TeamSuccess(employees: current.employees, holidays: holidays));
    AppOverlay.showSuccess(LocaleKeys.team_holidayAdded.tr());
  }
}
