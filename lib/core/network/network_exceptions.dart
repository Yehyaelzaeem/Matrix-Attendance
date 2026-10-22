import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../utils/locale_keys.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException(this.message, {this.statusCode});

  bool get isConnection => statusCode == 0 || statusCode == 408;

  factory NetworkException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(LocaleKeys.error_timeout.tr(), statusCode: 408);

      case DioExceptionType.connectionError:
        return NetworkException(LocaleKeys.error_noInternet.tr(),
            statusCode: 0);

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message =
            _extractMessage(e.response?.data) ?? LocaleKeys.error_generic.tr();
        return NetworkException(message, statusCode: statusCode);

      default:
        return NetworkException(LocaleKeys.error_generic.tr());
    }
  }

  static NetworkException from(Object error) => switch (error) {
        NetworkException e => e,
        DioException e => NetworkException.fromDioException(e),
        _ => NetworkException(LocaleKeys.error_generic.tr()),
      };

  static String? _extractMessage(dynamic data) {
    if (data is! Map) return null;
    for (final key in const ['message', 'error']) {
      final value = data[key];
      if (value is String && value.isNotEmpty) return value;
      if (value is List && value.isNotEmpty) return value.first.toString();
    }
    final errors = data['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) return first.first.toString();
    }
    return null;
  }

  @override
  String toString() => message;
}
