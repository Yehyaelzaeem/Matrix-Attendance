import 'package:equatable/equatable.dart';

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
