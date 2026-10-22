import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_handler.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/json_reader.dart';
import 'models/device_model.dart';
import 'models/user_model.dart';

class AuthRepo with ApiHandler {
  AuthRepo({required DioClient dio, required LocalStorage storage})
      : _dio = dio,
        _storage = storage;

  final DioClient _dio;
  final LocalStorage _storage;

  Future<void> sendLoginOtp(String phone) =>
      guard(() => _dio.post(ApiEndpoints.login, data: {'phone': phone}));

  Future<void> resendOtp(String phone) =>
      guard(() => _dio.post(ApiEndpoints.resendOtp, data: {'phone': phone}));

  Future<UserModel> verifyOtp({
    required String phone,
    required String code,
    String? pushToken,
  }) =>
      guard(() async {
        final response = await _dio.post(ApiEndpoints.verifyOtp, data: {
          'phone': phone,
          'otp': code,
          'device_uuid': await _storage.getDeviceId(),
          'platform': Platform.isIOS ? 'ios' : 'android',
          'model': null,
          'push_token': pushToken,
        });
        final data = dataOf(response);
        final user = UserModel.fromJson(JsonReader.map(data['user']));
        await _storage.setToken(JsonReader.string(data['token']));
        await _storage.setUser(user.toJson());
        return user;
      });

  UserModel? cachedUser() {
    final json = _storage.getUser();
    if (json == null || !_storage.isLoggedIn) return null;
    try {
      return UserModel.fromJson(Map<String, dynamic>.from(json));
    } catch (_) {
      return null;
    }
  }

  Future<UserModel> fetchMe() => guard(() async {
        final response = await _dio.get(ApiEndpoints.me);
        final user =
            UserModel.fromJson(JsonReader.map(dataOf(response)['user']));
        await _storage.setUser(user.toJson());
        return user;
      });

  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? email,
    String? orgTitle,
    String? imagePath,
  }) =>
      guard(() async {
        final fields = <String, dynamic>{
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
          if (email != null) 'email': email.isEmpty ? null : email,
          if (orgTitle != null) 'org_title_ar': orgTitle,
        };
        final Response response;
        if (imagePath != null) {
          response = await _dio.patchForm(
            ApiEndpoints.me,
            FormData.fromMap({
              ...fields,
              'image': await MultipartFile.fromFile(imagePath),
            }),
          );
        } else {
          response = await _dio.patch(ApiEndpoints.me, data: fields);
        }
        final user =
            UserModel.fromJson(JsonReader.map(dataOf(response)['user']));
        await _storage.setUser(user.toJson());
        return user;
      });

  Future<DeviceModel?> myDevice() => guard(() async {
        try {
          final response = await _dio.get(ApiEndpoints.myDevice);
          return DeviceModel.fromJson(
              JsonReader.map(dataOf(response)['device']));
        } on DioException catch (e) {
          if (e.response?.statusCode == 404) return null;
          rethrow;
        }
      });

  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } on DioException catch (_) {
    } finally {
      await _storage.clearAll();
    }
  }
}
