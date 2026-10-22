import 'package:dio/dio.dart';

import '../../../core/network/api_handler.dart';
import '../../../core/network/green_api_config.dart';
import '../../../core/network/network_exceptions.dart';

class WhatsappGroupRepo with ApiHandler {
  WhatsappGroupRepo()
      : _dio = Dio(BaseOptions(
          baseUrl: GreenApiConfig.apiUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
        ));

  final Dio _dio;
  String? _groupId =
      GreenApiConfig.groupId.isEmpty ? null : GreenApiConfig.groupId;

  bool get isEnabled => GreenApiConfig.isConfigured;

  Future<String> _resolveGroupId() async {
    final cached = _groupId;
    if (cached != null) return cached;
    final response = await _dio.get(GreenApiConfig.contactsPath);
    final wanted = GreenApiConfig.groupName.trim().toLowerCase();
    final group = (response.data as List)
        .cast<Map<String, dynamic>>()
        .where((c) => (c['id'] as String? ?? '').endsWith('@g.us'))
        .firstWhere(
          (c) => (c['name'] as String? ?? '').trim().toLowerCase() == wanted,
          orElse: () => throw NetworkException(
              'WhatsApp group "${GreenApiConfig.groupName}" not found'),
        );
    return _groupId = group['id'] as String;
  }

  Future<void> send(String message) => guard(() async {
        await _dio.post(GreenApiConfig.sendMessagePath, data: {
          'chatId': await _resolveGroupId(),
          'message': message,
        });
      });
}
