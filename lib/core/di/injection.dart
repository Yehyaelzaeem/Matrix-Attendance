import 'package:get_it/get_it.dart';

import '../../features/admin/data/approvals_repo.dart';
import '../../features/admin/logic/approvals_cubit.dart';
import '../../features/admin/logic/approvals_tab_cubit.dart';
import '../../features/attendance/data/attendance_repo.dart';
import '../../features/attendance/data/whatsapp_group_repo.dart';
import '../../features/attendance/logic/attendance_cubit.dart';
import '../../features/auth/data/auth_repo.dart';
import '../../features/auth/logic/auth_cubit.dart';
import '../../features/board/data/board_repo.dart';
import '../../features/board/logic/board_cubit.dart';
import '../../features/catalog/data/catalog_repo.dart';
import '../../features/catalog/logic/catalog_cubit.dart';
import '../../features/dashboard/data/dashboard_repo.dart';
import '../../features/dashboard/logic/dashboard_cubit.dart';
import '../../features/decisions/data/decisions_repo.dart';
import '../../features/decisions/logic/decisions_cubit.dart';
import '../../features/layout/logic/layout_cubit.dart';
import '../../features/notifications/data/notifications_repo.dart';
import '../../features/notifications/logic/notifications_cubit.dart';
import '../../features/projects/data/projects_repo.dart';
import '../../features/projects/logic/projects_cubit.dart';
import '../../features/reports/data/reports_repo.dart';
import '../../features/reports/logic/report_detail_cubit.dart';
import '../../features/reports/logic/reports_cubit.dart';
import '../../features/requests/data/requests_repo.dart';
import '../../features/requests/logic/requests_cubit.dart';
import '../../features/tasks/data/tasks_repo.dart';
import '../../features/tasks/logic/tasks_cubit.dart';
import '../../features/team/logic/add_employee_cubit.dart';
import '../../features/team/data/team_repo.dart';
import '../../features/team/logic/employee_detail_cubit.dart';
import '../../features/team/logic/employees_cubit.dart';
import '../../features/team/logic/team_cubit.dart';
import '../network/dio_client.dart';
import '../services/location_service.dart';
import '../storage/local_storage.dart';

final getIt = GetIt.instance;

Future<void> setupDi() async {
  getIt.registerLazySingleton(() => LocalStorage());

  getIt.registerLazySingleton(() => DioClient(storage: getIt()));

  getIt.registerLazySingleton(() => AuthRepo(dio: getIt(), storage: getIt()));
  getIt.registerLazySingleton(() => LocationService());
  getIt.registerLazySingleton(
      () => AttendanceRepo(dio: getIt(), storage: getIt()));
  getIt.registerLazySingleton(() => WhatsappGroupRepo());
  getIt.registerLazySingleton(() => BoardRepo(dio: getIt()));
  getIt.registerLazySingleton(() => CatalogRepo(dio: getIt()));
  getIt.registerLazySingleton(() => DashboardRepo(dio: getIt()));
  getIt.registerLazySingleton(() => TeamRepo(dio: getIt()));
  getIt.registerLazySingleton(() => TasksRepo(dio: getIt()));
  getIt.registerLazySingleton(() => ProjectsRepo(dio: getIt()));
  getIt.registerLazySingleton(() => RequestsRepo(dio: getIt()));
  getIt.registerLazySingleton(() => DecisionsRepo(dio: getIt()));
  getIt.registerLazySingleton(() => NotificationsRepo(dio: getIt()));
  getIt.registerLazySingleton(() => ApprovalsRepo(dio: getIt()));
  getIt.registerLazySingleton(() => ReportsRepo(dio: getIt()));

  getIt.registerLazySingleton(() => AuthCubit(getIt()));
  _registerSessionCubits();
}

void _registerSessionCubits() {
  getIt.registerLazySingleton(() => LayoutCubit());
  getIt.registerLazySingleton(() => CatalogCubit(getIt()));
  getIt.registerLazySingleton(() => DashboardCubit(getIt(), getIt()));
  getIt.registerLazySingleton(() => AttendanceCubit(getIt(), getIt(), getIt()));
  getIt.registerLazySingleton(() => BoardCubit(getIt()));
  getIt.registerLazySingleton(() => TeamCubit(getIt()));
  getIt.registerFactory(() => EmployeesCubit(getIt(), getIt()));
  getIt.registerFactory(() => EmployeeDetailCubit(getIt()));
  getIt.registerFactory(
      () => AddEmployeeCubit(getIt(), getIt(), getIt(), getIt()));
  getIt.registerLazySingleton(() => TasksCubit(getIt(), getIt()));
  getIt.registerLazySingleton(() => ProjectsCubit(getIt()));
  getIt.registerLazySingleton(() => RequestsCubit(getIt()));
  getIt.registerLazySingleton(() => DecisionsCubit(getIt(), getIt()));
  getIt.registerLazySingleton(() => NotificationsCubit(getIt()));
  getIt.registerLazySingleton(() => ApprovalsCubit(getIt()));
  getIt.registerLazySingleton(() => ApprovalsTabCubit());
  getIt.registerLazySingleton(() => ReportsCubit(getIt()));
  getIt.registerFactory(() => ReportDetailCubit(getIt()));
}

Future<void> resetSession() async {
  await getIt.resetLazySingleton<LayoutCubit>();
  await getIt.resetLazySingleton<CatalogCubit>();
  await getIt.resetLazySingleton<DashboardCubit>();
  await getIt.resetLazySingleton<AttendanceCubit>();
  await getIt.resetLazySingleton<BoardCubit>();
  await getIt.resetLazySingleton<TeamCubit>();
  await getIt.resetLazySingleton<TasksCubit>();
  await getIt.resetLazySingleton<ProjectsCubit>();
  await getIt.resetLazySingleton<RequestsCubit>();
  await getIt.resetLazySingleton<DecisionsCubit>();
  await getIt.resetLazySingleton<NotificationsCubit>();
  await getIt.resetLazySingleton<ApprovalsCubit>();
  await getIt.resetLazySingleton<ApprovalsTabCubit>();
  await getIt.resetLazySingleton<ReportsCubit>();
}
