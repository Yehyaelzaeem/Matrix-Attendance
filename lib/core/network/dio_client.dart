import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/router/navigation_services.dart';
import '../../app/session_scope.dart';
import '../../app/router/routes.dart';
import '../di/injection.dart';
import '../storage/local_storage.dart';
import '../utils/app_overlay.dart';
import '../utils/locale_keys.dart';
import 'api_endpoints.dart';

class DioClient {
  DioClient({required LocalStorage storage}) {
    _dio = _buildDio(storage);
  }

  late final Dio _dio;

  static const Duration _connectTimeout = Duration(seconds: 30);
  static const Duration _receiveTimeout = Duration(seconds: 30);

  Dio _buildDio(LocalStorage storage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        validateStatus: (status) => status != null && status < 300,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(_AuthInterceptor(storage));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Accept-Language'] = getIt<LocalStorage>().getLang();
          return handler.next(options);
        },
      ),
    );
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
        compact: true,
      ));
    }

    return dio;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.get<T>(path, queryParameters: queryParameters, options: options);

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.post<T>(path,
          data: data, queryParameters: queryParameters, options: options);

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.put<T>(path,
          data: data, queryParameters: queryParameters, options: options);

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.patch<T>(path,
          data: data, queryParameters: queryParameters, options: options);

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) =>
      _dio.delete<T>(path,
          data: data, queryParameters: queryParameters, options: options);

  Future<Response<T>> postForm<T>(
    String path,
    FormData formData, {
    Map<String, dynamic>? queryParameters,
    void Function(int sent, int total)? onSendProgress,
  }) =>
      _dio.post<T>(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: Options(contentType: 'multipart/form-data'),
        onSendProgress: onSendProgress,
      );

  Future<Response<T>> patchForm<T>(
    String path,
    FormData formData, {
    Map<String, dynamic>? queryParameters,
  }) =>
      _dio.patch<T>(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: Options(contentType: 'multipart/form-data'),
      );

  Future<Response<T>> putForm<T>(
    String path,
    FormData formData, {
    Map<String, dynamic>? queryParameters,
    void Function(int sent, int total)? onSendProgress,
  }) =>
      _dio.put<T>(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: Options(contentType: 'multipart/form-data'),
        onSendProgress: onSendProgress,
      );
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._storage);
  final LocalStorage _storage;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final hadSession = err.requestOptions.headers.containsKey('Authorization');
    if (err.response?.statusCode == 401 && hadSession) {
      await _storage.clearAll();
      await SessionScope.restart();
      AppOverlay.showError(LocaleKeys.error_unauthorized.tr());
      NavigationService.navigationKey.currentState
          ?.pushNamedAndRemoveUntil(Routes.loginScreen, (_) => false);
    }
    handler.next(err);
  }
}
