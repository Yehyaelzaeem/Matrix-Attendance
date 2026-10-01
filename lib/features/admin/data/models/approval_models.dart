import 'package:equatable/equatable.dart';

enum LogOutcome { approved, rejected, activated }

class NewAccountModel extends Equatable {
  const NewAccountModel({
    required this.name,
    required this.phone,
    required this.jobTitle,
    required this.when,
  });

  final String name;
  final String phone;
  final String jobTitle;
  final String when;

  @override
  List<Object?> get props => [name, phone, jobTitle, when];
}

class ApprovalLogEntry extends Equatable {
  const ApprovalLogEntry({
    required this.name,
    required this.what,
    required this.outcome,
    required this.when,
    this.reason,
  });

  final String name;
  final String what;
  final LogOutcome outcome;
  final String when;
  final String? reason;

  @override
  List<Object?> get props => [name, what, outcome, when, reason];
}
