import '../../../core/models/paginated.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_handler.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_reader.dart';
import 'models/request_model.dart';

class RequestsRepo with ApiHandler {
  RequestsRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<(Paginated<RequestModel>, RequestSummary)> getMyRequests({
    RequestStatus? status,
    int page = 1,
  }) =>
      guard(() async {
        final data =
            dataOf(await _dio.get(ApiEndpoints.requests, queryParameters: {
          'page': page,
          if (status != null) 'status': status.name,
        }));
        return (
          Paginated.fromData(data, 'requests', RequestModel.fromJson),
          RequestSummary.fromJson(data['summary']),
        );
      });

  Future<RequestModel> submit({
    required RequestType type,
    required String reason,
    required Map<String, dynamic> payload,
  }) =>
      guard(() async {
        final data = dataOf(await _dio.post(ApiEndpoints.requests, data: {
          'type': type.key,
          'reason': reason,
          'payload': payload,
        }));
        return RequestModel.fromJson(JsonReader.map(data['request']));
      });
}
