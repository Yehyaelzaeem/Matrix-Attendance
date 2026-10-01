import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/utils/locale_keys.dart';
import '../../core/widgets/app_empty.dart';
import '../../features/admin/presentation/admin_profile_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';
import '../../features/auth/presentation/pending_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/decisions/presentation/decisions_screen.dart';
import '../../features/layout/presentation/layout_screen.dart';
import '../../features/onboarding/presentation/on_boarding_screen.dart';
import '../../features/projects/presentation/project_details_screen.dart';
import '../../features/projects/presentation/projects_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/tasks/data/models/task_enums.dart';
import '../../features/tasks/presentation/tasks_screen.dart';
import '../../features/team/presentation/employee_details_screen.dart';
import '../../features/team/presentation/employees_screen.dart';
import '../../features/team/presentation/holidays_screen.dart';
import '../../features/team/presentation/schedules_screen.dart';
import 'routes.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case Routes.splashScreen:
        return _pageRoute(const SplashScreen());

      case Routes.onBoardingScreen:
        return _pageRoute(const OnBoardingScreen());

      case Routes.loginScreen:
        return _pageRoute(const LoginScreen());

      case Routes.registerScreen:
        return _pageRoute(const RegisterScreen());

      case Routes.otpScreen:
        return _pageRoute(const OtpScreen());

      case Routes.pendingScreen:
        return _pageRoute(const PendingScreen());

      case Routes.layoutScreen:
        return _pageRoute(const LayoutScreen());

      case Routes.decisionsScreen:
        return _pageRoute(const DecisionsScreen());

      case Routes.projectsScreen:
        return _pageRoute(const ProjectsScreen());

      case Routes.projectDetailsScreen:
        return _pageRoute(ProjectDetailsScreen(
          projectId: arguments?['projectId'] as String,
          initialTab: arguments?['initialTab'] as int? ?? 0,
        ));

      case Routes.tasksScreen:
        return _pageRoute(TasksScreen(
          initialStatus: arguments?['status'] as TaskStatus?,
          initialAssignee: arguments?['assignee'] as String?,
          initialDue: arguments?['due'] as DueFilter? ?? DueFilter.all,
        ));

      case Routes.reportsScreen:
        return _pageRoute(const ReportsScreen(showBack: true));

      case Routes.employeesScreen:
        return _pageRoute(const EmployeesScreen());

      case Routes.employeeDetailsScreen:
        return _pageRoute(
            EmployeeDetailsScreen(name: arguments?['name'] as String));

      case Routes.schedulesScreen:
        return _pageRoute(const SchedulesScreen());

      case Routes.holidaysScreen:
        return _pageRoute(const HolidaysScreen());

      case Routes.adminProfileScreen:
        return _pageRoute(const AdminProfileScreen());

      default:
        return _pageRoute(const UndefinedScreen());
    }
  }

  static PageRoute<dynamic> _pageRoute(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }
}

class UndefinedScreen extends StatelessWidget {
  const UndefinedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Center(child: AppEmpty(message: LocaleKeys.error_pageNotFound.tr())),
    );
  }
}
