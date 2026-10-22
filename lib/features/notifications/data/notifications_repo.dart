import '../../../core/models/paginated.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_handler.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_reader.dart';
import 'models/notification_model.dart';

class NotificationsRepo with ApiHandler {
  NotificationsRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<(Paginated<NotificationModel>, int)> list({int page = 1}) =>
      guard(() async {
        final data = dataOf(await _dio
            .get(ApiEndpoints.notifications, queryParameters: {'page': page}));
        return (
          Paginated.fromData(data, 'notifications', NotificationModel.fromJson),
          JsonReader.toInt(data['unread_count']),
        );
      });

  Future<void> markRead(int id) =>
      guard(() => _dio.post(ApiEndpoints.readNotification(id)));
}
