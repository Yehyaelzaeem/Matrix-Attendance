import 'package:equatable/equatable.dart';

import '../../../../core/models/enum_value.dart';
import '../../../../core/utils/json_reader.dart';
import 'job_name_model.dart';
import 'user_role.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.status,
    this.email,
    this.orgTitle,
    this.image,
    this.jobName,
  });

  final int id;
  final String name;
  final String phone;
  final String? email;
  final UserRole role;
  final AccountStatus status;
  final String? orgTitle;
  final String? image;
  final JobNameModel? jobName;

  String get jobTitle => jobName?.name ?? orgTitle ?? '';

  String? get avatarPath => image;

  bool get isActive => status == AccountStatus.active;

  String get localPhone =>
      phone.startsWith('+20') ? '0${phone.substring(3)}' : phone;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: JsonReader.toInt(json['id']),
        name: JsonReader.string(json['name']),
        phone: JsonReader.string(json['phone']),
        email: JsonReader.stringOrNull(json['email']),
        role: UserRole.fromName(EnumValue.keyOf(json['role'])),
        status: AccountStatus.fromName(EnumValue.keyOf(json['account_status'])),
        orgTitle: JsonReader.stringOrNull(json['org_title']),
        image: JsonReader.stringOrNull(json['image']),
        jobName: JobNameModel.fromJson(json['job_name']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'role': {'key': role.name},
        'account_status': {'key': status.name},
        'org_title': orgTitle,
        'image': image,
        'job_name': jobName?.toJson(),
      };

  @override
  List<Object?> get props =>
      [id, name, phone, email, role, status, orgTitle, image, jobName];
}
