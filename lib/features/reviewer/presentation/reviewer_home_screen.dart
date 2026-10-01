import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_emojis.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/alert_tile.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/header_overlap_layout.dart';
import '../../../core/widgets/section_title.dart';
import '../../attendance/presentation/widgets/home_header.dart';
import '../../board/logic/board_cubit.dart';
import '../../board/presentation/widgets/board_summary_row.dart';
import '../../layout/logic/app_tab.dart';
import '../../layout/logic/layout_cubit.dart';
import '../../reports/data/models/employee_report.dart';
import '../../reports/logic/reports_cubit.dart';
import '../../reports/presentation/widgets/employee_report_sheet.dart';
import '../../reports/presentation/widgets/report_rank_card.dart';
import '../../tasks/data/models/task_enums.dart';
import '../../tasks/data/models/task_kpi.dart';
import '../../tasks/logic/tasks_cubit.dart';
import 'widgets/review_progress_card.dart';

class ReviewerHomeScreen extends StatelessWidget {
  const ReviewerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = getIt<ReportsCubit>();
    final tasks = getIt<TasksCubit>();
    final layout = getIt<LayoutCubit>();
    return ColoredBox(
      color: AppColors.backgroundColor.themeColor,
      child: BlocBuilder<ReportsCubit, ReportsState>(
        bloc: reports,
        builder: (context, reportState) => BlocBuilder<TasksCubit, TasksState>(
          bloc: tasks,
          builder: (context, _) {
            final review =
                tasks.tasks.where((t) => t.status == TaskStatus.review).length;
            final test =
                tasks.tasks.where((t) => t.status == TaskStatus.test).length;
            final data = reportState is ReportsSuccess ? reportState : null;
            final low = data == null
                ? <EmployeeReport>[]
                : ([...data.reports]..sort((a, b) =>
                        a.attendanceScore.compareTo(b.attendanceScore)))
                    .take(3)
                    .toList();
            return SingleChildScrollView(
              child: HeaderOverlapLayout(
                header: HomeHeader(subtitle: LocaleKeys.reviewer_subtitle.tr()),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (data != null)
                      ReviewProgressCard(
                        data: data,
                        onOpenReports: () => layout.select(AppTab.reports),
                      ),
                    SectionTitle(
                      title: LocaleKeys.reviewer_tasks.tr(),
                      actionLabel: LocaleKeys.nav_review.tr(),
                      onAction: () => layout.select(AppTab.reviewTasks),
                    ),
                    AlertTile(
                      emoji: AppEmojis.eyes,
                      background: AppColors.violetSoftColor.themeColor,
                      title: LocaleKeys.reviewer_awaitingReview.tr(),
                      subtitle: LocaleKeys.reviewer_awaitingReviewSub.tr(),
                      count: '$review',
                      countColor: AppColors.violetColor.themeColor,
                      onTap: () => layout.select(AppTab.reviewTasks),
                    ),
                    AlertTile(
                      emoji: AppEmojis.testTube,
                      background: AppColors.orangeSoftColor.themeColor,
                      title: LocaleKeys.reviewer_inTest.tr(),
                      subtitle: LocaleKeys.reviewer_inTestSub.tr(),
                      count: '$test',
                      countColor: AppColors.orangeTextColor.themeColor,
                      onTap: () => context.pushNamed(Routes.tasksScreen,
                          arguments: {'status': TaskStatus.test}),
                    ),
                    SectionTitle(
                      title: LocaleKeys.reviewer_today.tr(),
                      actionLabel: LocaleKeys.reviewer_boardLink.tr(),
                      onAction: () => layout.select(AppTab.board),
                    ),
                    BoardSummaryRow(day: getIt<BoardCubit>().today),
                    SectionTitle(
                      title: LocaleKeys.reviewer_needsFollowUp.tr(),
                      actionLabel: LocaleKeys.reviewer_all.tr(),
                      onAction: () {
                        reports.setSortDesc(false);
                        layout.select(AppTab.reports);
                      },
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.w, 0, 20.w, 24.h),
                      child: Column(
                        children: [
                          for (var i = 0; i < low.length; i++)
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: ReportRankCard(
                                report: low[i],
                                kpi: TaskKpi.of(low[i].name, tasks.tasks),
                                mode: ReportMode.attendance,
                                reviewed: data!.isReviewed(low[i].name),
                                index: i,
                                onTap: () => AppSheet.show(context,
                                    child:
                                        EmployeeReportSheet(name: low[i].name)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
