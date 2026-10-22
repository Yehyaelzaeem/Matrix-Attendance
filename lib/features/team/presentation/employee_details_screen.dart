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
import '../../../core/widgets/schedule_editor.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../../core/widgets/section_title.dart';
import '../../../core/widgets/stat_tiles.dart';
import '../../../core/widgets/status_chip.dart';
import '../../reports/logic/reports_cubit.dart';
import '../../reports/presentation/widgets/employee_report_sheet.dart';
import '../../reports/presentation/widgets/report_score_color.dart';
import '../../tasks/presentation/widgets/task_card.dart';
import '../logic/employee_detail_cubit.dart';
import 'widgets/employee_editor_sheet.dart';
import 'widgets/employee_profile_card.dart';
import 'widgets/employee_project_row.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  const EmployeeDetailsScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmployeeDetailCubit>(
      create: (_) => getIt<EmployeeDetailCubit>()..load(id),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor.themeColor,
        body: BlocBuilder<EmployeeDetailCubit, EmployeeDetailState>(
          builder: (context, state) {
            final cubit = context.read<EmployeeDetailCubit>();
            return CustomScreenStateLayout(
              isLoading: state.loading && state.detail == null,
              error: state.detail == null && state.error != null
                  ? ErrorModel(
                      code: ErrorEnum.otherError, errorMessage: state.error!)
                  : null,
              onRetry: () => cubit.load(id),
              builder: (_) {
                final detail = state.detail!;
                final employee = detail.employee;
                final metrics = detail.metrics;
                final dash = LocaleKeys.common_dash.tr();
                final open = detail.tasks.where((t) => !t.isDone).toList()
                  ..sort((a, b) => a.dueOrFar.compareTo(b.dueOrFar));
                return RefreshIndicator(
                  onRefresh: () => cubit.load(id),
                  child: ListView(
                    padding: EdgeInsets.only(bottom: 30.h),
                    children: [
                      PageTopBar(
                          title: employee.name,
                          subtitle: employee.jobTitle,
                          showBack: true),
                      EmployeeProfileCard(employee: employee),
                      InfoBlock(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            StatTilesRow(
                              background: AppColors.surfaceColor.themeColor,
                              valueSize: 20,
                              tiles: [
                                StatTileData(
                                  value: metrics.attendance == null
                                      ? dash
                                      : '${metrics.attendance}%',
                                  label:
                                      LocaleKeys.reports_scoreAttendance.tr(),
                                  color: ReportScoreColor.of(
                                      metrics.attendance ?? 0),
                                ),
                                StatTileData(
                                  value: metrics.kpi == null
                                      ? dash
                                      : '${metrics.kpi}%',
                                  label: LocaleKeys.reports_scoreKpi.tr(),
                                  color: metrics.kpi == null
                                      ? AppColors.textSecondaryColor.themeColor
                                      : ReportScoreColor.of(metrics.kpi!),
                                ),
                                StatTileData(
                                  value: metrics.overall == null
                                      ? dash
                                      : '${metrics.overall}%',
                                  label: LocaleKeys.reports_scoreOverall.tr(),
                                  color:
                                      ReportScoreColor.of(metrics.overall ?? 0),
                                  background:
                                      AppColors.primarySoftColor.themeColor,
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
                                    onTap: () async {
                                      await AppSheet.show(context,
                                          child: EmployeeEditorSheet(
                                              employee: employee));
                                      cubit.load(id);
                                    },
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
                                        child: EmployeeReportSheet(
                                          userId: employee.id,
                                          month: ReportsCubit.currentMonth,
                                        )),
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
                            small: true,
                            label: '${detail.projects.length}',
                            numeric: true),
                        child: detail.projects.isEmpty
                            ? AppEmpty(
                                message: LocaleKeys.team_noProjects.tr(),
                                padding: 6)
                            : Column(
                                children: [
                                  for (var i = 0;
                                      i < detail.projects.length;
                                      i++)
                                    EmployeeProjectRow(
                                      project: detail.projects[i],
                                      userId: employee.id,
                                      isLast: i == detail.projects.length - 1,
                                    ),
                                ],
                              ),
                      ),
                      SectionTitle(
                        title: LocaleKeys.team_openTasks
                            .tr(namedArgs: {'n': '${open.length}'}),
                        actionLabel: LocaleKeys.team_allTasks.tr(),
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.w, 6.h, 20.w, 12.h),
                        onAction: () => context.pushNamed(Routes.tasksScreen,
                            arguments: {'assignee': employee.id}),
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
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
