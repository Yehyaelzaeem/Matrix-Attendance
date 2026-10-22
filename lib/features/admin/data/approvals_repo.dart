import '../../../core/models/paginated.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_handler.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_reader.dart';
import '../../auth/data/models/user_role.dart';
import '../../requests/data/models/request_model.dart';

class ApprovalsRepo with ApiHandler {
  ApprovalsRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<(Paginated<RequestModel>, RoleSummary)> _list(
    String path, {
    UserRole? role,
    String? status,
    int page = 1,
  }) =>
      guard(() async {
        final data = dataOf(await _dio.get(path, queryParameters: {
          'page': page,
          if (status != null) 'status': status,
          if (role != null) 'role': role.name,
        }));
        return (
          Paginated.fromData(data, 'requests', RequestModel.fromJson),
          RoleSummary.fromJson(data['summary']),
        );
      });

  Future<(Paginated<RequestModel>, RoleSummary)> pending(
          {UserRole? role, int page = 1}) =>
      _list(ApiEndpoints.adminRequests,
          role: role, status: 'pending', page: page);

  Future<(Paginated<RequestModel>, RoleSummary)> log(
          {UserRole? role, int page = 1}) =>
      _list(ApiEndpoints.approvalsLog, role: role, page: page);

  Future<RequestModel> approve(int id) => guard(() async {
        final data = dataOf(await _dio.post(ApiEndpoints.approveRequest(id)));
        return RequestModel.fromJson(JsonReader.map(data['request']));
      });

  Future<RequestModel> reject(int id, String reason) => guard(() async {
        final data = dataOf(await _dio
            .post(ApiEndpoints.rejectRequest(id), data: {'reason': reason}));
        return RequestModel.fromJson(JsonReader.map(data['request']));
      });
}
