import 'package:equatable/equatable.dart';

import '../../../../core/models/day_type.dart';
import '../../../../core/models/enum_value.dart';
import '../../../../core/utils/json_reader.dart';
import '../../../auth/data/models/job_name_model.dart';
import '../../../auth/data/models/user_role.dart';

class EmployeeModel extends Equatable {
  const EmployeeModel({
    required this.id,
    required this.name,
    required this.jobTitle,
    this.jobNameId,
    this.orgTitle,
    this.phone = '',
    this.email = '',
    this.image,
    this.role = UserRole.employee,
    this.schedule = kDefaultSchedule,
    this.suspended = false,
  });

  final int id;
  final String name;
  final String jobTitle;
  final int? jobNameId;
  final String? orgTitle;
  final String phone;
  final String email;
  final String? image;
  final UserRole role;
  final WeeklySchedule schedule;
  final bool suspended;

  String get localPhone =>
      phone.startsWith('+20') ? '0${phone.substring(3)}' : phone;

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

  factory EmployeeModel.fromJson(Map<String, dynamic> json,
      {WeeklySchedule? schedule}) {
    final job = JobNameModel.fromJson(json['job_name']);
    final org = JsonReader.stringOrNull(json['org_title']);
    final days = json['week_attendance_types'];
    return EmployeeModel(
      id: JsonReader.toInt(json['id']),
      name: JsonReader.string(json['name']),
      jobTitle: job?.name ?? org ?? '',
      jobNameId: job?.id,
      orgTitle: org,
      phone: JsonReader.string(json['phone']),
      email: JsonReader.string(json['email']),
      image: JsonReader.stringOrNull(json['image']),
      role: UserRole.fromName(EnumValue.keyOf(json['role'])),
      schedule: schedule ??
          (days == null ? kDefaultSchedule : scheduleFromJson(days)),
      suspended: EnumValue.keyOf(json['account_status']) == 'suspended',
    );
  }

  EmployeeModel copyWith({
    UserRole? role,
    WeeklySchedule? schedule,
    bool? suspended,
  }) =>
      EmployeeModel(
        id: id,
        name: name,
        jobTitle: jobTitle,
        jobNameId: jobNameId,
        orgTitle: orgTitle,
        phone: phone,
        email: email,
        image: image,
        role: role ?? this.role,
        schedule: schedule ?? this.schedule,
        suspended: suspended ?? this.suspended,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        jobTitle,
        jobNameId,
        orgTitle,
        phone,
        email,
        image,
        role,
        schedule,
        suspended,
      ];
}

class EmployeeMetrics extends Equatable {
  const EmployeeMetrics({this.attendance, this.kpi, this.overall});

  final int? attendance;
  final int? kpi;
  final int? overall;

  @override
  List<Object?> get props => [attendance, kpi, overall];
}
