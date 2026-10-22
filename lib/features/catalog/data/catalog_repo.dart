import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_handler.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_reader.dart';
import '../../auth/data/models/job_name_model.dart';

class CatalogRepo with ApiHandler {
  CatalogRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<List<JobCategoryModel>> categories() => guard(() async {
        final data = dataOf(await _dio.get(ApiEndpoints.jobCategories));
        return JsonReader.list(data['job_categories'])
            .map(JobCategoryModel.fromJson)
            .toList();
      });

  Future<List<JobNameModel>> jobNames() => guard(() async {
        final data = dataOf(await _dio.get(ApiEndpoints.jobNames));
        return JsonReader.list(data['job_names'])
            .map(JobNameModel.fromJson)
            .whereType<JobNameModel>()
            .toList();
      });
}
