import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/grid_background.dart';
import '../../data/models/project_model.dart';
import 'project_logo.dart';

class ProjectHero extends StatelessWidget {
  const ProjectHero({
    super.key,
    required this.project,
    required this.progress,
    required this.openTasks,
  });

  final ProjectModel project;
  final int progress;
  final int openTasks;

  @override
  Widget build(BuildContext context) {
    final diff = project.daysToDue;
    final delivered = project.delivered != null;
    final stats = [
      ('$progress%', LocaleKeys.projects_statProgress.tr()),
      ('$openTasks', LocaleKeys.projects_statOpen.tr()),
      ('${project.team.length}', LocaleKeys.projects_statTeam.tr()),
      (
        delivered ? AppEmojis.check : '${diff.abs()}',
        delivered
            ? LocaleKeys.projects_statDelivered.tr()
            : diff < 0
                ? LocaleKeys.projects_statLate.tr()
                : LocaleKeys.projects_statLeft.tr()
      ),
    ];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [project.color, AppColors.navyColor.themeColor],
          stops: const [0, 1.35],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(
            child: GridBackground(cell: 22, animate: false, lineAlpha: 0.07),
          ),
          Padding(
            padding: EdgeInsets.all(18.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ProjectLogo(
                        label: project.shortName,
                        color: project.color,
                        glass: true),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(project.name,
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                          AppText(project.kind,
                              fontSize: 12.5,
                              maxLines: 2,
                              color: Colors.white.withValues(alpha: 0.78)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    for (var i = 0; i < stats.length; i++) ...[
                      if (i > 0) SizedBox(width: 7.w),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 9.h, horizontal: 4.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.13),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Column(
                            children: [
                              AppText(stats[i].$1,
                                  numeric: true,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                              AppText(stats[i].$2,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  maxLines: 1,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 14.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    minHeight: 7.h,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
