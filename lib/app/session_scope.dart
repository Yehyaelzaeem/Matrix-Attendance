import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/injection.dart';
import '../features/admin/logic/approvals_cubit.dart';
import '../features/admin/logic/approvals_tab_cubit.dart';
import '../features/attendance/logic/attendance_cubit.dart';
import '../features/auth/logic/auth_cubit.dart';
import '../features/board/logic/board_cubit.dart';
import '../features/catalog/logic/catalog_cubit.dart';
import '../features/dashboard/logic/dashboard_cubit.dart';
import '../features/decisions/logic/decisions_cubit.dart';
import '../features/layout/logic/layout_cubit.dart';
import '../features/notifications/logic/notifications_cubit.dart';
import '../features/projects/logic/projects_cubit.dart';
import '../features/reports/logic/reports_cubit.dart';
import '../features/requests/logic/requests_cubit.dart';
import '../features/tasks/logic/tasks_cubit.dart';
import '../features/team/logic/team_cubit.dart';

class SessionScope extends StatelessWidget {
  const SessionScope({super.key, required this.child});

  final Widget child;

  static final ValueNotifier<int> _version = ValueNotifier(0);

  static Future<void> restart() async {
    getIt<AuthCubit>().clearSession();
    await resetSession();
    _version.value++;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _version,
      child: child,
      builder: (_, __, child) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(value: getIt<AuthCubit>()),
          BlocProvider<LayoutCubit>.value(value: getIt<LayoutCubit>()),
          BlocProvider<CatalogCubit>.value(value: getIt<CatalogCubit>()),
          BlocProvider<DashboardCubit>.value(value: getIt<DashboardCubit>()),
          BlocProvider<AttendanceCubit>.value(value: getIt<AttendanceCubit>()),
          BlocProvider<BoardCubit>.value(value: getIt<BoardCubit>()),
          BlocProvider<TeamCubit>.value(value: getIt<TeamCubit>()),
          BlocProvider<TasksCubit>.value(value: getIt<TasksCubit>()),
          BlocProvider<ProjectsCubit>.value(value: getIt<ProjectsCubit>()),
          BlocProvider<RequestsCubit>.value(value: getIt<RequestsCubit>()),
          BlocProvider<DecisionsCubit>.value(value: getIt<DecisionsCubit>()),
          BlocProvider<ApprovalsCubit>.value(value: getIt<ApprovalsCubit>()),
          BlocProvider<ApprovalsTabCubit>.value(
              value: getIt<ApprovalsTabCubit>()),
          BlocProvider<ReportsCubit>.value(value: getIt<ReportsCubit>()),
          BlocProvider<NotificationsCubit>.value(
              value: getIt<NotificationsCubit>()),
        ],
        child: child!,
      ),
    );
  }
}
