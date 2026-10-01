import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/status_chip.dart';

enum ProjectStatus {
  active(ChipTone.blue),
  hold(ChipTone.yellow),
  delivered(ChipTone.green);

  const ProjectStatus(this.tone);

  final ChipTone tone;

  String get label => switch (this) {
        ProjectStatus.active => LocaleKeys.projects_statusActive.tr(),
        ProjectStatus.hold => LocaleKeys.projects_statusHold.tr(),
        ProjectStatus.delivered => LocaleKeys.projects_statusDelivered.tr(),
      };
}

class TeamMember extends Equatable {
  const TeamMember(this.name, this.role);

  final String name;
  final String role;

  @override
  List<Object?> get props => [name, role];
}

class ClientInfo extends Equatable {
  const ClientInfo({
    required this.name,
    required this.company,
    required this.phone,
    required this.email,
    required this.city,
  });

  final String name;
  final String company;
  final String phone;
  final String email;
  final String city;

  @override
  List<Object?> get props => [name, company, phone, email, city];
}

class PaymentModel extends Equatable {
  const PaymentModel({
    required this.label,
    required this.amount,
    required this.due,
    this.paid = false,
    this.paidAt,
  });

  final String label;
  final double amount;
  final DateTime due;
  final bool paid;
  final DateTime? paidAt;

  PaymentModel markPaid(DateTime at) => PaymentModel(
      label: label, amount: amount, due: due, paid: true, paidAt: at);

  @override
  List<Object?> get props => [label, amount, due, paid, paidAt];
}

class ContractInfo extends Equatable {
  const ContractInfo({
    required this.number,
    required this.signedAt,
    required this.months,
    this.fileName = '',
    this.notes = '',
  });

  final String number;
  final DateTime signedAt;
  final int months;
  final String fileName;
  final String notes;

  ContractInfo withFile(String name) => ContractInfo(
      number: number,
      signedAt: signedAt,
      months: months,
      fileName: name,
      notes: notes);

  @override
  List<Object?> get props => [number, signedAt, months, fileName, notes];
}

class ProjectModel extends Equatable {
  const ProjectModel({
    required this.id,
    required this.name,
    required this.kind,
    required this.color,
    required this.status,
    required this.description,
    required this.manager,
    required this.team,
    required this.client,
    required this.currency,
    required this.value,
    required this.payments,
    required this.start,
    required this.beta,
    required this.due,
    required this.contract,
    this.delivered,
  });

  final String id;
  final String name;
  final String kind;
  final Color color;
  final ProjectStatus status;
  final String description;
  final String manager;
  final List<TeamMember> team;
  final ClientInfo client;
  final String currency;
  final double value;
  final List<PaymentModel> payments;
  final DateTime start;
  final DateTime beta;
  final DateTime due;
  final DateTime? delivered;
  final ContractInfo contract;

  String get shortName => name.length > 2 ? name.substring(0, 2) : name;

  double get paidAmount =>
      payments.where((p) => p.paid).fold(0, (sum, p) => sum + p.amount);

  bool hasMember(String name) => team.any((m) => m.name == name);

  TeamMember? member(String name) {
    for (final m in team) {
      if (m.name == name) return m;
    }
    return null;
  }

  ProjectModel copyWith({
    ProjectStatus? status,
    String? manager,
    List<TeamMember>? team,
    ClientInfo? client,
    List<PaymentModel>? payments,
    DateTime? delivered,
    bool clearDelivered = false,
    ContractInfo? contract,
  }) =>
      ProjectModel(
        id: id,
        name: name,
        kind: kind,
        color: color,
        status: status ?? this.status,
        description: description,
        manager: manager ?? this.manager,
        team: team ?? this.team,
        client: client ?? this.client,
        currency: currency,
        value: value,
        payments: payments ?? this.payments,
        start: start,
        beta: beta,
        due: due,
        delivered: clearDelivered ? null : (delivered ?? this.delivered),
        contract: contract ?? this.contract,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        kind,
        color,
        status,
        description,
        manager,
        team,
        client,
        currency,
        value,
        payments,
        start,
        beta,
        due,
        delivered,
        contract,
      ];
}
