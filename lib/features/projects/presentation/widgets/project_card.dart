import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/utils/number_helper.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/meter_bar.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../tasks/logic/tasks_cubit.dart';
import '../../data/models/project_model.dart';
import '../../data/models/project_progress.dart';
import 'member_stack.dart';
import 'project_logo.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project, this.index = 0});

  final ProjectModel project;
  final int index;

  @override
  Widget build(BuildContext context) {
    final tasks = getIt<TasksCubit>();
    final me = tasks.me;
    final progress = ProjectProgress.of(project, tasks.tasks);
    final open =
        tasks.tasks.where((t) => t.projectId == project.id && !t.isDone).length;
    final diff = DateHelper.dayDiff(project.due);
    final muted = AppColors.textSecondaryColor.themeColor;
    final dueColor = project.delivered != null
        ? AppColors.successColor.themeColor
        : diff < 0
            ? AppColors.errorColor.themeColor
            : diff <= 10
                ? AppColors.warningDeepColor.themeColor
                : muted;
    final dueText = project.delivered != null
        ? LocaleKeys.projects_deliveredOn
            .tr(namedArgs: {'date': DateHelper.dayMonth(project.delivered!)})
        : diff < 0
            ? LocaleKeys.projects_lateDays.tr(namedArgs: {'n': '${diff.abs()}'})
            : LocaleKeys.projects_dueOn
                .tr(namedArgs: {'date': DateHelper.dayMonth(project.due)});
    final member = project.member(me);
    Widget meta(List<Widget> children) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        );
    return FadeSlideIn(
      delay: Duration(milliseconds: index * 45),
      child: AppCard(
        padding: EdgeInsets.all(15.r),
        onTap: () => context.pushNamed(Routes.projectDetailsScreen,
            arguments: {'projectId': project.id}),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ProjectLogo(label: project.shortName, color: project.color),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(project.name,
                          fontSize: 15.5, fontWeight: FontWeight.w700),
                      AppText('${project.client.company} · ${project.kind}',
                          fontSize: 12, maxLines: 1, color: muted),
                    ],
                  ),
                ),
                StatusChip(
                    label: project.status.label, tone: project.status.tone),
              ],
            ),
            SizedBox(height: 12.h),
            meta([
              AppText(LocaleKeys.projects_progress.tr(),
                  fontSize: 12, fontWeight: FontWeight.w700, color: muted),
              AppText('$progress%',
                  numeric: true, fontSize: 12, fontWeight: FontWeight.w700),
            ]),
            SizedBox(height: 6.h),
            MeterBar(value: progress / 100, color: project.color),
            SizedBox(height: 12.h),
            meta([
              MemberStack(names: project.team.map((m) => m.name).toList()),
              AppText(
                  LocaleKeys.projects_openTasks.tr(namedArgs: {'n': '$open'}),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: muted),
              AppText(dueText,
                  fontSize: 12, fontWeight: FontWeight.w700, color: dueColor),
            ]),
            if (tasks.isAdmin) ...[
              _divider(),
              meta([
                AppText(
                  LocaleKeys.projects_paidOf.tr(namedArgs: {
                    'paid':
                        NumberHelper.money(project.paidAmount, project.currency)
                  }),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: muted,
                ),
                AppText(
                  LocaleKeys.projects_ofValue.tr(namedArgs: {
                    'value': NumberHelper.money(project.value, project.currency)
                  }),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: muted,
                ),
              ]),
            ] else if (member != null) ...[
              _divider(),
              meta([
                AppText(
                    LocaleKeys.projects_myRole
                        .tr(namedArgs: {'role': member.role}),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: muted),
                AppText(
                  LocaleKeys.projects_myTasksCount.tr(namedArgs: {
                    'n':
                        '${tasks.tasks.where((t) => t.projectId == project.id && t.assignee == me && !t.isDone).length}',
                  }),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: muted,
                ),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _divider() => Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Container(height: 1, color: AppColors.dividerColor.themeColor),
      );
}
