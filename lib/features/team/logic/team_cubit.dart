import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/day_type.dart';
import '../../../core/models/paginated.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/utils/validators.dart';
import '../../auth/data/models/user_role.dart';
import '../data/models/app_settings.dart';
import '../data/models/employee_model.dart';
import '../data/models/holiday_model.dart';
import '../data/team_repo.dart';

part 'team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  TeamCubit(this._repo) : super(const TeamInitial());

  final TeamRepo _repo;

  TeamSuccess? get _data => state is TeamSuccess ? state as TeamSuccess : null;

  List<EmployeeModel> get employees => _data?.employees ?? const [];

  EmployeeModel? byId(int id) => _data?.byId(id);

  Future<void> load() async {
    if (state is TeamSuccess || state is TeamLoading) return;
    emit(const TeamLoading());
    await refresh();
  }

  Future<void> refresh() async {
    try {
      final results = await Future.wait([
        _repo.getEmployees(),
        _repo.getHolidays(),
      ]);
      emit(TeamSuccess(
        employees: results[0] as List<EmployeeModel>,
        holidays: results[1] as Paginated<HolidayModel>,
      ));
    } catch (e) {
      final msg = NetworkException.from(e).message;
      if (_data == null) {
        emit(TeamError(msg));
      } else {
        AppOverlay.showError(msg);
      }
    }
  }

  void _replace(EmployeeModel updated) {
    final current = _data;
    if (current == null) return;
    final exists = current.byId(updated.id) != null;
    emit(current.copyWith(
      employees: exists
          ? [
              for (final e in current.employees)
                e.id == updated.id ? updated : e
            ]
          : [...current.employees, updated],
    ));
  }

  Future<bool> updateEmployee(
    EmployeeModel employee, {
    UserRole? role,
    WeeklySchedule? schedule,
  }) async {
    try {
      var updated = employee;
      if (role != null && role != employee.role) {
        updated = (await _repo.updateRole(employee, role))
            .copyWith(schedule: updated.schedule);
      }
      if (schedule != null && schedule != employee.schedule) {
        updated = updated.copyWith(
            schedule: await _repo.updateSchedule(employee.id, schedule));
      }
      _replace(updated);
      AppOverlay.showSuccess(LocaleKeys.team_savedToast
          .tr(namedArgs: {'name': Validators.firstName(employee.name)}));
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }

  Future<bool> setSuspended(EmployeeModel employee, bool suspended) async {
    try {
      final updated = suspended
          ? await _repo.suspend(employee.id)
          : await _repo.activate(employee.id);
      _replace(updated.copyWith(schedule: employee.schedule));
      if (suspended) {
        AppOverlay.showError(LocaleKeys.team_suspendedToast.tr());
      } else {
        AppOverlay.showSuccess(LocaleKeys.team_activatedToast.tr());
      }
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }

  Future<bool> resetDevice(EmployeeModel employee) async {
    try {
      await _repo.resetDevice(employee.id);
      AppOverlay.showSuccess(LocaleKeys.team_deviceResetToast.tr());
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }

  void upsert(EmployeeModel employee) => _replace(employee);

  Future<AppSettings?> settings() async {
    try {
      return _settings ??= await _repo.getSettings();
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return null;
    }
  }

  AppSettings? _settings;

  Future<void> loadMoreHolidays() async {
    final current = _data;
    final page = current?.holidays;
    if (current == null || page == null || !page.hasMore || page.loadingMore) {
      return;
    }
    emit(current.copyWith(holidays: page.copyWith(loadingMore: true)));
    try {
      final next = await _repo.getHolidays(page: page.nextPage);
      emit(current.copyWith(holidays: page.append(next)));
    } catch (e) {
      emit(current);
      AppOverlay.showError(NetworkException.from(e).message);
    }
  }

  Future<bool> addHoliday(DateTime date, String name) async {
    try {
      final holiday = await _repo.addHoliday(date, name);
      final current = _data;
      if (current != null) {
        final items = [...current.holidays.items, holiday]
          ..sort((a, b) => a.date.compareTo(b.date));
        emit(current.copyWith(
            holidays: current.holidays
                .copyWith(items: items, total: current.holidays.total + 1)));
      }
      AppOverlay.showSuccess(LocaleKeys.team_holidayAdded.tr());
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }
}
