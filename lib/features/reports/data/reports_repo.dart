import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_handler.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_reader.dart';
import 'models/employee_report.dart';

class CloseCheck {
  const CloseCheck({
    required this.allReviewed,
    required this.done,
    required this.total,
    required this.noPendingFixes,
    required this.noOpenDays,
    required this.canClose,
  });

  final bool allReviewed;
  final int done;
  final int total;
  final bool noPendingFixes;
  final bool noOpenDays;
  final bool canClose;
}

class ReportsRepo with ApiHandler {
  ReportsRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<ReportBoard> board({
    required String month,
    required ReportMode mode,
    required bool sortDesc,
  }) =>
      guard(() async {
        final data = dataOf(
            await _dio.get(ApiEndpoints.monthlyReports, queryParameters: {
          'month': month,
          'mode': mode.key,
          'sort': sortDesc ? 'desc' : 'asc',
        }));
        return ReportBoard.fromJson(data, mode);
      });

  Future<EmployeeReportDetail> detail(int userId, String month) =>
      guard(() async {
        final data = dataOf(await _dio.get(ApiEndpoints.monthlyReport(userId),
            queryParameters: {'month': month}));
        return EmployeeReportDetail.fromJson(JsonReader.map(data['report']));
      });

  Future<void> setReviewed(String month, int userId, bool reviewed) =>
      guard(() => reviewed
          ? _dio.put(ApiEndpoints.review(month, userId))
          : _dio.delete(ApiEndpoints.review(month, userId)));

  Future<void> reviewAll(String month) =>
      guard(() => _dio.post(ApiEndpoints.reviewAll(month)));

  Future<CloseCheck> closeCheck(String month) => guard(() async {
        final data = dataOf(await _dio.get(ApiEndpoints.closeCheck(month)));
        final all = JsonReader.map(data['all_reviewed']);
        return CloseCheck(
          allReviewed: JsonReader.toBool(all['ok']),
          done: JsonReader.toInt(all['done']),
          total: JsonReader.toInt(all['total']),
          noPendingFixes:
              JsonReader.toBool(JsonReader.map(data['no_pending_fixes'])['ok']),
          noOpenDays:
              JsonReader.toBool(JsonReader.map(data['no_open_days'])['ok']),
          canClose: JsonReader.toBool(data['can_close']),
        );
      });

  Future<void> close(String month) =>
      guard(() => _dio.post(ApiEndpoints.closeMonth(month)));

  Future<void> reopen(String month, String reason) => guard(() =>
      _dio.post(ApiEndpoints.reopenMonth(month), data: {'reason': reason}));
}
