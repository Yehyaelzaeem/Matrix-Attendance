class GreenApiConfig {
  GreenApiConfig._();

  static const String apiUrl = String.fromEnvironment('GREEN_API_URL',
      defaultValue: 'https://api.green-api.com');
  static const String instanceId = String.fromEnvironment('GREEN_API_INSTANCE');
  static const String token = String.fromEnvironment('GREEN_API_TOKEN');
  static const String groupId = String.fromEnvironment('WA_GROUP_ID');
  static const String groupName =
      String.fromEnvironment('WA_GROUP_NAME', defaultValue: 'Dev in&out');

  static bool get isConfigured =>
      instanceId.isNotEmpty &&
      token.isNotEmpty &&
      (groupId.isNotEmpty || groupName.isNotEmpty);

  static String get sendMessagePath =>
      '/waInstance$instanceId/sendMessage/$token';

  static String get contactsPath => '/waInstance$instanceId/getContacts/$token';
}
