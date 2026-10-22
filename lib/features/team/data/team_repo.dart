import 'package:dio/dio.dart';

import '../../../core/models/day_type.dart';
import '../../../core/models/paginated.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_handler.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_reader.dart';
import '../../auth/data/models/user_role.dart';
import '../../projects/data/models/project_model.dart';
import '../../tasks/data/models/task_model.dart';
import 'models/app_settings.dart';
import 'models/employee_model.dart';
import 'models/holiday_model.dart';

class EmployeeDetail {
  const EmployeeDetail({
    required this.employee,
    required this.metrics,
    required this.projects,
    required this.tasks,
  });

  final EmployeeModel employee;
  final EmployeeMetrics metrics;
  final List<ProjectModel> projects;
  final List<TaskModel> tasks;
}

class TeamRepo with ApiHandler {
  TeamRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  EmployeeModel _user(Response response) =>
      EmployeeModel.fromJson(JsonReader.map(dataOf(response)['user']));

  Future<List<EmployeeModel>> getEmployees() => guard(() async {
        final results = await Future.wait([
          _dio.get(ApiEndpoints.users),
          _dio.get(ApiEndpoints.adminSchedules),
        ]);
        final schedules = <int, WeeklySchedule>{
          for (final row in JsonReader.list(dataOf(results[1])['users']))
            JsonReader.toInt(JsonReader.map(row['user'])['id']):
                scheduleFromJson(row['days']),
        };
        return [
          for (final json in JsonReader.list(dataOf(results[0])['users']))
            EmployeeModel.fromJson(json,
                schedule: schedules[JsonReader.toInt(json['id'])]),
        ];
      });

  Future<Paginated<EmployeeModel>> searchEmployees(
          {String search = '', int page = 1}) =>
      guard(() async {
        final data =
            dataOf(await _dio.get(ApiEndpoints.users, queryParameters: {
          'page': page,
          if (search.trim().isNotEmpty) 'search': search.trim(),
        }));
        return Paginated.fromData(data, 'users', EmployeeModel.fromJson);
      });

  Future<EmployeeDetail> getEmployee(int id) => guard(() async {
        final user = JsonReader.map(
            dataOf(await _dio.get(ApiEndpoints.user(id)))['user']);
        final metrics = JsonReader.map(user['metrics']);
        return EmployeeDetail(
          employee: EmployeeModel.fromJson(user),
          metrics: EmployeeMetrics(
            attendance: JsonReader.intOrNull(metrics['attendance']),
            kpi: JsonReader.intOrNull(metrics['tasks_kpi']),
            overall: JsonReader.intOrNull(metrics['overall_rating']),
          ),
          projects: JsonReader.list(user['projects'])
              .map(ProjectModel.fromJson)
              .toList(),
          tasks:
              JsonReader.list(user['tasks']).map(TaskModel.fromJson).toList(),
        );
      });

  Future<EmployeeModel> create({
    required String name,
    required String phone,
    required String email,
    required UserRole role,
    required int jobNameId,
  }) =>
      guard(() async => _user(await _dio.post(ApiEndpoints.users, data: {
            'name': name,
            'phone': phone,
            'email': email.isEmpty ? null : email,
            'role': role.name,
            'job_name_id': jobNameId,
          })));

  Future<EmployeeModel> updateRole(EmployeeModel employee, UserRole role) =>
      guard(() async =>
          _user(await _dio.put(ApiEndpoints.user(employee.id), data: {
            'name': employee.name,
            'phone': employee.phone,
            'email': employee.email.isEmpty ? null : employee.email,
            'role': role.name,
            'job_name_id': employee.jobNameId,
            'org_title_ar': employee.orgTitle,
          })));

  Future<EmployeeModel> suspend(int id) =>
      guard(() async => _user(await _dio.post(ApiEndpoints.suspendUser(id))));

  Future<EmployeeModel> activate(int id) =>
      guard(() async => _user(await _dio.post(ApiEndpoints.activateUser(id))));

  Future<void> resetDevice(int id) =>
      guard(() => _dio.post(ApiEndpoints.resetUserDevice(id)));

  Future<WeeklySchedule> updateSchedule(int id, WeeklySchedule schedule) =>
      guard(() async => scheduleFromJson(dataOf(await _dio.put(
          ApiEndpoints.userSchedule(id),
          data: {'days': scheduleToJson(schedule)}))['days']));

  Future<AppSettings> getSettings() =>
      guard(() async => AppSettings.fromJson(JsonReader.map(
          dataOf(await _dio.get(ApiEndpoints.settings))['settings'])));

  Future<Paginated<HolidayModel>> getHolidays({int page = 1}) =>
      guard(() async {
        final data = dataOf(await _dio
            .get(ApiEndpoints.holidays, queryParameters: {'page': page}));
        return Paginated.fromData(data, 'holidays', HolidayModel.fromJson);
      });

  Future<HolidayModel> addHoliday(DateTime date, String name) =>
      guard(() async => HolidayModel.fromJson(JsonReader.map(
              dataOf(await _dio.post(ApiEndpoints.holidays, data: {
            'date': JsonReader.formatDate(date),
            'name_ar': name,
          }))['holiday'])));
}
