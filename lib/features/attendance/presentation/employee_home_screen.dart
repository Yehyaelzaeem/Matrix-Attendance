import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/header_overlap_layout.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../../core/widgets/section_title.dart';
import '../../decisions/presentation/widgets/pinned_decision_section.dart';
import '../../layout/logic/app_tab.dart';
import '../../layout/logic/layout_cubit.dart';
import '../../requests/data/models/request_model.dart';
import '../../requests/presentation/widgets/new_request_sheet.dart';
import '../data/models/attendance_enums.dart';
import '../data/models/attendance_overview.dart';
import '../logic/attendance_cubit.dart';
import 'widgets/check_in_sheet.dart';
import 'widgets/checkout_sheet.dart';
import 'widgets/clock_card.dart';
import 'widgets/home_header.dart';
import 'widgets/home_tasks_section.dart';
import 'widgets/month_stats_grid.dart';
import 'widgets/pause_sheet.dart';
import 'widgets/resume_result_view.dart';
import 'widgets/week_strip.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  late final AttendanceCubit _cubit = context.read<AttendanceCubit>();

  void _openRequestFromCheckIn() {
    Navigator.of(context).pop();
    context.read<LayoutCubit>().select(AppTab.requests);
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      AppSheet.show(context,
          child: const NewRequestSheet(initialType: RequestType.swap));
    });
  }

  Future<void> _onMain(AttendanceOverview overview) async {
    switch (overview.day.phase) {
      case AttendancePhase.idle:
        AppSheet.show(
          context,
          child: CheckInSheet(onSubmitRequest: _openRequestFromCheckIn),
        );
      case AttendancePhase.working:
        AppSheet.show(context, child: CheckoutSheet(day: overview.day));
      case AttendancePhase.paused:
        final day = await _cubit.resume();
        if (day != null && mounted) {
          AppSheet.show(context, child: ResumeResultView(day: day));
        }
      case AttendancePhase.done:
        AppOverlay.showSuccess(LocaleKeys.attendance_dayClosedToast.tr());
    }
  }

  void _onPause(AttendanceOverview overview) {
    if (overview.day.phase == AttendancePhase.working) {
      AppSheet.show(context, child: const PauseSheet());
    } else if (overview.day.phase == AttendancePhase.paused) {
      AppSheet.show(context, child: CheckoutSheet(day: overview.day));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) => CustomScreenStateLayout(
        isLoading: state is AttendanceInitial || state is AttendanceLoading,
        error: state is AttendanceError
            ? ErrorModel(
                code: ErrorEnum.otherError, errorMessage: state.message)
            : null,
        onRetry: _cubit.load,
        builder: (_) {
          final overview = (state as AttendanceSuccess).overview;
          return RefreshIndicator(
            onRefresh: _cubit.refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: HeaderOverlapLayout(
                header: const HomeHeader(),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClockCard(
                      overview: overview,
                      onMainAction: () => _onMain(overview),
                      onPauseAction: () => _onPause(overview),
                    ),
                    const HomeTasksSection(),
                    const PinnedDecisionSection(),
                    SectionTitle(
                      title: LocaleKeys.attendance_myWeek.tr(),
                      actionLabel: LocaleKeys.common_view.tr(),
                      onAction: () =>
                          context.read<LayoutCubit>().select(AppTab.profile),
                    ),
                    WeekStrip(schedule: overview.schedule),
                    SectionTitle(
                      title: LocaleKeys.attendance_thisMonth.tr(),
                      actionLabel: LocaleKeys.attendance_report.tr(),
                      onAction: () =>
                          context.read<LayoutCubit>().select(AppTab.profile),
                    ),
                    MonthStatsGrid(month: overview.month),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
