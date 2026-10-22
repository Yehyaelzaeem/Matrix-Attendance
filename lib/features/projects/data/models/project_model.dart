import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/models/enum_value.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/json_reader.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/status_chip.dart';

enum ProjectStatus {
  active(ChipTone.blue),
  hold(ChipTone.yellow),
  delivered(ChipTone.green);

  const ProjectStatus(this.tone);

  final ChipTone tone;

  static ProjectStatus fromKey(String? key) => ProjectStatus.values
      .firstWhere((e) => e.name == key, orElse: () => ProjectStatus.active);

  String get label => switch (this) {
        ProjectStatus.active => LocaleKeys.projects_statusActive.tr(),
        ProjectStatus.hold => LocaleKeys.projects_statusHold.tr(),
        ProjectStatus.delivered => LocaleKeys.projects_statusDelivered.tr(),
      };
}

class TeamMember extends Equatable {
  const TeamMember({
    required this.userId,
    required this.name,
    required this.role,
    this.image,
  });

  final int userId;
  final String name;
  final String role;
  final String? image;

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    final user = JsonReader.map(json['user']);
    return TeamMember(
      userId: JsonReader.toInt(json['user_id'] ?? user['id']),
      name: JsonReader.string(user['name']),
      role: JsonReader.string(json['role_label']),
      image: JsonReader.stringOrNull(user['image']),
    );
  }

  @override
  List<Object?> get props => [userId, name, role, image];
}

class ClientInfo extends Equatable {
  const ClientInfo({
    this.name = '',
    this.company = '',
    this.phone = '',
    this.email = '',
    this.city = '',
  });

  final String name;
  final String company;
  final String phone;
  final String email;
  final String city;

  bool get isEmpty => name.isEmpty && company.isEmpty;

  factory ClientInfo.fromJson(dynamic json) {
    final map = JsonReader.map(json);
    return ClientInfo(
      name: JsonReader.string(map['name']),
      company: JsonReader.string(map['company']),
      phone: JsonReader.string(map['phone']),
      email: JsonReader.string(map['email']),
      city: JsonReader.string(map['city']),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'company': company,
        'phone': phone,
        'email': email,
        'city': city,
      };

  @override
  List<Object?> get props => [name, company, phone, email, city];
}

class PaymentModel extends Equatable {
  const PaymentModel({
    required this.id,
    required this.label,
    required this.amount,
    required this.due,
    this.paid = false,
    this.paidAt,
  });

  final int id;
  final String label;
  final double amount;
  final DateTime? due;
  final bool paid;
  final DateTime? paidAt;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        id: JsonReader.toInt(json['id']),
        label: JsonReader.string(json['label']),
        amount: JsonReader.toDouble(json['amount']),
        due: JsonReader.date(json['due_date']),
        paid: EnumValue.keyOf(json['status']) == 'paid',
        paidAt: JsonReader.dateTime(json['paid_at']),
      );

  @override
  List<Object?> get props => [id, label, amount, due, paid, paidAt];
}

class ContractInfo extends Equatable {
  const ContractInfo({
    this.number = '',
    this.signedAt,
    this.months = 0,
    this.fileUrl,
    this.notes = '',
  });

  final String number;
  final DateTime? signedAt;
  final int months;
  final String? fileUrl;
  final String notes;

  String get fileName =>
      fileUrl == null ? '' : Uri.parse(fileUrl!).pathSegments.last;

  factory ContractInfo.fromJson(dynamic json) {
    final map = JsonReader.map(json);
    return ContractInfo(
      number: JsonReader.string(map['number']),
      signedAt: JsonReader.date(map['signed_at']),
      months: JsonReader.toInt(map['duration_months']),
      fileUrl: JsonReader.stringOrNull(map['file_url']),
      notes: JsonReader.string(map['notes']),
    );
  }

  @override
  List<Object?> get props => [number, signedAt, months, fileUrl, notes];
}

class ProjectModel extends Equatable {
  const ProjectModel({
    required this.id,
    required this.name,
    required this.kind,
    required this.color,
    required this.status,
    required this.description,
    required this.team,
    this.managerId,
    this.manager = '',
    this.client = const ClientInfo(),
    this.currency = '',
    this.value = 0,
    this.payments = const [],
    this.start,
    this.beta,
    this.due,
    this.delivered,
    this.contract = const ContractInfo(),
    this.hasFinance = false,
  });

  final int id;
  final String name;
  final String kind;
  final Color color;
  final ProjectStatus status;
  final String description;
  final int? managerId;
  final String manager;
  final List<TeamMember> team;
  final ClientInfo client;
  final String currency;
  final double value;
  final List<PaymentModel> payments;
  final DateTime? start;
  final DateTime? beta;
  final DateTime? due;
  final DateTime? delivered;
  final ContractInfo contract;
  final bool hasFinance;

  int get daysToDue => due == null ? 999 : DateHelper.dayDiff(due!);

  String get shortName => name.length > 2 ? name.substring(0, 2) : name;

  double get paidAmount =>
      payments.where((p) => p.paid).fold(0, (sum, p) => sum + p.amount);

  bool hasMember(int userId) =>
      managerId == userId || team.any((m) => m.userId == userId);

  List<TeamMember> get people => [
        if (managerId != null && member(managerId!) == null)
          TeamMember(userId: managerId!, name: manager, role: ''),
        ...team,
      ];

  TeamMember? member(int userId) {
    for (final m in team) {
      if (m.userId == userId) return m;
    }
    return null;
  }

  static Color parseColor(String? hex, int id) {
    final value = hex?.replaceFirst('#', '');
    final parsed = value == null || value.length != 6
        ? null
        : int.tryParse('ff$value', radix: 16);
    if (parsed != null) return Color(parsed);
    return AppColors.avatarPalette[id % AppColors.avatarPalette.length];
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    final id = JsonReader.toInt(json['id']);
    final manager = JsonReader.mapOrNull(json['manager']);
    final hasFinance =
        json.containsKey('payments') || json.containsKey('contract_value');
    return ProjectModel(
      id: id,
      name: JsonReader.string(json['name']),
      kind: JsonReader.string(json['kind']),
      description: JsonReader.string(json['description']),
      color: parseColor(JsonReader.stringOrNull(json['color']), id),
      status: ProjectStatus.fromKey(EnumValue.keyOf(json['status'])),
      managerId: JsonReader.intOrNull(manager?['id']),
      manager: JsonReader.string(manager?['name']),
      team: JsonReader.list(json['members']).map(TeamMember.fromJson).toList(),
      client: ClientInfo.fromJson(json['client']),
      currency: EnumValue.keyOf(json['currency']),
      value: JsonReader.toDouble(json['contract_value']),
      payments:
          JsonReader.list(json['payments']).map(PaymentModel.fromJson).toList(),
      start: JsonReader.date(json['start_date']),
      beta: JsonReader.date(json['beta_date']),
      due: JsonReader.date(json['due_date']),
      delivered: JsonReader.dateTime(json['delivered_at']),
      contract: ContractInfo.fromJson(json['contract']),
      hasFinance: hasFinance,
    );
  }

  ProjectModel copyWith({List<PaymentModel>? payments}) => ProjectModel(
        id: id,
        name: name,
        kind: kind,
        color: color,
        status: status,
        description: description,
        managerId: managerId,
        manager: manager,
        team: team,
        client: client,
        currency: currency,
        value: value,
        payments: payments ?? this.payments,
        start: start,
        beta: beta,
        due: due,
        delivered: delivered,
        contract: contract,
        hasFinance: hasFinance,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        kind,
        color,
        status,
        description,
        managerId,
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
        hasFinance,
      ];
}
