import '../../../core/models/paginated.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_handler.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_reader.dart';
import 'models/decision_model.dart';

class DecisionsRepo with ApiHandler {
  DecisionsRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<(Paginated<DecisionModel>, int)> list(
          {required bool admin, int page = 1}) =>
      guard(() async {
        final data = dataOf(await _dio.get(
            admin
                ? ApiEndpoints.adminAnnouncements
                : ApiEndpoints.announcements,
            queryParameters: {'page': page}));
        return (
          Paginated.fromData(data, 'announcements', DecisionModel.fromJson),
          JsonReader.toInt(data['unread_count']),
        );
      });

  Future<Map<String, dynamic>> acknowledge(int id) =>
      guard(() async => JsonReader.map(dataOf(
          await _dio.post(ApiEndpoints.ackAnnouncement(id)))['announcement']));

  Future<Map<String, dynamic>> vote(int id, bool agree, String comment) =>
      guard(() async => JsonReader.map(
              dataOf(await _dio.post(ApiEndpoints.voteAnnouncement(id), data: {
            'vote': agree ? 'yes' : 'no',
            if (comment.isNotEmpty) 'comment': comment,
          }))['announcement']));

  Future<List<PollVoter>> voters(int id) => guard(() async {
        final data =
            dataOf(await _dio.get(ApiEndpoints.announcementVoters(id)));
        return JsonReader.list(data['voters']).map(PollVoter.fromJson).toList();
      });

  Future<int> remind(int id) => guard(() async => JsonReader.toInt(dataOf(
      await _dio.post(ApiEndpoints.remindAnnouncement(id)))['reminded_count']));

  Future<DecisionModel> publish({
    required DecisionKind kind,
    required String title,
    required String body,
    required DecisionAudience audience,
    DateTime? endsAt,
  }) =>
      guard(() async {
        final data =
            dataOf(await _dio.post(ApiEndpoints.adminAnnouncements, data: {
          'kind': kind.name,
          'title': title,
          'body': body,
          'audience': audience.toJson(),
          'is_pinned': kind == DecisionKind.decision,
          if (kind == DecisionKind.poll && endsAt != null)
            'ends_at': JsonReader.formatDate(endsAt),
        }));
        return DecisionModel.fromJson(JsonReader.map(data['announcement']));
      });
}
