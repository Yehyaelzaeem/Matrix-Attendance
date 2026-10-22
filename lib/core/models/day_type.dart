import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_emojis.dart';
import '../utils/json_reader.dart';
import 'enum_value.dart';

enum DayType {
  office(AppEmojis.office, 8, 9, 17),
  home(AppEmojis.home, 10, 9, 19),
  off(AppEmojis.off, 0, 0, 0);

  const DayType(this.emoji, this.requiredHours, this.startHour, this.endHour);

  final String emoji;
  final int requiredHours;
  final int startHour;
  final int endHour;

  String get range => this == DayType.off
      ? ''
      : '\u2066$startHour:00 – ${endHour > 12 ? endHour - 12 : endHour}:00\u2069';

  Color get softColor => switch (this) {
        DayType.office => AppColors.primarySoftColor.themeColor,
        DayType.home => AppColors.violetSoftColor.themeColor,
        DayType.off => AppColors.neutralSoftColor.themeColor,
      };

  DayType get next => DayType.values[(index + 1) % DayType.values.length];

  static DayType fromName(String? name) => DayType.values.firstWhere(
        (e) => e.name == name,
        orElse: () => DayType.office,
      );
}

typedef WeeklySchedule = Map<int, DayType>;

const WeeklySchedule kDefaultSchedule = {
  0: DayType.office,
  1: DayType.office,
  2: DayType.office,
  3: DayType.home,
  4: DayType.home,
  5: DayType.off,
  6: DayType.off,
};

WeeklySchedule scheduleFromJson(dynamic days) {
  final schedule = Map<int, DayType>.of(kDefaultSchedule);
  for (final day in JsonReader.list(days)) {
    schedule[JsonReader.toInt(day['weekday'])] =
        DayType.fromName(EnumValue.keyOf(day['type']));
  }
  return schedule;
}

List<Map<String, dynamic>> scheduleToJson(WeeklySchedule schedule) => [
      for (var i = 0; i < 7; i++)
        {'weekday': i, 'type': (schedule[i] ?? DayType.off).name},
    ];
