import 'package:easy_localization/easy_localization.dart';

import 'locale_keys.dart';

class DateHelper {
  DateHelper._();

  static const List<String> _dayKeys = [
    LocaleKeys.days_sun,
    LocaleKeys.days_mon,
    LocaleKeys.days_tue,
    LocaleKeys.days_wed,
    LocaleKeys.days_thu,
    LocaleKeys.days_fri,
    LocaleKeys.days_sat,
  ];

  static const List<String> _shortDayKeys = [
    LocaleKeys.daysShort_sun,
    LocaleKeys.daysShort_mon,
    LocaleKeys.daysShort_tue,
    LocaleKeys.daysShort_wed,
    LocaleKeys.daysShort_thu,
    LocaleKeys.daysShort_fri,
    LocaleKeys.daysShort_sat,
  ];

  static const List<String> _monthKeys = [
    LocaleKeys.months_m1,
    LocaleKeys.months_m2,
    LocaleKeys.months_m3,
    LocaleKeys.months_m4,
    LocaleKeys.months_m5,
    LocaleKeys.months_m6,
    LocaleKeys.months_m7,
    LocaleKeys.months_m8,
    LocaleKeys.months_m9,
    LocaleKeys.months_m10,
    LocaleKeys.months_m11,
    LocaleKeys.months_m12,
  ];

  static const List<int> weekDays = [0, 1, 2, 3, 4, 5, 6];

  static int weekIndex(DateTime date) => date.weekday % 7;

  static String dayName(int weekIndex) => _dayKeys[weekIndex].tr();

  static String shortDayName(int weekIndex) => _shortDayKeys[weekIndex].tr();

  static String monthName(int month) => _monthKeys[month - 1].tr();

  static String twoDigits(int n) => n.toString().padLeft(2, '0');

  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime today() => dateOnly(DateTime.now());

  static DateTime fromToday(int days) => today().add(Duration(days: days));

  static int dayDiff(DateTime date) =>
      dateOnly(date).difference(today()).inDays;

  static String time12(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final period =
        date.hour >= 12 ? LocaleKeys.common_pm.tr() : LocaleKeys.common_am.tr();
    return '$hour:${twoDigits(date.minute)} $period';
  }

  static String timeShort(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    return '$hour:${twoDigits(date.minute)}';
  }

  static String hms(num seconds) {
    final s = seconds < 0 ? 0 : seconds.floor();
    return '${twoDigits(s ~/ 3600)}:${twoDigits(s % 3600 ~/ 60)}:${twoDigits(s % 60)}';
  }

  static String hoursAsClock(double hours) {
    final whole = hours.floor();
    final minutes = ((hours - whole) * 60).round();
    return '$whole:${twoDigits(minutes)}:00';
  }

  static String dayMonth(DateTime date) =>
      '${date.day} ${monthName(date.month)}';

  static String fullDate(DateTime date) =>
      '${dayName(weekIndex(date))}${LocaleKeys.common_dateSeparator.tr()} ${date.day} ${monthName(date.month)} ${date.year}';

  static String iso(DateTime date) =>
      '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}';

  static String time24(DateTime date) =>
      '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
}
