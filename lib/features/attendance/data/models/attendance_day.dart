import 'package:equatable/equatable.dart';

import '../../../../core/models/day_type.dart';
import '../../../../core/models/enum_value.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/json_reader.dart';
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

  factory PauseEntry.fromJson(Map<String, dynamic> json) => PauseEntry(
        start: JsonReader.dateTime(json['started_at']) ?? DateTime.now(),
        end: JsonReader.dateTime(json['ended_at']),
        reason: PauseReason.fromKey(EnumValue.keyOf(json['reason'])),
        note: JsonReader.string(json['note']),
      );

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
    this.expectedOut,
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
  final DateTime? expectedOut;

  factory AttendanceDay.fromJson(Map<String, dynamic> json) {
    final checkIn = JsonReader.dateTime(json['check_in_at']);
    final pauses =
        JsonReader.list(json['pauses']).map(PauseEntry.fromJson).toList();
    final open = JsonReader.mapOrNull(json['pause']);
    if (open != null && pauses.every((p) => p.end != null)) {
      pauses.add(PauseEntry.fromJson(open));
    }
    final location = JsonReader.stringOrNull(json['actual_location']);
    return AttendanceDay(
      expected:
          DayType.fromName(JsonReader.stringOrNull(json['schedule_type'])),
      phase: AttendancePhase.fromKey(JsonReader.stringOrNull(json['state'])),
      checkIn: checkIn,
      checkOut: JsonReader.dateTime(json['check_out_at']),
      location: location == null ? null : DayType.fromName(location),
      requiredHours: JsonReader.toInt(json['required_hours']),
      pauses: pauses,
      arrival:
          ArrivalStatus.fromKey(JsonReader.stringOrNull(json['late_class'])),
      lateMinutes:
          JsonReader.intOrNull(json['late_minutes']) ?? _lateMinutesOf(checkIn),
      mismatch: JsonReader.toBool(json['location_violation']),
      expectedOut: JsonReader.dateTime(json['expected_check_out_at']),
    );
  }

  static int _lateMinutesOf(DateTime? checkIn) {
    if (checkIn == null) return 0;
    final start = DateTime(
        checkIn.year, checkIn.month, checkIn.day, AppConstants.officeStartHour);
    return checkIn.isAfter(start) ? checkIn.difference(start).inMinutes : 0;
  }

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

  DateTime? expectedCheckout(DateTime until) {
    if (checkIn == null) return expectedOut;
    return checkIn!.add(Duration(
        seconds: (requiredSeconds + pausedSeconds(checkOut ?? until)).round()));
  }

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
        expectedOut,
      ];
}
