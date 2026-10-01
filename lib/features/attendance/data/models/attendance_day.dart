import 'package:equatable/equatable.dart';

import '../../../../core/models/day_type.dart';
import 'attendance_enums.dart';

class PauseEntry extends Equatable {
  const PauseEntry({
    required this.start,
    required this.reason,
    this.end,
    this.note = '',
  });

  final DateTime start;
  final DateTime? end;
  final PauseReason reason;
  final String note;

  PauseEntry close(DateTime at) =>
      PauseEntry(start: start, end: at, reason: reason, note: note);

  double seconds(DateTime until) =>
      (end ?? until).difference(start).inMilliseconds / 1000;

  @override
  List<Object?> get props => [start, end, reason, note];
}

class AttendanceDay extends Equatable {
  const AttendanceDay({
    required this.expected,
    this.phase = AttendancePhase.idle,
    this.checkIn,
    this.checkOut,
    this.location,
    this.requiredHours = 0,
    this.pauses = const [],
    this.arrival = ArrivalStatus.onTime,
    this.lateMinutes = 0,
    this.mismatch = false,
  });

  final DayType expected;
  final AttendancePhase phase;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final DayType? location;
  final int requiredHours;
  final List<PauseEntry> pauses;
  final ArrivalStatus arrival;
  final int lateMinutes;
  final bool mismatch;

  PauseEntry? get activePause =>
      pauses.isNotEmpty && pauses.last.end == null ? pauses.last : null;

  int get requiredSeconds => requiredHours * 3600;

  double pausedSeconds(DateTime until) =>
      pauses.fold(0, (sum, p) => sum + p.seconds(until));

  double workedSeconds(DateTime until) {
    if (checkIn == null) return 0;
    final end = checkOut ?? until;
    return end.difference(checkIn!).inMilliseconds / 1000 - pausedSeconds(end);
  }

  DateTime? expectedCheckout(DateTime until) => checkIn?.add(Duration(
      seconds: (requiredSeconds + pausedSeconds(checkOut ?? until)).round()));

  AttendanceDay copyWith({
    AttendancePhase? phase,
    DateTime? checkIn,
    DateTime? checkOut,
    DayType? location,
    int? requiredHours,
    List<PauseEntry>? pauses,
    ArrivalStatus? arrival,
    int? lateMinutes,
    bool? mismatch,
  }) =>
      AttendanceDay(
        expected: expected,
        phase: phase ?? this.phase,
        checkIn: checkIn ?? this.checkIn,
        checkOut: checkOut ?? this.checkOut,
        location: location ?? this.location,
        requiredHours: requiredHours ?? this.requiredHours,
        pauses: pauses ?? this.pauses,
        arrival: arrival ?? this.arrival,
        lateMinutes: lateMinutes ?? this.lateMinutes,
        mismatch: mismatch ?? this.mismatch,
      );

  @override
  List<Object?> get props => [
        expected,
        phase,
        checkIn,
        checkOut,
        location,
        requiredHours,
        pauses,
        arrival,
        lateMinutes,
        mismatch,
      ];
}
