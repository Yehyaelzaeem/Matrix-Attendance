import 'package:equatable/equatable.dart';

import '../../../../core/models/day_type.dart';
import '../../../auth/data/models/user_role.dart';

class EmployeeModel extends Equatable {
  const EmployeeModel({
    required this.name,
    required this.jobTitle,
    this.role = UserRole.employee,
    this.schedule = kDefaultSchedule,
    this.suspended = false,
  });

  final String name;
  final String jobTitle;
  final UserRole role;
  final WeeklySchedule schedule;
  final bool suspended;

  String get shortRole {
    final j = jobTitle.toLowerCase();
    if (RegExp(r'pm|project|scrum|business').hasMatch(j)) return 'PM';
    if (RegExp(r'test|qa').hasMatch(j)) return 'QA';
    if (RegExp(r'ui|ux|graphic').hasMatch(j)) return 'Design';
    if (j.contains('devops')) return 'DevOps';
    return 'Developer';
  }

  bool get isManagerTitle =>
      RegExp(r'pm|project|scrum', caseSensitive: false).hasMatch(jobTitle);

  EmployeeModel copyWith(
          {UserRole? role, WeeklySchedule? schedule, bool? suspended}) =>
      EmployeeModel(
        name: name,
        jobTitle: jobTitle,
        role: role ?? this.role,
        schedule: schedule ?? this.schedule,
        suspended: suspended ?? this.suspended,
      );

  @override
  List<Object?> get props => [name, jobTitle, role, schedule, suspended];
}
