import 'package:equatable/equatable.dart';

import '../../../../core/models/day_type.dart';
import 'attendance_day.dart';
import 'month_summary.dart';

class AttendanceOverview extends Equatable {
  const AttendanceOverview({
    required this.day,
    required this.schedule,
    required this.month,
    this.lastCheckIn = '10:30',
  });

  final AttendanceDay day;
  final WeeklySchedule schedule;
  final MonthSummary month;
  final String lastCheckIn;

  AttendanceOverview copyWith({AttendanceDay? day}) => AttendanceOverview(
        day: day ?? this.day,
        schedule: schedule,
        month: month,
        lastCheckIn: lastCheckIn,
      );

  @override
  List<Object?> get props => [day, schedule, month, lastCheckIn];
}
