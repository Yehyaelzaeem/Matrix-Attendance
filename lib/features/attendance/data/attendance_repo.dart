import '../../../core/models/day_type.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/date_helper.dart';
import 'models/attendance_day.dart';
import 'models/attendance_enums.dart';
import 'models/attendance_overview.dart';
import 'models/month_summary.dart';

class AttendanceRepo {
  final WeeklySchedule _schedule = Map.of(kDefaultSchedule);
  late AttendanceDay _today = AttendanceDay(expected: _expectedToday());

  static const MonthSummary _month = MonthSummary(
    presentDays: 18,
    workDays: 20,
    totalHours: 152,
    totalDuration: '152:40:12',
    lateCount: 3,
    lateMinutes: 47,
    deficitDays: 1,
    deficitMinutes: 19,
    violations: 0,
    leaves: 2,
    commitment: 94,
  );

  DayType _expectedToday() {
    final type =
        _schedule[DateHelper.weekIndex(DateTime.now())] ?? DayType.office;
    return type == DayType.off ? DayType.office : type;
  }

  Future<AttendanceOverview> getOverview() async {
    await Future.delayed(AppConstants.mockLatency);
    return AttendanceOverview(day: _today, schedule: _schedule, month: _month);
  }

  Future<AttendanceDay> checkIn(DayType location) async {
    await Future.delayed(AppConstants.mockLatency);
    final now = DateTime.now();
    final start =
        DateTime(now.year, now.month, now.day, AppConstants.officeStartHour);
    final latest = DateTime(now.year, now.month, now.day,
        AppConstants.latestArrivalHour, AppConstants.latestArrivalMinute);
    final lateMinutes =
        now.isAfter(start) ? now.difference(start).inMinutes : 0;
    final arrival = lateMinutes == 0
        ? ArrivalStatus.onTime
        : now.isBefore(latest)
            ? ArrivalStatus.lateGrace
            : ArrivalStatus.lateViolation;
    final required =
        _today.expected == DayType.home || location == DayType.home ? 10 : 8;
    _today = _today.copyWith(
      phase: AttendancePhase.working,
      checkIn: now,
      location: location,
      requiredHours: required,
      arrival: arrival,
      lateMinutes: lateMinutes,
      mismatch: _today.expected == DayType.office && location == DayType.home,
    );
    return _today;
  }

  Future<AttendanceDay> pause(PauseReason reason, String note) async {
    await Future.delayed(AppConstants.mockLatency);
    _today = _today.copyWith(
      phase: AttendancePhase.paused,
      pauses: [
        ..._today.pauses,
        PauseEntry(start: DateTime.now(), reason: reason, note: note),
      ],
    );
    return _today;
  }

  Future<AttendanceDay> resume() async {
    await Future.delayed(AppConstants.mockLatency);
    _today = _today.copyWith(
      phase: AttendancePhase.working,
      pauses: _closeActivePause(DateTime.now()),
    );
    return _today;
  }

  Future<AttendanceDay> checkOut() async {
    await Future.delayed(AppConstants.mockLatency);
    final now = DateTime.now();
    _today = _today.copyWith(
      phase: AttendancePhase.done,
      checkOut: now,
      pauses: _closeActivePause(now),
    );
    return _today;
  }

  void reset() => _today = AttendanceDay(expected: _expectedToday());

  List<PauseEntry> _closeActivePause(DateTime at) => [
        for (final p in _today.pauses) p.end == null ? p.close(at) : p,
      ];
}
