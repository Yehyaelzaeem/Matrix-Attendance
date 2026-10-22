import 'package:dio/dio.dart';

import '../utils/json_reader.dart';
import 'network_exceptions.dart';

mixin ApiHandler {
  Future<T> guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Map<String, dynamic> dataOf(Response response) =>
      JsonReader.map(JsonReader.map(response.data)['data']);

  Future<Map<String, dynamic>> fetch(Future<Response> Function() request) =>
      guard(() async => dataOf(await request()));
}
