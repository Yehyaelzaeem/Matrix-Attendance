import 'package:equatable/equatable.dart';

class RegisterPayload extends Equatable {
  const RegisterPayload({
    required this.name,
    required this.phone,
    required this.jobTitle,
    required this.avatarPath,
  });

  final String name;
  final String phone;
  final String jobTitle;
  final String avatarPath;

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'job_title': jobTitle,
      };

  @override
  List<Object?> get props => [name, phone, jobTitle, avatarPath];
}
