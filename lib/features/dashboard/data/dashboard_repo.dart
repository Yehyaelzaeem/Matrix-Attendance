import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_handler.dart';
import '../../../core/network/dio_client.dart';
import 'models/dashboard_models.dart';

class DashboardRepo with ApiHandler {
  DashboardRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<AdminDashboard> admin() async => AdminDashboard.fromJson(
      await fetch(() => _dio.get(ApiEndpoints.adminDashboard)));

  Future<ReviewerDashboard> reviewer() async => ReviewerDashboard.fromJson(
      await fetch(() => _dio.get(ApiEndpoints.reviewerDashboard)));
}
