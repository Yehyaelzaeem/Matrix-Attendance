import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/status_chip.dart';

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
    required this.when,
    this.employee,
    this.decidedBy,
    this.rejectReason,
  });

  final String id;
  final RequestType type;
  final String title;
  final String subtitle;
  final RequestStatus status;
  final String reason;
  final String when;
  final String? employee;
  final String? decidedBy;
  final String? rejectReason;

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        subtitle,
        status,
        reason,
        when,
        employee,
        decidedBy,
        rejectReason
      ];
}
