import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_emojis.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../../core/widgets/segment_tabs.dart';
import '../../tasks/data/models/task_kpi.dart';
import '../../tasks/logic/tasks_cubit.dart';
import '../data/models/employee_report.dart';
import '../logic/reports_cubit.dart';
import 'widgets/close_month_sheet.dart';
import 'widgets/employee_report_sheet.dart';
import 'widgets/month_lock_banner.dart';
import 'widgets/report_rank_card.dart';
import 'widgets/reports_bottom_bar.dart';
import 'widgets/reports_summary.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key, this.showBack = false});

  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<ReportsCubit>()..load();
    final tasks = getIt<TasksCubit>();
    final now = DateTime.now();
    final previous = DateTime(now.year, now.month - 1);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: BlocBuilder<TasksCubit, TasksState>(
        bloc: tasks,
        builder: (context, _) => BlocBuilder<ReportsCubit, ReportsState>(
          bloc: cubit,
          builder: (context, state) => CustomScreenStateLayout(
            isLoading: state is! ReportsSuccess,
            builder: (_) {
              final data = state as ReportsSuccess;
              TaskKpi kpi(EmployeeReport r) => TaskKpi.of(r.name, tasks.tasks);
              final list = [...data.reports]..sort((a, b) {
                  final va = a.value(data.mode, kpi(a));
                  final vb = b.value(data.mode, kpi(b));
                  return data.sortDesc ? vb.compareTo(va) : va.compareTo(vb);
                });
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PageTopBar(
                      title: LocaleKeys.reports_title.tr(), showBack: showBack),
                  SegmentTabs<bool>(
                    items: [
                      SegmentItem(true,
                          '${DateHelper.monthName(previous.month)} ${AppEmojis.lock}'),
                      SegmentItem(
                        false,
                        '${DateHelper.monthName(now.month)}${data.currentClosed ? ' ${AppEmojis.lock}' : ''}',
                      ),
                    ],
                    selected: data.viewingPrevious,
                    onChanged: cubit.viewPrevious,
                  ),
                  SizedBox(height: 8.h),
                  SegmentTabs<ReportMode>(
                    items: [
                      for (final m in ReportMode.values) SegmentItem(m, m.tab)
                    ],
                    selected: data.mode,
                    onChanged: cubit.setMode,
                  ),
                  if (data.isLocked) MonthLockBanner(isAdmin: tasks.isAdmin),
                  ReportsSummary(data: data, tasks: tasks.tasks),
                  SizedBox(height: 14.h),
                  SegmentTabs<bool>(
                    items: [
                      SegmentItem(true, LocaleKeys.reports_sortTop.tr()),
                      SegmentItem(false, LocaleKeys.reports_sortLow.tr()),
                    ],
                    selected: data.sortDesc,
                    onChanged: cubit.setSortDesc,
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (_, i) => ReportRankCard(
                        report: list[i],
                        kpi: kpi(list[i]),
                        mode: data.mode,
                        position: data.sortDesc ? i + 1 : list.length - i,
                        reviewed: data.isReviewed(list[i].name),
                        index: i,
                        onTap: () => AppSheet.show(
                          context,
                          child: EmployeeReportSheet(name: list[i].name),
                        ),
                      ),
                    ),
                  ),
                  if (!data.isLocked)
                    ReportsBottomBar(
                      reviewed: data.reviewedCount,
                      total: data.reports.length,
                      onMarkAll: cubit.markAllReviewed,
                      onClose: () => AppSheet.show(context,
                          child: const CloseMonthSheet()),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
