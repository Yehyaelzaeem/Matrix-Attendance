import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_handler.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_reader.dart';
import 'models/board_entry.dart';

class BoardRepo with ApiHandler {
  BoardRepo({required DioClient dio}) : _dio = dio;

  final DioClient _dio;

  Future<BoardDay> getDay(DateTime date) async =>
      BoardDay.fromJson(await fetch(() => _dio.get(ApiEndpoints.board,
          queryParameters: {'date': JsonReader.formatDate(date)})));
}
