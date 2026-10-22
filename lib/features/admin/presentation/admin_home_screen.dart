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
import '../../dashboard/logic/dashboard_cubit.dart';
import '../../decisions/presentation/widgets/compose_decision_sheet.dart';
import '../../layout/logic/app_tab.dart';
import '../../layout/logic/layout_cubit.dart';
import '../../tasks/data/models/task_enums.dart';
import '../logic/approvals_tab_cubit.dart';
import 'widgets/admin_kpi_grid.dart';
import 'widgets/quick_actions_row.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  late final DashboardCubit _cubit = context.read<DashboardCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.loadAdmin();
  }

  @override
  Widget build(BuildContext context) {
    final layout = context.read<LayoutCubit>();
    return ColoredBox(
      color: AppColors.backgroundColor.themeColor,
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) => CustomScreenStateLayout(
          isLoading: state.admin == null && state.error == null,
          error: state.admin == null && state.error != null
              ? ErrorModel(
                  code: ErrorEnum.otherError, errorMessage: state.error!)
              : null,
          onRetry: _cubit.loadAdmin,
          builder: (_) {
            final data = state.admin!;
            final requests = data.pendingRequests;
            final late = data.overdueTasks;
            final poll = data.activePoll;
            final decision = data.openDecision;
            return RefreshIndicator(
              onRefresh: _cubit.loadAdmin,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: HeaderOverlapLayout(
                  overlap: 72,
                  header: HomeHeader(subtitle: LocaleKeys.admin_dashboard.tr()),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AdminKpiGrid(summary: data.today),
                      SectionTitle(title: LocaleKeys.admin_needsDecision.tr()),
                      AlertTile(
                        emoji: AppEmojis.inbox,
                        background: AppColors.warningSoftColor.themeColor,
                        title: LocaleKeys.admin_pendingRequests.tr(),
                        subtitle:
                            LocaleKeys.admin_pendingRequestsSub.tr(namedArgs: {
                          'e': '${requests.employee}',
                          'r': '${requests.reviewer}',
                        }),
                        count: '${requests.total}',
                        countColor: AppColors.warningTextColor.themeColor,
                        onTap: () {
                          context
                              .read<ApprovalsTabCubit>()
                              .select(ApprovalsTab.requests);
                          layout.select(AppTab.approvals);
                        },
                      ),
                      if (late != null)
                        AlertTile(
                          emoji: AppEmojis.alarm,
                          background: AppColors.errorSoftColor.themeColor,
                          title: LocaleKeys.admin_lateTasks.tr(),
                          subtitle: LocaleKeys.admin_lateTasksSub
                              .tr(namedArgs: {'n': '${late.projects}'}),
                          count: '${late.count}',
                          countColor: AppColors.errorColor.themeColor,
                          onTap: () => context.pushNamed(Routes.tasksScreen,
                              arguments: {'due': DueFilter.late}),
                        ),
                      if (poll != null)
                        AlertTile(
                          emoji: AppEmojis.ballot,
                          background: AppColors.violetSoftColor.themeColor,
                          title: poll.title,
                          subtitle:
                              LocaleKeys.admin_pollProgress.tr(namedArgs: {
                            'a': '${poll.voted}',
                            'b': '${poll.total}',
                            'deadline': LocaleKeys.decisions_daysLeft
                                .tr(namedArgs: {'n': '${poll.daysLeft}'}),
                          }),
                          count: '${poll.yesPct}%',
                          countColor: AppColors.violetColor.themeColor,
                          onTap: () => layout.select(AppTab.adminDecisions),
                        ),
                      if (decision != null)
                        AlertTile(
                          emoji: AppEmojis.pin,
                          background: AppColors.orangeSoftColor.themeColor,
                          title: decision.title,
                          subtitle: LocaleKeys.admin_decisionPending
                              .tr(namedArgs: {'n': '${decision.pending}'}),
                          count: '${decision.acked}/${decision.total}',
                          countColor: AppColors.orangeTextColor.themeColor,
                          onTap: () => layout.select(AppTab.adminDecisions),
                        ),
                      SectionTitle(title: LocaleKeys.admin_quickActions.tr()),
                      QuickActionsRow(actions: [
                        QuickAction(
                          emoji: AppEmojis.megaphone,
                          background: AppColors.orangeSoftColor.themeColor,
                          label: LocaleKeys.admin_qaDecision.tr(),
                          onTap: () => AppSheet.show(context,
                              child: const ComposeDecisionSheet()),
                        ),
                        QuickAction(
                          emoji: AppEmojis.checkBox,
                          background: AppColors.successSoftColor.themeColor,
                          label: LocaleKeys.admin_qaTasks.tr(),
                          onTap: () => context.pushNamed(Routes.tasksScreen),
                        ),
                        QuickAction(
                          emoji: AppEmojis.folder,
                          background: AppColors.primarySoftColor.themeColor,
                          label: LocaleKeys.admin_qaProjects.tr(),
                          onTap: () => context.pushNamed(Routes.projectsScreen),
                        ),
                        QuickAction(
                          emoji: AppEmojis.chart,
                          background: AppColors.violetSoftColor.themeColor,
                          label: LocaleKeys.admin_qaReports.tr(),
                          onTap: () => context.pushNamed(Routes.reportsScreen),
                        ),
                      ]),
                      SizedBox(height: 24.h),
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
