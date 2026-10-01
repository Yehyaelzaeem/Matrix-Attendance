import 'package:equatable/equatable.dart';

import 'user_role.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String jobTitle;
  final String? email;
  final String? avatarPath;
  final UserRole role;
  final AccountStatus status;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.jobTitle,
    required this.role,
    required this.status,
    this.email,
    this.avatarPath,
  });

  bool get isActive => status == AccountStatus.active;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'].toString(),
        name: json['name'] as String,
        phone: json['phone'] as String,
        jobTitle: (json['job_title'] ?? '') as String,
        email: json['email'] as String?,
        avatarPath: (json['avatar_url'] ?? json['avatar']) as String?,
        role: UserRole.fromName(json['role'] as String?),
        status: AccountStatus.fromName(json['status'] as String?),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'job_title': jobTitle,
        'email': email,
        'avatar': avatarPath,
        'role': role.name,
        'status': status.name,
      };

  UserModel copyWith({
    String? name,
    String? jobTitle,
    String? email,
    AccountStatus? status,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        phone: phone,
        jobTitle: jobTitle ?? this.jobTitle,
        email: email ?? this.email,
        avatarPath: avatarPath,
        role: role,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props =>
      [id, name, phone, jobTitle, email, avatarPath, role, status];
}
