import 'dart:io';

class ApiEndpoints {
  ApiEndpoints._();

  static const String _override = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    return Platform.isAndroid
        ? 'http://10.0.2.2:8000/api/v1/'
        : 'http://127.0.0.1:8000/api/v1/';
  }

  static const String loginOtp = 'auth/login/otp';
  static const String register = 'auth/register';
  static const String verifyOtp = 'auth/otp/verify';
  static const String me = 'auth/me';
  static const String logout = 'auth/logout';
}
