import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/day_type.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../../auth/data/models/user_role.dart';
import '../../projects/data/projects_repo.dart';
import '../../projects/logic/projects_cubit.dart';
import '../data/models/employee_model.dart';
import '../data/team_repo.dart';
import 'team_cubit.dart';

part 'add_employee_state.dart';

class AddEmployeeCubit extends Cubit<AddEmployeeState> {
  AddEmployeeCubit(
      this._teamRepo, this._projectsRepo, this._team, this._projects)
      : super(const AddEmployeeInitial());

  final TeamRepo _teamRepo;
  final ProjectsRepo _projectsRepo;
  final TeamCubit _team;
  final ProjectsCubit _projects;

  Future<void> submit({
    required String name,
    required String phone,
    required String email,
    required UserRole role,
    required int jobNameId,
    required WeeklySchedule schedule,
    required Set<int> projectIds,
  }) async {
    if (state is AddEmployeeLoading || state is AddEmployeeSuccess) return;
    emit(const AddEmployeeLoading());
    final EmployeeModel created;
    try {
      created = await _teamRepo.create(
        name: name,
        phone: phone,
        email: email,
        role: role,
        jobNameId: jobNameId,
      );
    } catch (e) {
      final message = NetworkException.from(e).message;
      AppOverlay.showError(message);
      return emit(AddEmployeeError(message));
    }
    var employee = created;
    try {
      if (schedule != kDefaultSchedule) {
        employee = employee.copyWith(
            schedule: await _teamRepo.updateSchedule(employee.id, schedule));
      }
      _projects.putAll(await Future.wait([
        for (final id in projectIds)
          _projectsRepo.addMember(id, employee.id, employee.shortRole),
      ]));
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
    }
    _team.upsert(employee);
    emit(AddEmployeeSuccess(employee));
  }
}
