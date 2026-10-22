import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/info_block.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../data/models/employee_model.dart';
import 'employee_contact_section.dart';

class EmployeeProfileCard extends StatelessWidget {
  const EmployeeProfileCard({super.key, required this.employee});

  final EmployeeModel employee;

  @override
  Widget build(BuildContext context) {
    final role = employee.role;
    return InfoBlock(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.themeColor
                        .withValues(alpha: 0.7),
                    blurRadius: 28,
                    spreadRadius: -14,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: AppAvatar(
                name: employee.name,
                size: 84,
                radius: 28,
                borderColor: AppColors.cardColor.themeColor,
                borderWidth: 3,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          AppText(employee.name,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center),
          AppText(employee.jobTitle,
              fontSize: 13,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              color: AppColors.textSecondaryColor.themeColor),
          SizedBox(height: 8.h),
          Center(
            child: StatusChip(
                label: '${role.emoji} ${role.label}', tone: role.tone),
          ),
          SizedBox(height: 14.h),
          EmployeeContactSection(employee: employee),
        ],
      ),
    );
  }
}
