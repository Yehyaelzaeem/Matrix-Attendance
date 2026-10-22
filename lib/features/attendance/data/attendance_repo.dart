import 'package:dio/dio.dart';

import '../../../core/models/day_type.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_handler.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/services/location_service.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/json_reader.dart';
import 'models/attendance_day.dart';
import 'models/attendance_enums.dart';
import 'models/attendance_overview.dart';
import 'models/month_summary.dart';

class AttendanceRepo with ApiHandler {
  AttendanceRepo({required DioClient dio, required LocalStorage storage})
      : _dio = dio,
        _storage = storage;

  final DioClient _dio;
  final LocalStorage _storage;

  Map<String, dynamic> _today(Response response) {
    final data = dataOf(response);
    final today = JsonReader.mapOrNull(data['today']);
    return today ?? data;
  }

  Future<AttendanceOverview> getOverview() async {
    final now = DateTime.now();
    final results = await Future.wait([
      today(),
      schedule(),
      monthly(now.month, now.year),
    ]);
    final day = results[0] as (AttendanceDay, String);
    return AttendanceOverview(
      day: day.$1,
      lastCheckIn: day.$2,
      schedule: results[1] as WeeklySchedule,
      month: results[2] as MonthSummary,
    );
  }

  Future<(AttendanceDay, String)> today() => guard(() async {
        final json = _today(await _dio.get(ApiEndpoints.attendanceToday));
        return (
          AttendanceDay.fromJson(json),
          JsonReader.string(json['last_check_in_time'], '10:30'),
        );
      });

  Future<WeeklySchedule> schedule() => guard(() async {
        final data = dataOf(await _dio.get(ApiEndpoints.mySchedule));
        return scheduleFromJson(data['days']);
      });

  Future<MonthSummary> monthly(int month, int year) => guard(() async {
        final data = dataOf(await _dio.get(ApiEndpoints.myMonthlyAttendance,
            queryParameters: {'month': month, 'year': year}));
        return MonthSummary.fromJson(JsonReader.map(data['report']));
      });

  Future<AttendanceDay> checkIn(LocationFix fix) => guard(() async {
        final response = await _dio.post(ApiEndpoints.checkIn, data: {
          'lat': fix.lat,
          'lng': fix.lng,
          'accuracy': fix.accuracy,
          'is_mock': fix.isMock,
          'device_uuid': await _storage.getDeviceId(),
        });
        return AttendanceDay.fromJson(_today(response));
      });

  Future<AttendanceDay> pause(PauseReason reason, String note) =>
      guard(() async {
        final response = await _dio.post(ApiEndpoints.pause, data: {
          'reason': reason.name,
          'note': note.trim().isEmpty ? null : note.trim(),
        });
        return AttendanceDay.fromJson(_today(response));
      });

  Future<AttendanceDay> resume() => guard(() async =>
      AttendanceDay.fromJson(_today(await _dio.post(ApiEndpoints.resume))));

  Future<AttendanceDay> checkOut() => guard(() async =>
      AttendanceDay.fromJson(_today(await _dio.post(ApiEndpoints.checkOut))));
}
