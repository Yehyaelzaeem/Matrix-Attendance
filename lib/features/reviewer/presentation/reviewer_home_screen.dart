import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_emojis.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/alert_tile.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/header_overlap_layout.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../../core/widgets/section_title.dart';
import '../../attendance/presentation/widgets/home_header.dart';
import '../../board/presentation/widgets/board_summary_row.dart';
import '../../dashboard/logic/dashboard_cubit.dart';
import '../../layout/logic/app_tab.dart';
import '../../layout/logic/layout_cubit.dart';
import '../../reports/data/models/employee_report.dart';
import '../../reports/logic/reports_cubit.dart';
import '../../reports/presentation/widgets/employee_report_sheet.dart';
import '../../reports/presentation/widgets/report_rank_card.dart';
import '../../tasks/data/models/task_enums.dart';
import 'widgets/review_progress_card.dart';

class ReviewerHomeScreen extends StatefulWidget {
  const ReviewerHomeScreen({super.key});

  @override
  State<ReviewerHomeScreen> createState() => _ReviewerHomeScreenState();
}

class _ReviewerHomeScreenState extends State<ReviewerHomeScreen> {
  late final DashboardCubit _cubit = context.read<DashboardCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.loadReviewer();
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.read<LayoutCubit>();
    return ColoredBox(
      color: AppColors.backgroundColor.themeColor,
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) => CustomScreenStateLayout(
          isLoading: state.reviewer == null && state.error == null,
          error: state.reviewer == null && state.error != null
              ? ErrorModel(
                  code: ErrorEnum.otherError, errorMessage: state.error!)
              : null,
          onRetry: _cubit.loadReviewer,
          builder: (_) {
            final data = state.reviewer!;
            final low = state.followUp;
            return RefreshIndicator(
              onRefresh: _cubit.loadReviewer,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: HeaderOverlapLayout(
                  header:
                      HomeHeader(subtitle: LocaleKeys.reviewer_subtitle.tr()),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ReviewProgressCard(
                        review: data.monthReview,
                        onOpenReports: () {
                          context.read<ReportsCubit>().viewPrevious(true);
                          layout.select(AppTab.reports);
                        },
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
                        count: '${data.inReview}',
                        countColor: AppColors.violetColor.themeColor,
                        onTap: () => layout.select(AppTab.reviewTasks),
                      ),
                      AlertTile(
                        emoji: AppEmojis.testTube,
                        background: AppColors.orangeSoftColor.themeColor,
                        title: LocaleKeys.reviewer_inTest.tr(),
                        subtitle: LocaleKeys.reviewer_inTestSub.tr(),
                        count: '${data.inTest}',
                        countColor: AppColors.orangeTextColor.themeColor,
                        onTap: () => context.pushNamed(Routes.tasksScreen,
                            arguments: {'status': TaskStatus.test}),
                      ),
                      SectionTitle(
                        title: LocaleKeys.reviewer_today.tr(),
                        actionLabel: LocaleKeys.reviewer_boardLink.tr(),
                        onAction: () => layout.select(AppTab.board),
                      ),
                      BoardSummaryRow(summary: data.today),
                      SectionTitle(
                        title: LocaleKeys.reviewer_needsFollowUp.tr(),
                        actionLabel: LocaleKeys.reviewer_all.tr(),
                        onAction: () {
                          context.read<ReportsCubit>().setSortDesc(false);
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
                                  person: low[i],
                                  mode: ReportMode.attendance,
                                  reviewed: low[i].reviewed,
                                  index: i,
                                  onTap: () => AppSheet.show(
                                    context,
                                    child: EmployeeReportSheet(
                                      userId: low[i].userId,
                                      month: ReportsCubit.currentMonth,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
