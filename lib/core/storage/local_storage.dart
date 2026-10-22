import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  LocalStorage()
      : _box = GetStorage(),
        _secureBox = const FlutterSecureStorage();

  final GetStorage _box;
  final FlutterSecureStorage _secureBox;

  T? read<T>(String key) => _box.read<T>(key);
  Future<void> write<T>(String key, T value) => _box.write(key, value);
  Future<void> remove(String key) => _box.remove(key);
  bool has(String key) => _box.hasData(key);

  Future<void> clearAll() async {
    final onboardingSeen = isOnboardingSeen;
    final lang = read<String>(_langKey);
    await _secureBox.delete(key: _tokenKey);
    await _box.erase();
    if (onboardingSeen) await setOnboardingSeen();
    if (lang != null) await setLang(lang);
  }

  static const _tokenKey = 'token';
  static const _hasTokenKey = 'has_token';
  static const _userKey = 'user';

  Future<String?> getToken() => _secureBox.read(key: _tokenKey);

  Future<void> setToken(String v) async {
    await _secureBox.write(key: _tokenKey, value: v);
    await write(_hasTokenKey, true);
  }

  Future<void> removeToken() async {
    await _secureBox.delete(key: _tokenKey);
    await remove(_hasTokenKey);
  }

  Map<String, dynamic>? getUser() => read<Map<String, dynamic>>(_userKey);
  Future<void> setUser(Map<String, dynamic> user) => write(_userKey, user);
  Future<void> removeUser() => remove(_userKey);

  bool get isLoggedIn => read<bool>(_hasTokenKey) ?? false;

  static const _deviceIdKey = 'device_uuid';
  static final _uuidPattern = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$');

  Future<String> getDeviceId() async {
    final existing = await _secureBox.read(key: _deviceIdKey);
    if (existing != null && _uuidPattern.hasMatch(existing)) return existing;
    final id = _uuidV4();
    await _secureBox.write(key: _deviceIdKey, value: id);
    return id;
  }

  static String _uuidV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  static const _onboardingSeenKey = 'onboarding_seen';

  bool get isOnboardingSeen => read<bool>(_onboardingSeenKey) ?? false;
  Future<void> setOnboardingSeen() => write(_onboardingSeenKey, true);

  static const _langKey = 'lang';

  String getLang() => read<String>(_langKey) ?? 'ar';
  Future<void> setLang(String lang) => write(_langKey, lang);
}
