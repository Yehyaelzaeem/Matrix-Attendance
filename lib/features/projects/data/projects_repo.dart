import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_handler.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_reader.dart';
import 'models/project_model.dart';

class ProjectsRepo with ApiHandler {
  ProjectsRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  ProjectModel _project(Response response) =>
      ProjectModel.fromJson(JsonReader.map(dataOf(response)['project']));

  Future<List<ProjectModel>> getProjects() => guard(() async {
        final data = dataOf(await _dio.get(ApiEndpoints.projects));
        return JsonReader.list(data['projects'])
            .map(ProjectModel.fromJson)
            .toList();
      });

  Future<ProjectModel> getProject(int id) =>
      guard(() async => _project(await _dio.get(ApiEndpoints.project(id))));

  Future<ProjectModel> create(Map<String, dynamic> body) => guard(() async =>
      _project(await _dio.post(ApiEndpoints.adminProjects, data: body)));

  Future<ProjectModel> setStatus(int id, ProjectStatus status) =>
      guard(() async => _project(await _dio
          .put(ApiEndpoints.projectStatus(id), data: {'status': status.name})));

  Future<ProjectModel> addMember(int id, int userId, String role) => guard(
      () async => _project(await _dio.post(ApiEndpoints.projectMembers(id),
          data: {'user_id': userId, 'role_label': role})));

  Future<ProjectModel> removeMember(int id, int userId) => guard(() async =>
      _project(await _dio.delete(ApiEndpoints.projectMember(id, userId))));

  Future<ProjectModel> setManager(int id, int? userId) =>
      guard(() async => _project(await _dio
          .put(ApiEndpoints.projectManager(id), data: {'manager_id': userId})));

  Future<ProjectModel> updateClient(int id, ClientInfo client) => guard(
      () async => _project(await _dio.patch(ApiEndpoints.projectClient(id),
          data: client.toJson()..removeWhere((_, v) => v.isEmpty))));

  Future<ProjectModel> uploadContract(int id, String path) =>
      guard(() async => _project(await _dio.postForm(
          ApiEndpoints.projectContractFile(id),
          FormData.fromMap({'file': await MultipartFile.fromFile(path)}))));

  Future<PaymentModel> addPayment(
          int id, String label, double amount, DateTime due) =>
      guard(() async => PaymentModel.fromJson(JsonReader.map(
              dataOf(await _dio.post(ApiEndpoints.projectPayments(id), data: {
            'label': label,
            'amount': amount,
            'due_date': JsonReader.formatDate(due),
          }))['payment'])));

  Future<PaymentModel> markPaid(int id, int paymentId) =>
      guard(() async => PaymentModel.fromJson(JsonReader.map(
          dataOf(await _dio.post(ApiEndpoints.payPayment(id, paymentId)))[
              'payment'])));
}
