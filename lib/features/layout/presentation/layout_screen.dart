import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_colors.dart';
import '../../admin/logic/approvals_cubit.dart';
import '../../admin/presentation/admin_decisions_screen.dart';
import '../../admin/presentation/admin_home_screen.dart';
import '../../admin/presentation/approvals_screen.dart';
import '../../admin/presentation/more_screen.dart';
import '../../attendance/logic/attendance_cubit.dart';
import '../../attendance/presentation/employee_home_screen.dart';
import '../../auth/data/models/user_role.dart';
import '../../auth/logic/auth_cubit.dart';
import '../../board/presentation/board_screen.dart';
import '../../catalog/logic/catalog_cubit.dart';
import '../../decisions/logic/decisions_cubit.dart';
import '../../notifications/logic/notifications_cubit.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../projects/logic/projects_cubit.dart';
import '../../reports/logic/reports_cubit.dart';
import '../../reports/presentation/reports_screen.dart';
import '../../requests/presentation/requests_screen.dart';
import '../../reviewer/presentation/reviewer_home_screen.dart';
import '../../tasks/data/models/task_enums.dart';
import '../../tasks/logic/tasks_cubit.dart';
import '../../tasks/presentation/my_work_screen.dart';
import '../../tasks/presentation/tasks_screen.dart';
import '../../team/logic/team_cubit.dart';
import '../logic/app_tab.dart';
import '../logic/layout_cubit.dart';
import 'widgets/app_bottom_nav.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  late final UserRole _role =
      context.read<AuthCubit>().currentUser?.role ?? UserRole.employee;
  late final List<AppTab> _tabs = AppTab.forRole(_role);
  late final LayoutCubit _layout = context.read<LayoutCubit>();

  @override
  void initState() {
    super.initState();
    _layout.start(_tabs);
    context.read<CatalogCubit>().load();
    context.read<TasksCubit>().load();
    context.read<DecisionsCubit>().load();
    context.read<NotificationsCubit>().load();
    context.read<AttendanceCubit>().load();
    if (_role != UserRole.employee) context.read<ReportsCubit>().load();
    if (_role != UserRole.reviewer) context.read<ProjectsCubit>().load();
    if (_role == UserRole.admin) {
      context.read<TeamCubit>().load();
      context.read<ApprovalsCubit>().load();
    }
  }

  Widget _screenFor(AppTab tab) => switch (tab) {
        AppTab.home => const EmployeeHomeScreen(),
        AppTab.board => const BoardScreen(),
        AppTab.myWork => const MyWorkScreen(),
        AppTab.requests => const RequestsScreen(),
        AppTab.profile => const ProfileScreen(),
        AppTab.reviewerHome => const ReviewerHomeScreen(),
        AppTab.reviewTasks =>
          const TasksScreen(isTab: true, initialStatus: TaskStatus.review),
        AppTab.reports => const ReportsScreen(),
        AppTab.adminHome => const AdminHomeScreen(),
        AppTab.approvals => const ApprovalsScreen(),
        AppTab.adminDecisions => const AdminDecisionsScreen(),
        AppTab.more => const MoreScreen(),
      };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit, AppTab>(
      builder: (context, current) => Scaffold(
        backgroundColor: AppColors.backgroundColor.themeColor,
        body: IndexedStack(
          index: _tabs.indexOf(current).clamp(0, _tabs.length - 1),
          children: [for (final tab in _tabs) _screenFor(tab)],
        ),
        bottomNavigationBar: AppBottomNav(
          tabs: _tabs,
          current: current,
          onSelect: _layout.select,
        ),
      ),
    );
  }
}
