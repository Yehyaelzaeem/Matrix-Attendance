import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/status_chip.dart';

enum TaskStatus {
  todo(ChipTone.gray, AppEmojis.circle),
  doing(ChipTone.blue, AppEmojis.playSmall),
  review(ChipTone.violet, AppEmojis.eyes),
  test(ChipTone.orange, AppEmojis.testTube),
  done(ChipTone.green, AppEmojis.check);

  const TaskStatus(this.tone, this.emoji);

  final ChipTone tone;
  final String emoji;

  static TaskStatus fromKey(String? key) => TaskStatus.values
      .firstWhere((e) => e.name == key, orElse: () => TaskStatus.todo);

  String get label => switch (this) {
        TaskStatus.todo => LocaleKeys.tasks_statusTodo.tr(),
        TaskStatus.doing => LocaleKeys.tasks_statusDoing.tr(),
        TaskStatus.review => LocaleKeys.tasks_statusReview.tr(),
        TaskStatus.test => LocaleKeys.tasks_statusTest.tr(),
        TaskStatus.done => LocaleKeys.tasks_statusDone.tr(),
      };

  Color get softColor => switch (this) {
        TaskStatus.todo => AppColors.dividerColor.themeColor,
        TaskStatus.doing => AppColors.primarySoftColor.themeColor,
        TaskStatus.review => AppColors.violetSoftColor.themeColor,
        TaskStatus.test => AppColors.orangeSoftColor.themeColor,
        TaskStatus.done => AppColors.successSoftColor.themeColor,
      };
}

enum TaskPriority {
  high(ChipTone.red),
  med(ChipTone.yellow),
  low(ChipTone.gray);

  const TaskPriority(this.tone);

  final ChipTone tone;

  static TaskPriority fromKey(String? key) => TaskPriority.values
      .firstWhere((e) => e.name == key, orElse: () => TaskPriority.med);

  String get label => switch (this) {
        TaskPriority.high => LocaleKeys.tasks_priorityHigh.tr(),
        TaskPriority.med => LocaleKeys.tasks_priorityMed.tr(),
        TaskPriority.low => LocaleKeys.tasks_priorityLow.tr(),
      };
}

enum CommentKind {
  comment,
  returned,
  system;

  static CommentKind fromKey(String? key) => switch (key) {
        'return' => CommentKind.returned,
        'system' => CommentKind.system,
        _ => CommentKind.comment,
      };
}

enum AttachmentType {
  image,
  video,
  doc;

  static AttachmentType fromKey(String? key) => AttachmentType.values
      .firstWhere((e) => e.name == key, orElse: () => AttachmentType.doc);
}

enum DueFilter { all, late, today, week, month }

extension DueFilterLabel on DueFilter {
  String get label => switch (this) {
        DueFilter.all => LocaleKeys.tasks_dueAll.tr(),
        DueFilter.late => LocaleKeys.tasks_dueLate.tr(),
        DueFilter.today => LocaleKeys.tasks_dueToday.tr(),
        DueFilter.week => LocaleKeys.tasks_dueWeek.tr(),
        DueFilter.month => LocaleKeys.tasks_dueMonth.tr(),
      };

  String get emoji => switch (this) {
        DueFilter.all => AppEmojis.calendar,
        DueFilter.late => AppEmojis.alarm,
        DueFilter.today => AppEmojis.pin,
        DueFilter.week => AppEmojis.calendarSpiral,
        DueFilter.month => AppEmojis.calendarTear,
      };
}
