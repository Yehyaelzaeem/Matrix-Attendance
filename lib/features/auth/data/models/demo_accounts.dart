import 'user_model.dart';
import 'user_role.dart';

abstract final class DemoAccounts {
  static const String token = 'demo-session-token';

  static const Map<String, UserModel> _byPhone = {
    '01000000001': UserModel(
      id: 'demo-reviewer',
      name: 'هبة مصطفى',
      phone: '01000000001',
      jobTitle: 'Scrum Master',
      email: 'reviewer@matrixclouds.com',
      role: UserRole.reviewer,
      status: AccountStatus.active,
    ),
    '01000000002': UserModel(
      id: 'demo-admin',
      name: 'يوسف خالد',
      phone: '01000000002',
      jobTitle: 'Project Manager',
      email: 'admin@matrixclouds.com',
      role: UserRole.admin,
      status: AccountStatus.active,
    ),
  };

  static bool isDemo(String? phone) => _byPhone.containsKey(phone);

  static UserModel? byPhone(String phone) => _byPhone[phone];
}
