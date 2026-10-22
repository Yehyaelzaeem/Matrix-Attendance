import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_emojis.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../../core/widgets/segment_tabs.dart';
import '../../auth/data/models/user_role.dart';
import '../../auth/logic/auth_cubit.dart';
import '../data/models/employee_report.dart';
import '../logic/reports_cubit.dart';
import 'widgets/close_month_sheet.dart';
import 'widgets/employee_report_sheet.dart';
import 'widgets/month_lock_banner.dart';
import 'widgets/report_rank_card.dart';
import 'widgets/reports_bottom_bar.dart';
import 'widgets/reports_summary.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key, this.showBack = false});

  final bool showBack;

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late final ReportsCubit _cubit = context.read<ReportsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final previous = DateTime(now.year, now.month - 1);
    final isAdmin =
        context.read<AuthCubit>().currentUser?.role == UserRole.admin;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) => CustomScreenStateLayout(
          isLoading: state is ReportsInitial || state is ReportsLoading,
          error: state is ReportsError
              ? ErrorModel(
                  code: ErrorEnum.otherError, errorMessage: state.message)
              : null,
          onRetry: _cubit.refresh,
          builder: (_) {
            final data = state as ReportsSuccess;
            final people = data.people;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageTopBar(
                    title: LocaleKeys.reports_title.tr(),
                    showBack: widget.showBack),
                SegmentTabs<bool>(
                  items: [
                    SegmentItem(true,
                        '${DateHelper.monthName(previous.month)}${data.viewingPrevious && data.isLocked ? ' ${AppEmojis.lock}' : ''}'),
                    SegmentItem(
                      false,
                      '${DateHelper.monthName(now.month)}${data.currentClosed ? ' ${AppEmojis.lock}' : ''}',
                    ),
                  ],
                  selected: data.viewingPrevious,
                  onChanged: _cubit.viewPrevious,
                ),
                SizedBox(height: 8.h),
                SegmentTabs<ReportMode>(
                  items: [
                    for (final m in ReportMode.values) SegmentItem(m, m.tab)
                  ],
                  selected: data.mode,
                  onChanged: _cubit.setMode,
                ),
                if (data.isLocked) MonthLockBanner(isAdmin: isAdmin),
                ReportsSummary(board: data.board),
                SizedBox(height: 14.h),
                SegmentTabs<bool>(
                  items: [
                    SegmentItem(true, LocaleKeys.reports_sortTop.tr()),
                    SegmentItem(false, LocaleKeys.reports_sortLow.tr()),
                  ],
                  selected: _cubit.sortDesc,
                  onChanged: _cubit.setSortDesc,
                ),
                if (data.refreshing)
                  const LinearProgressIndicator(minHeight: 2),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _cubit.refresh,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
                      itemCount: people.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (_, i) => ReportRankCard(
                        person: people[i],
                        mode: data.mode,
                        position: people[i].rank,
                        reviewed: data.isReviewed(people[i].userId),
                        index: i,
                        onTap: () => AppSheet.show(
                          context,
                          child: EmployeeReportSheet(
                            userId: people[i].userId,
                            month: _cubit.month,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (!data.isLocked)
                  ReportsBottomBar(
                    reviewed: data.reviewedCount,
                    total: data.total,
                    onMarkAll: _cubit.markAllReviewed,
                    onClose: () =>
                        AppSheet.show(context, child: const CloseMonthSheet()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
