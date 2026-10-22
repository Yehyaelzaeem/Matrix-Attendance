import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/models/enum_value.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/json_reader.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../auth/data/models/user_role.dart';

enum RequestType {
  leave(AppEmojis.leave),
  absence(AppEmojis.calendar),
  swap(AppEmojis.swap),
  late(AppEmojis.alarm),
  early(AppEmojis.door),
  fix(AppEmojis.pencil),
  schedule(AppEmojis.calendarSpiral);

  const RequestType(this.emoji);

  final String emoji;

  String get key => this == RequestType.schedule ? 'sched' : name;

  static RequestType fromKey(String? key) => key == 'sched'
      ? RequestType.schedule
      : RequestType.values
          .firstWhere((e) => e.name == key, orElse: () => RequestType.leave);

  String get label => switch (this) {
        RequestType.leave => LocaleKeys.requests_typeLeave.tr(),
        RequestType.absence => LocaleKeys.requests_typeAbsence.tr(),
        RequestType.swap => LocaleKeys.requests_typeSwap.tr(),
        RequestType.late => LocaleKeys.requests_typeLate.tr(),
        RequestType.early => LocaleKeys.requests_typeEarly.tr(),
        RequestType.fix => LocaleKeys.requests_typeFix.tr(),
        RequestType.schedule => LocaleKeys.requests_typeSchedule.tr(),
      };

  Color get softColor => switch (this) {
        RequestType.leave => AppColors.violetSoftColor.themeColor,
        RequestType.absence => AppColors.errorSoftColor.themeColor,
        RequestType.swap => AppColors.primarySoftColor.themeColor,
        RequestType.late => AppColors.warningSoftColor.themeColor,
        RequestType.early => AppColors.orangeSoftColor.themeColor,
        RequestType.fix => AppColors.successSoftColor.themeColor,
        RequestType.schedule => AppColors.neutralSoftColor.themeColor,
      };
}

enum RequestStatus {
  pending(ChipTone.yellow),
  approved(ChipTone.green),
  rejected(ChipTone.red);

  const RequestStatus(this.tone);

  final ChipTone tone;

  static RequestStatus fromKey(String? key) => RequestStatus.values
      .firstWhere((e) => e.name == key, orElse: () => RequestStatus.pending);

  String get label => switch (this) {
        RequestStatus.pending => LocaleKeys.requests_statusPending.tr(),
        RequestStatus.approved => LocaleKeys.requests_statusApproved.tr(),
        RequestStatus.rejected => LocaleKeys.requests_statusRejected.tr(),
      };
}

class RequestModel extends Equatable {
  const RequestModel({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.reason,
    required this.createdAt,
    this.employee,
    this.employeeJob,
    this.employeeImage,
    this.requesterRole = UserRole.employee,
    this.decidedBy,
    this.decidedAt,
    this.rejectReason,
  });

  final int id;
  final RequestType type;
  final String title;
  final String subtitle;
  final RequestStatus status;
  final String reason;
  final DateTime createdAt;
  final String? employee;
  final String? employeeJob;
  final String? employeeImage;
  final UserRole requesterRole;
  final String? decidedBy;
  final DateTime? decidedAt;
  final String? rejectReason;

  String get when => DateHelper.relative(createdAt);

  String get decidedWhen => DateHelper.relative(decidedAt ?? createdAt);

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    final user = JsonReader.mapOrNull(json['user']);
    final job = user?['job_name'];
    final decidedBy = JsonReader.mapOrNull(json['decided_by']);
    return RequestModel(
      id: JsonReader.toInt(json['id']),
      type: RequestType.fromKey(EnumValue.keyOf(json['type'])),
      title: JsonReader.string(json['title']),
      subtitle: JsonReader.string(json['subtitle']),
      status: RequestStatus.fromKey(EnumValue.keyOf(json['status'])),
      reason: JsonReader.string(json['reason']),
      createdAt: JsonReader.dateTime(json['created_at']) ?? DateTime.now(),
      employee: JsonReader.stringOrNull(user?['name']),
      employeeJob: job is Map
          ? JsonReader.stringOrNull(job['name'])
          : JsonReader.stringOrNull(user?['org_title']),
      employeeImage: JsonReader.stringOrNull(user?['image']),
      requesterRole: UserRole.fromName(EnumValue.keyOf(user?['role'])),
      decidedBy: JsonReader.stringOrNull(decidedBy?['name']),
      decidedAt: JsonReader.dateTime(json['decided_at']),
      rejectReason: JsonReader.stringOrNull(json['rejection_reason']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        subtitle,
        status,
        reason,
        createdAt,
        employee,
        requesterRole,
        decidedBy,
        decidedAt,
        rejectReason,
      ];
}

class RequestSummary extends Equatable {
  const RequestSummary({
    this.all = 0,
    this.pending = 0,
    this.approved = 0,
    this.rejected = 0,
  });

  final int all;
  final int pending;
  final int approved;
  final int rejected;

  factory RequestSummary.fromJson(dynamic json) {
    final map = JsonReader.map(json);
    return RequestSummary(
      all: JsonReader.toInt(map['all']),
      pending: JsonReader.toInt(map['pending']),
      approved: JsonReader.toInt(map['approved']),
      rejected: JsonReader.toInt(map['rejected']),
    );
  }

  int of(RequestStatus? status) => switch (status) {
        null => all,
        RequestStatus.pending => pending,
        RequestStatus.approved => approved,
        RequestStatus.rejected => rejected,
      };

  @override
  List<Object?> get props => [all, pending, approved, rejected];
}

class RoleSummary extends Equatable {
  const RoleSummary({this.all = 0, this.employee = 0, this.reviewer = 0});

  final int all;
  final int employee;
  final int reviewer;

  factory RoleSummary.fromJson(dynamic json) {
    final map = JsonReader.map(json);
    return RoleSummary(
      all: JsonReader.toInt(map['all'] ?? map['total']),
      employee: JsonReader.toInt(map['employee']),
      reviewer: JsonReader.toInt(map['reviewer']),
    );
  }

  int of(UserRole? role) => switch (role) {
        null => all,
        UserRole.reviewer => reviewer,
        _ => employee,
      };

  @override
  List<Object?> get props => [all, employee, reviewer];
}
