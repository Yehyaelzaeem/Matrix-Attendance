import 'dart:io';

class ApiEndpoints {
  ApiEndpoints._();

  static const String _override = String.fromEnvironment('API_BASE_URL');
  static const String _remote = 'http://attendance.matrixclouds.net/api/v1/';

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    return _remote;
  }

  static String get rootUrl => baseUrl.replaceFirst(RegExp(r'api/v1/?$'), '');

  static bool get isAndroid => Platform.isAndroid;

  static const String login = 'auth/login';
  static const String resendOtp = 'auth/otp/resend';
  static const String verifyOtp = 'auth/otp/verify';
  static const String logout = 'auth/logout';

  static const String me = 'me';
  static const String myDevice = 'me/device';
  static const String mySchedule = 'me/schedule';
  static const String myMonthlyAttendance = 'me/attendance/monthly';
  static const String myTasks = 'me/tasks';

  static const String enums = 'enums';

  static const String attendanceToday = 'attendance/today';
  static const String checkIn = 'attendance/check-in';
  static const String checkOut = 'attendance/check-out';
  static const String pause = 'attendance/pause';
  static const String resume = 'attendance/resume';
  static const String attendanceHistory = 'attendance';
  static const String board = 'attendance/board';

  static const String requests = 'requests';
  static const String adminRequests = 'admin/requests';
  static String approveRequest(int id) => 'admin/requests/$id/approve';
  static String rejectRequest(int id) => 'admin/requests/$id/reject';
  static const String approvalsLog = 'admin/approvals/log';

  static const String announcements = 'announcements';
  static const String pinnedAnnouncements = 'announcements/pinned';
  static String ackAnnouncement(int id) => 'announcements/$id/ack';
  static String voteAnnouncement(int id) => 'announcements/$id/vote';
  static const String adminAnnouncements = 'admin/announcements';
  static String announcementVoters(int id) => 'admin/announcements/$id/voters';
  static String remindAnnouncement(int id) => 'admin/announcements/$id/remind';

  static const String notifications = 'notifications';
  static String readNotification(int id) => 'notifications/$id/read';

  static const String holidays = 'holidays';
  static String holiday(int id) => 'holidays/$id';
  static const String jobCategories = 'job-categories';
  static const String jobNames = 'job-names';

  static const String projects = 'projects';
  static String project(int id) => 'projects/$id';
  static const String adminProjects = 'admin/projects';
  static String adminProject(int id) => 'admin/projects/$id';
  static String projectStatus(int id) => 'admin/projects/$id/status';
  static String projectMembers(int id) => 'admin/projects/$id/members';
  static String projectMember(int id, int userId) =>
      'admin/projects/$id/members/$userId';
  static String projectManager(int id) => 'admin/projects/$id/manager';
  static String projectClient(int id) => 'admin/projects/$id/client';
  static String projectContract(int id) => 'admin/projects/$id/contract';
  static String projectContractFile(int id) =>
      'admin/projects/$id/contract/file';
  static String projectFinance(int id) => 'admin/projects/$id/finance';
  static String projectPayments(int id) => 'admin/projects/$id/payments';
  static String payPayment(int id, int paymentId) =>
      'admin/projects/$id/payments/$paymentId/pay';

  static const String tasks = 'tasks';
  static String task(int id) => 'tasks/$id';
  static String taskTransition(int id) => 'tasks/$id/transition';
  static String taskComments(int id) => 'tasks/$id/comments';
  static String taskTime(int id) => 'tasks/$id/time';
  static String taskAttachments(int id) => 'tasks/$id/attachments';
  static String taskAttachment(int id, int attachmentId) =>
      'tasks/$id/attachments/$attachmentId';
  static const String returnsKpi = 'tasks/kpi/returns';

  static const String users = 'users';
  static String user(int id) => 'users/$id';
  static String suspendUser(int id) => 'users/$id/suspend';
  static String activateUser(int id) => 'users/$id/activate';
  static String resetUserDevice(int id) => 'users/$id/device/reset';
  static String userSchedule(int id) => 'users/$id/schedule';
  static const String adminSchedules = 'admin/schedules';
  static const String settings = 'settings';

  static const String reviewerDashboard = 'dashboard/reviewer';
  static const String adminDashboard = 'dashboard/admin';
  static const String monthlyReports = 'reports/monthly';
  static String monthlyReport(int userId) => 'reports/monthly/$userId';
  static String review(String month, int userId) =>
      'reports/$month/reviews/$userId';
  static String reviewAll(String month) => 'reports/$month/reviews/all';
  static String closeCheck(String month) => 'reports/$month/close-check';
  static String closeMonth(String month) => 'reports/$month/close';
  static String reopenMonth(String month) => 'admin/reports/$month/reopen';
  static const String auditLogs = 'admin/audit-logs';

  static const String broadcastingAuth = 'api/broadcasting/auth';
}
