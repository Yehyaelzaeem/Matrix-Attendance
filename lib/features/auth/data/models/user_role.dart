import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/status_chip.dart';

enum UserRole {
  employee(AppEmojis.employee, ChipTone.blue),
  reviewer(AppEmojis.reviewer, ChipTone.violet),
  admin(AppEmojis.admin, ChipTone.orange);

  const UserRole(this.emoji, this.tone);

  final String emoji;
  final ChipTone tone;

  String get label => switch (this) {
        UserRole.employee => LocaleKeys.roles_employee.tr(),
        UserRole.reviewer => LocaleKeys.roles_reviewer.tr(),
        UserRole.admin => LocaleKeys.roles_admin.tr(),
      };

  bool get canManageTasks => this != UserRole.employee;

  static UserRole fromName(String? name) => UserRole.values.firstWhere(
        (e) => e.name == name,
        orElse: () => UserRole.employee,
      );
}

enum AccountStatus {
  pending,
  active,
  suspended,
  rejected;

  static AccountStatus fromName(String? name) =>
      AccountStatus.values.firstWhere(
        (e) => e.name == name,
        orElse: () => AccountStatus.active,
      );
}
