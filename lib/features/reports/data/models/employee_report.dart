import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/locale_keys.dart';
import '../../../tasks/data/models/task_kpi.dart';

enum ReportMode { attendance, kpi, overall }

extension ReportModeLabel on ReportMode {
  String get tab => switch (this) {
        ReportMode.attendance => LocaleKeys.reports_modeAttendance.tr(),
        ReportMode.kpi => LocaleKeys.reports_modeKpi.tr(),
        ReportMode.overall => LocaleKeys.reports_modeOverall.tr(),
      };

  String get unit => switch (this) {
        ReportMode.attendance => LocaleKeys.reports_unitAttendance.tr(),
        ReportMode.kpi => LocaleKeys.reports_unitKpi.tr(),
        ReportMode.overall => LocaleKeys.reports_unitOverall.tr(),
      };
}

class EmployeeReport extends Equatable {
  const EmployeeReport({
    required this.name,
    required this.jobTitle,
    required this.days,
    required this.workDays,
    required this.hours,
    required this.lateCount,
    required this.lateMinutes,
    required this.deficitDays,
    required this.deficitMinutes,
    required this.locationViolations,
    required this.lateViolations,
    required this.absences,
    required this.leaves,
    required this.pauses,
    required this.pauseMinutes,
  });

  final String name;
  final String jobTitle;
  final int days;
  final int workDays;
  final double hours;
  final int lateCount;
  final int lateMinutes;
  final int deficitDays;
  final int deficitMinutes;
  final int locationViolations;
  final int lateViolations;
  final int absences;
  final int leaves;
  final int pauses;
  final int pauseMinutes;

  int get violations => locationViolations + lateViolations;

  int get attendanceScore => max(
      40,
      (100 -
              lateCount * 1.2 -
              lateMinutes / 20 -
              deficitDays * 2 -
              locationViolations * 5 -
              lateViolations * 4 -
              absences * 8)
          .round());

  int value(ReportMode mode, TaskKpi kpi) => switch (mode) {
        ReportMode.attendance => attendanceScore,
        ReportMode.kpi => kpi.score ?? 0,
        ReportMode.overall => kpi.score == null
            ? attendanceScore
            : ((attendanceScore + kpi.score!) / 2).round(),
      };

  @override
  List<Object?> get props => [name, days, hours, lateCount, lateMinutes];
}
