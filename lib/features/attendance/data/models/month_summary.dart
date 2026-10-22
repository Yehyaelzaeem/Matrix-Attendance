import 'package:equatable/equatable.dart';

import '../../../../core/utils/json_reader.dart';

class MonthSummary extends Equatable {
  const MonthSummary({
    required this.presentDays,
    required this.workDays,
    required this.totalHours,
    required this.totalDuration,
    required this.lateCount,
    required this.lateMinutes,
    required this.deficitDays,
    required this.deficitMinutes,
    required this.violations,
    required this.leaves,
    required this.commitment,
  });

  final int presentDays;
  final int workDays;
  final int totalHours;
  final String totalDuration;
  final int lateCount;
  final int lateMinutes;
  final int deficitDays;
  final int deficitMinutes;
  final int violations;
  final int leaves;
  final int commitment;

  factory MonthSummary.fromJson(Map<String, dynamic> json) {
    final days = JsonReader.map(json['attendance_days']);
    final lateness = JsonReader.map(json['lateness']);
    final deficit = JsonReader.map(json['deficit']);
    final worked = JsonReader.toInt(json['total_worked_seconds']);
    return MonthSummary(
      presentDays: JsonReader.toInt(days['present']),
      workDays: JsonReader.toInt(days['required']),
      totalHours: worked ~/ 3600,
      totalDuration: JsonReader.string(json['total_worked'], '0:00:00'),
      lateCount: JsonReader.toInt(lateness['count']),
      lateMinutes: JsonReader.toInt(lateness['total_minutes']),
      deficitDays: JsonReader.toInt(deficit['days']),
      deficitMinutes: JsonReader.intOrNull(deficit['total_minutes']) ??
          JsonReader.toInt(deficit['total_seconds']) ~/ 60,
      violations: JsonReader.toInt(JsonReader.map(json['violations'])['count']),
      leaves: JsonReader.toInt(json['leaves_and_permissions']),
      commitment: JsonReader.toInt(json['commitment']),
    );
  }

  @override
  List<Object?> get props => [
        presentDays,
        workDays,
        totalHours,
        totalDuration,
        lateCount,
        lateMinutes,
        deficitDays,
        deficitMinutes,
        violations,
        leaves,
        commitment,
      ];
}
