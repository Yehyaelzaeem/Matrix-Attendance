import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../projects/data/models/project_model.dart';
import '../../../projects/presentation/widgets/project_logo.dart';

class EmployeeProjectRow extends StatelessWidget {
  const EmployeeProjectRow({
    super.key,
    required this.project,
    required this.name,
    required this.isLast,
  });

  final ProjectModel project;
  final String name;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final role = project.member(name)?.role ?? '';
    return GestureDetector(
      onTap: () => context.pushNamed(Routes.projectDetailsScreen,
          arguments: {'projectId': project.id}),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11.h),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(color: AppColors.dividerColor.themeColor)),
        ),
        child: Row(
          children: [
            ProjectLogo(
                label: project.shortName, color: project.color, size: 38),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(project.name, fontWeight: FontWeight.w700),
                  AppText(
                    project.manager == name
                        ? '$role${LocaleKeys.team_managerTag.tr()}'
                        : role,
                    fontSize: 11.5,
                    color: AppColors.textSecondaryColor.themeColor,
                  ),
                ],
              ),
            ),
            StatusChip(label: project.status.label, tone: project.status.tone),
          ],
        ),
      ),
    );
  }
}
