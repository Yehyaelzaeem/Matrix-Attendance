import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/storage/local_storage.dart';
import 'models/demo_accounts.dart';
import 'models/register_payload.dart';
import 'models/user_model.dart';

class AuthRepo {
  AuthRepo({required DioClient dio, required LocalStorage storage})
      : _dio = dio,
        _storage = storage;

  final DioClient _dio;
  final LocalStorage _storage;

  Future<void> sendLoginOtp(String phone) async {
    if (DemoAccounts.isDemo(phone)) return;
    try {
      await _dio.post(ApiEndpoints.loginOtp, data: {'phone': phone});
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<void> register(RegisterPayload payload) async {
    try {
      final form = FormData.fromMap({
        ...payload.toJson(),
        'avatar': await MultipartFile.fromFile(payload.avatarPath),
      });
      await _dio.postForm(ApiEndpoints.register, form);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<UserModel> verifyOtp(
      {required String phone, required String code}) async {
    final demoUser = DemoAccounts.byPhone(phone);
    if (demoUser != null) return _startSession(demoUser, DemoAccounts.token);
    try {
      final response = await _dio.post(ApiEndpoints.verifyOtp, data: {
        'phone': phone,
        'code': code,
        'device_id': await _storage.getDeviceId(),
      });
      final data = response.data['data'] as Map<String, dynamic>;
      final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      return _startSession(user, data['token'] as String);
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<UserModel> _startSession(UserModel user, String token) async {
    await _storage.setToken(token);
    await _storage.setUser(user.toJson());
    return user;
  }

  bool get _isDemoSession => DemoAccounts.isDemo(cachedUser()?.phone);

  UserModel? cachedUser() {
    final json = _storage.getUser();
    if (json == null || !_storage.isLoggedIn) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(json));
  }

  Future<UserModel> fetchMe() async {
    if (_isDemoSession) return cachedUser()!;
    try {
      final response = await _dio.get(ApiEndpoints.me);
      final user =
          UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
      await _storage.setUser(user.toJson());
      return user;
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<UserModel> updateProfile({
    required String name,
    required String jobTitle,
    required String email,
  }) async {
    if (_isDemoSession) {
      final user = cachedUser()!.copyWith(
          name: name, jobTitle: jobTitle, email: email.isEmpty ? null : email);
      await _storage.setUser(user.toJson());
      return user;
    }
    try {
      final response = await _dio.put(ApiEndpoints.me, data: {
        'name': name,
        'job_title': jobTitle,
        'email': email.isEmpty ? null : email,
      });
      final user =
          UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
      await _storage.setUser(user.toJson());
      return user;
    } on DioException catch (e) {
      throw NetworkException.fromDioException(e);
    }
  }

  Future<void> logout() async {
    try {
      if (!_isDemoSession) await _dio.post(ApiEndpoints.logout);
    } on DioException catch (_) {
    } finally {
      await _storage.removeToken();
      await _storage.removeUser();
    }
  }
}
