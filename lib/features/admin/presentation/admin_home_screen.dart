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
import '../../decisions/data/models/decision_model.dart';
import '../../decisions/logic/decisions_cubit.dart';
import '../../decisions/presentation/widgets/compose_decision_sheet.dart';
import '../../layout/logic/app_tab.dart';
import '../../layout/logic/layout_cubit.dart';
import '../../tasks/data/models/task_enums.dart';
import '../../tasks/logic/tasks_cubit.dart';
import '../logic/approvals_cubit.dart';
import '../logic/approvals_tab_cubit.dart';
import 'widgets/admin_kpi_grid.dart';
import 'widgets/quick_actions_row.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final approvals = getIt<ApprovalsCubit>();
    final decisions = getIt<DecisionsCubit>();
    final tasks = getIt<TasksCubit>();
    final layout = getIt<LayoutCubit>();
    return ColoredBox(
      color: AppColors.backgroundColor.themeColor,
      child: BlocBuilder<ApprovalsCubit, ApprovalsState>(
        bloc: approvals,
        builder: (context, approvalsState) =>
            BlocBuilder<DecisionsCubit, DecisionsState>(
          bloc: decisions,
          builder: (context, _) => BlocBuilder<TasksCubit, TasksState>(
            bloc: tasks,
            builder: (context, _) {
              final pending =
                  approvalsState is ApprovalsSuccess ? approvalsState : null;
              final late = tasks.tasks.where((t) => t.isLate).toList();
              final poll = decisions.decisions
                  .where((d) => d.kind == DecisionKind.poll)
                  .firstOrNull;
              final decision = decisions.decisions
                  .where((d) => d.kind == DecisionKind.decision)
                  .firstOrNull;
              return SingleChildScrollView(
                child: HeaderOverlapLayout(
                  overlap: 72,
                  header: HomeHeader(subtitle: LocaleKeys.admin_dashboard.tr()),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AdminKpiGrid(day: getIt<BoardCubit>().today),
                      SectionTitle(title: LocaleKeys.admin_needsDecision.tr()),
                      AlertTile(
                        emoji: AppEmojis.inbox,
                        background: AppColors.warningSoftColor.themeColor,
                        title: LocaleKeys.admin_pendingRequests.tr(),
                        subtitle: LocaleKeys.admin_pendingRequestsSub.tr(),
                        count: '${pending?.requests.length ?? 0}',
                        countColor: AppColors.warningTextColor.themeColor,
                        onTap: () {
                          getIt<ApprovalsTabCubit>()
                              .select(ApprovalsTab.requests);
                          layout.select(AppTab.approvals);
                        },
                      ),
                      AlertTile(
                        emoji: AppEmojis.technologist,
                        background: AppColors.primarySoftColor.themeColor,
                        title: LocaleKeys.admin_newAccounts.tr(),
                        subtitle: LocaleKeys.admin_newAccountsSub.tr(),
                        count: '${pending?.accounts.length ?? 0}',
                        countColor: AppColors.primaryColor.themeColor,
                        onTap: () {
                          getIt<ApprovalsTabCubit>()
                              .select(ApprovalsTab.accounts);
                          layout.select(AppTab.approvals);
                        },
                      ),
                      if (late.isNotEmpty)
                        AlertTile(
                          emoji: AppEmojis.alarm,
                          background: AppColors.errorSoftColor.themeColor,
                          title: LocaleKeys.admin_lateTasks.tr(),
                          subtitle:
                              LocaleKeys.admin_lateTasksSub.tr(namedArgs: {
                            'n':
                                '${late.map((t) => t.projectId).toSet().length}',
                          }),
                          count: '${late.length}',
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
                            'a': '${poll.votes}',
                            'b': '${poll.total}',
                            'deadline': poll.deadline ?? '',
                          }),
                          count:
                              '${poll.votes == 0 ? 0 : (poll.yes / poll.votes * 100).round()}%',
                          countColor: AppColors.violetColor.themeColor,
                          onTap: () => layout.select(AppTab.adminDecisions),
                        ),
                      if (decision != null)
                        AlertTile(
                          emoji: AppEmojis.pin,
                          background: AppColors.orangeSoftColor.themeColor,
                          title: decision.title,
                          subtitle:
                              LocaleKeys.admin_decisionPending.tr(namedArgs: {
                            'n': '${decision.total - decision.doneCount}',
                          }),
                          count: '${decision.doneCount}/${decision.total}',
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
              );
            },
          ),
        ),
      ),
    );
  }
}
