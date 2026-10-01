import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/info_block.dart';
import '../../../../core/widgets/segmented_toggle.dart';
import '../../../team/logic/team_cubit.dart';
import '../../data/models/project_model.dart';
import '../../logic/projects_cubit.dart';
import 'milestone_timeline.dart';

class ProjectOverviewTab extends StatelessWidget {
  const ProjectOverviewTab({
    super.key,
    required this.project,
    required this.isAdmin,
    required this.onChangeManager,
  });

  final ProjectModel project;
  final bool isAdmin;
  final VoidCallback onChangeManager;

  @override
  Widget build(BuildContext context) {
    final today = DateHelper.today();
    final delivered = project.delivered != null;
    MilestoneItem item(String title, DateTime? date, bool done) =>
        MilestoneItem(
          title: title,
          subtitle: date == null
              ? LocaleKeys.common_notYet.tr()
              : DateHelper.dayMonth(date),
          done: done,
          lateLabel: !done && date != null && date.isBefore(today)
              ? LocaleKeys.projects_lateTag.tr()
              : null,
        );
    final managerJob = getIt<TeamCubit>()
            .employees
            .where((e) => e.name == project.manager)
            .map((e) => e.jobTitle)
            .firstOrNull ??
        '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoBlock(
          title: LocaleKeys.projects_about.tr(),
          child: AppText(project.description,
              fontSize: 13.5,
              height: 1.9,
              color: AppColors.textBodyColor.themeColor),
        ),
        InfoBlock(
          title: LocaleKeys.projects_milestones.tr(),
          child: MilestoneTimeline(items: [
            item(LocaleKeys.projects_msReceived.tr(), project.start,
                !project.start.isAfter(today)),
            item(LocaleKeys.projects_msBeta.tr(), project.beta,
                !project.beta.isAfter(today) || delivered),
            item(LocaleKeys.projects_msFinal.tr(), project.due, delivered),
            item(LocaleKeys.projects_msClosed.tr(), project.delivered,
                delivered),
          ]),
        ),
        InfoBlock(
          title: LocaleKeys.projects_manager.tr(),
          child: Row(
            children: [
              AppAvatar(name: project.manager),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(project.manager,
                        fontSize: 14.5, fontWeight: FontWeight.w700),
                    AppText(managerJob,
                        fontSize: 12,
                        textDirection: TextDirection.ltr,
                        color: AppColors.textSecondaryColor.themeColor),
                  ],
                ),
              ),
              if (isAdmin)
                CustomButton(
                  width: 80.w,
                  height: 38,
                  radius: 12,
                  fontSize: 12.5,
                  type: ButtonStyleType.ghost,
                  title: LocaleKeys.projects_change.tr(),
                  onTap: onChangeManager,
                ),
            ],
          ),
        ),
        if (isAdmin)
          InfoBlock(
            title: LocaleKeys.projects_statusTitle.tr(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SegmentedToggle<ProjectStatus>(
                  options: [for (final s in ProjectStatus.values) (s, s.label)],
                  selected: project.status,
                  onChanged: (s) =>
                      getIt<ProjectsCubit>().setStatus(project.id, s),
                ),
                SizedBox(height: 8.h),
                AppText(LocaleKeys.projects_statusHint.tr(),
                    fontSize: 11.5,
                    color: AppColors.textSecondaryColor.themeColor),
              ],
            ),
          ),
      ],
    );
  }
}
