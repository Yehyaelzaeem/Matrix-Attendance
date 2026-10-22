import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/locale_keys.dart';
import '../../../auth/data/models/user_role.dart';
import '../../../tasks/presentation/widgets/filter_pill.dart';

class RequesterRoleFilter extends StatelessWidget {
  const RequesterRoleFilter({
    super.key,
    required this.selected,
    required this.countOf,
    required this.onChanged,
  });

  final UserRole? selected;
  final int Function(UserRole? role) countOf;
  final ValueChanged<UserRole?> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = <(UserRole?, String)>[
      (null, LocaleKeys.admin_allRequests.tr()),
      (
        UserRole.employee,
        '${UserRole.employee.emoji} ${LocaleKeys.admin_fromEmployees.tr()}'
      ),
      (
        UserRole.reviewer,
        '${UserRole.reviewer.emoji} ${LocaleKeys.admin_fromReviewers.tr()}'
      ),
    ];
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: options.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          final (role, label) = options[i];
          return FilterPill(
            label: '$label ${countOf(role)}',
            active: selected == role,
            onTap: () => onChanged(role),
          );
        },
      ),
    );
  }
}
