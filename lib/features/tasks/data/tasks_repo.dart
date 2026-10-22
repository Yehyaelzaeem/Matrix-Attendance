import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_handler.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_reader.dart';
import 'models/task_enums.dart';
import 'models/task_model.dart';

class TaskCounts {
  const TaskCounts({
    this.open = 0,
    this.late = 0,
    this.withReviewer = 0,
    this.doneThisWeek = 0,
  });

  final int open;
  final int late;
  final int withReviewer;
  final int doneThisWeek;

  factory TaskCounts.fromJson(dynamic json) {
    final map = JsonReader.map(json);
    return TaskCounts(
      open: JsonReader.toInt(map['open']),
      late: JsonReader.toInt(map['late']),
      withReviewer: JsonReader.toInt(map['with_reviewer']),
      doneThisWeek: JsonReader.toInt(map['done_this_week']),
    );
  }
}

class TasksRepo with ApiHandler {
  TasksRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  TaskModel _task(Response response) =>
      TaskModel.fromJson(JsonReader.map(dataOf(response)['task']));

  Future<(List<TaskModel>, TaskCounts)> getTasks({required bool mine}) =>
      guard(() async {
        final data = dataOf(
            await _dio.get(mine ? ApiEndpoints.myTasks : ApiEndpoints.tasks));
        return (
          JsonReader.list(data['tasks']).map(TaskModel.fromJson).toList(),
          TaskCounts.fromJson(data['counts']),
        );
      });

  Future<TaskModel> getTask(int id) =>
      guard(() async => _task(await _dio.get(ApiEndpoints.task(id))));

  Future<TaskModel> transition(int id, TaskStatus to, {String? comment}) =>
      guard(() async =>
          _task(await _dio.post(ApiEndpoints.taskTransition(id), data: {
            'to': to.name,
            if (comment != null && comment.isNotEmpty) 'comment': comment,
          })));

  Future<TaskModel> update(int id, Map<String, dynamic> body) => guard(
      () async => _task(await _dio.patch(ApiEndpoints.task(id), data: body)));

  Future<TaskComment> addComment(int id, String text) =>
      guard(() async => TaskComment.fromJson(JsonReader.map(dataOf(await _dio
          .post(ApiEndpoints.taskComments(id),
              data: {'text': text}))['comment'])));

  Future<void> logTime(int id, double hours) =>
      guard(() => _dio.post(ApiEndpoints.taskTime(id), data: {'hours': hours}));

  Future<TaskAttachment> upload(int id, String path) => guard(() async =>
      TaskAttachment.fromJson(JsonReader.map(dataOf(await _dio.postForm(
          ApiEndpoints.taskAttachments(id),
          FormData.fromMap(
              {'file': await MultipartFile.fromFile(path)})))['attachment'])));

  Future<void> removeAttachment(int id, int attachmentId) =>
      guard(() => _dio.delete(ApiEndpoints.taskAttachment(id, attachmentId)));

  Future<TaskModel> create(Map<String, dynamic> body, List<String> files) =>
      guard(() async {
        if (files.isEmpty) {
          return _task(await _dio.post(ApiEndpoints.tasks, data: body));
        }
        final form = FormData.fromMap(body);
        for (final path in files) {
          form.files.add(
              MapEntry('attachments[]', await MultipartFile.fromFile(path)));
        }
        return _task(await _dio.postForm(ApiEndpoints.tasks, form));
      });

  Future<void> delete(int id) =>
      guard(() => _dio.delete(ApiEndpoints.task(id)));
}
