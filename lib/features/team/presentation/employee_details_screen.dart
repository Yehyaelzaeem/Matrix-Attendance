import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/info_block.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../../../core/widgets/person_row.dart';
import '../../../core/widgets/schedule_editor.dart';
import '../../../core/widgets/section_title.dart';
import '../../../core/widgets/stat_tiles.dart';
import '../../../core/widgets/status_chip.dart';
import '../../auth/data/models/user_role.dart';
import '../../projects/logic/projects_cubit.dart';
import '../../reports/data/models/employee_report.dart';
import '../../reports/logic/reports_cubit.dart';
import '../../reports/presentation/widgets/employee_report_sheet.dart';
import '../../reports/presentation/widgets/report_score_color.dart';
import '../../tasks/data/models/task_kpi.dart';
import '../../tasks/logic/tasks_cubit.dart';
import '../../tasks/presentation/widgets/task_card.dart';
import '../logic/team_cubit.dart';
import 'widgets/employee_editor_sheet.dart';
import 'widgets/employee_project_row.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  const EmployeeDetailsScreen({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final team = getIt<TeamCubit>()..load();
    final tasks = getIt<TasksCubit>()..load();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: BlocBuilder<TeamCubit, TeamState>(
        bloc: team,
        builder: (context, state) => BlocBuilder<TasksCubit, TasksState>(
          bloc: tasks,
          builder: (context, _) {
            final employee = state is TeamSuccess ? state.byName(name) : null;
            if (employee == null) return const SizedBox.shrink();
            final report = getIt<ReportsCubit>()
                .data
                ?.reports
                .where((r) => r.name == name)
                .firstOrNull;
            final kpi = TaskKpi.of(name, tasks.tasks);
            final attendance = report?.attendanceScore ?? 0;
            final overall =
                report?.value(ReportMode.overall, kpi) ?? attendance;
            final projects = getIt<ProjectsCubit>()
                .projects
                .where((p) => p.hasMember(name))
                .toList();
            final open = tasks.tasks
                .where((t) => t.assignee == name && !t.isDone)
                .toList()
              ..sort((a, b) => a.due.compareTo(b.due));
            return ListView(
              padding: EdgeInsets.only(bottom: 30.h),
              children: [
                PageTopBar(
                    title: name, subtitle: employee.jobTitle, showBack: true),
                InfoBlock(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PersonRow(
                        name: name,
                        subtitle: employee.jobTitle,
                        avatarSize: 56,
                        titleSize: 16,
                        trailing: employee.role == UserRole.employee
                            ? null
                            : StatusChip(
                                label: employee.role.label,
                                tone: employee.role.tone),
                      ),
                      SizedBox(height: 14.h),
                      StatTilesRow(
                        background: AppColors.surfaceColor.themeColor,
                        valueSize: 20,
                        tiles: [
                          StatTileData(
                            value: '$attendance%',
                            label: LocaleKeys.reports_scoreAttendance.tr(),
                            color: ReportScoreColor.of(attendance),
                          ),
                          StatTileData(
                            value: kpi.score == null
                                ? LocaleKeys.common_dash.tr()
                                : '${kpi.score}%',
                            label: LocaleKeys.reports_scoreKpi.tr(),
                            color: kpi.score == null
                                ? AppColors.textSecondaryColor.themeColor
                                : ReportScoreColor.of(kpi.score!),
                          ),
                          StatTileData(
                            value: '$overall%',
                            label: LocaleKeys.reports_scoreOverall.tr(),
                            color: ReportScoreColor.of(overall),
                            background: AppColors.primarySoftColor.themeColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              title: LocaleKeys.team_roleSchedule.tr(),
                              type: ButtonStyleType.ghost,
                              height: 44,
                              fontSize: 13.5,
                              onTap: () => AppSheet.show(context,
                                  child: EmployeeEditorSheet(name: name)),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomButton(
                              title: LocaleKeys.team_monthReport.tr(),
                              type: ButtonStyleType.ghost,
                              height: 44,
                              fontSize: 13.5,
                              onTap: () => AppSheet.show(context,
                                  child: EmployeeReportSheet(name: name)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                InfoBlock(
                  title: LocaleKeys.admin_weeklySchedule.tr(),
                  child: ScheduleEditor(schedule: employee.schedule),
                ),
                InfoBlock(
                  title: LocaleKeys.admin_projects.tr(),
                  trailing: StatusChip(
                      small: true, label: '${projects.length}', numeric: true),
                  child: projects.isEmpty
                      ? AppEmpty(
                          message: LocaleKeys.team_noProjects.tr(), padding: 6)
                      : Column(
                          children: [
                            for (var i = 0; i < projects.length; i++)
                              EmployeeProjectRow(
                                project: projects[i],
                                name: name,
                                isLast: i == projects.length - 1,
                              ),
                          ],
                        ),
                ),
                SectionTitle(
                  title: LocaleKeys.team_openTasks
                      .tr(namedArgs: {'n': '${open.length}'}),
                  actionLabel: LocaleKeys.team_allTasks.tr(),
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.w, 6.h, 20.w, 12.h),
                  onAction: () => context.pushNamed(Routes.tasksScreen,
                      arguments: {'assignee': name}),
                ),
                if (open.isEmpty)
                  AppEmpty(message: LocaleKeys.team_noOpenTasks.tr())
                else
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        for (var i = 0; i < open.length; i++)
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: TaskCard(task: open[i], index: i),
                          ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
