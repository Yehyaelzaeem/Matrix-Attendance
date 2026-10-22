import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../auth/data/models/user_role.dart';
import '../../../projects/logic/projects_cubit.dart';
import '../../data/models/employee_model.dart';

class EmployeeListCard extends StatelessWidget {
  const EmployeeListCard(
      {super.key, required this.employee, this.metrics, this.index = 0});

  final EmployeeModel employee;
  final EmployeeMetrics? metrics;
  final int index;

  @override
  Widget build(BuildContext context) {
    final projects = context
        .watch<ProjectsCubit>()
        .projects
        .where((p) => p.hasMember(employee.id))
        .length;
    final dash = LocaleKeys.common_dash.tr();
    final muted = AppColors.textSecondaryColor.themeColor;
    return FadeSlideIn(
      delay: Duration(milliseconds: index * 25),
      child: GestureDetector(
        onTap: () => context.pushNamed(Routes.employeeDetailsScreen,
            arguments: {'id': employee.id}),
        child: Container(
          padding: EdgeInsets.all(13.r),
          decoration: BoxDecoration(
            color: AppColors.cardColor.themeColor,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Row(
            children: [
              AppAvatar(name: employee.name, imagePath: employee.image),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(employee.name,
                        fontWeight: FontWeight.w700, maxLines: 1),
                    AppText(
                      '${employee.jobTitle} · ${LocaleKeys.team_projectsCount.tr(namedArgs: {
                            'n': '$projects'
                          })}',
                      fontSize: 11.5,
                      maxLines: 1,
                      color: muted,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (employee.suspended)
                    StatusChip(
                        small: true,
                        label: LocaleKeys.team_suspendedChip.tr(),
                        tone: ChipTone.red)
                  else if (employee.role != UserRole.employee)
                    StatusChip(
                        small: true,
                        label: employee.role.label,
                        tone: employee.role.tone),
                  SizedBox(height: 5.h),
                  AppText(
                    LocaleKeys.team_scores.tr(namedArgs: {
                      'a': metrics?.attendance == null
                          ? dash
                          : '${metrics!.attendance}',
                      'b': metrics?.kpi == null ? dash : '${metrics!.kpi}%',
                    }),
                    numeric: true,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: muted,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
