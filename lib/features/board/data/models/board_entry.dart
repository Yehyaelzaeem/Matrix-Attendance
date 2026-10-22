import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/models/day_type.dart';
import '../../../../core/models/enum_value.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/json_reader.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../attendance/data/models/attendance_enums.dart';

enum BoardStatus {
  present(ChipTone.green, 'in'),
  paused(ChipTone.orange, 'paused'),
  late(ChipTone.yellow, 'late'),
  absent(ChipTone.red, 'absent'),
  out(ChipTone.gray, 'out'),
  leave(ChipTone.violet, 'leave');

  const BoardStatus(this.tone, this.key);

  final ChipTone tone;
  final String key;

  String get label => switch (this) {
        BoardStatus.present => LocaleKeys.board_statusPresent.tr(),
        BoardStatus.paused => LocaleKeys.board_statusPaused.tr(),
        BoardStatus.late => LocaleKeys.board_statusLate.tr(),
        BoardStatus.absent => LocaleKeys.board_statusAbsent.tr(),
        BoardStatus.out => LocaleKeys.board_statusOut.tr(),
        BoardStatus.leave => LocaleKeys.board_statusLeave.tr(),
      };

  static BoardStatus fromKey(String? key) => BoardStatus.values.firstWhere(
        (e) => e.key == key,
        orElse: () => BoardStatus.absent,
      );
}

class BoardEntry extends Equatable {
  const BoardEntry({
    required this.userId,
    required this.name,
    required this.jobTitle,
    required this.status,
    this.image,
    this.location,
    this.checkIn,
    this.checkOut,
    this.note,
    this.isLate = false,
  });

  final int userId;
  final String name;
  final String jobTitle;
  final String? image;
  final BoardStatus status;
  final DayType? location;
  final String? checkIn;
  final String? checkOut;
  final String? note;
  final bool isLate;

  factory BoardEntry.fromJson(Map<String, dynamic> json) {
    final user = JsonReader.map(json['user']);
    final status = BoardStatus.fromKey(EnumValue.keyOf(json['status']));
    final checkIn = JsonReader.dateTime(json['check_in_at']);
    final checkOut = JsonReader.dateTime(json['check_out_at']);
    final location = JsonReader.stringOrNull(json['actual_location']) ??
        JsonReader.stringOrNull(json['schedule_type']);
    final lateClass = JsonReader.stringOrNull(json['late_class']);
    final lateMinutes = JsonReader.toInt(json['late_minutes']);
    final isLate = lateClass != null && lateClass != 'on_time';
    return BoardEntry(
      userId: JsonReader.toInt(user['id']),
      name: JsonReader.string(user['name']),
      jobTitle: JsonReader.string(user['job_name']),
      image: JsonReader.stringOrNull(user['image']),
      status: status,
      location: location == null || location == 'off'
          ? null
          : DayType.fromName(location),
      checkIn: checkIn == null ? null : DateHelper.timeShort(checkIn),
      checkOut: checkOut == null ? null : DateHelper.timeShort(checkOut),
      isLate: isLate,
      note: _note(
        status: status,
        lateClass: lateClass,
        lateMinutes: lateMinutes,
        worked: JsonReader.toInt(json['worked_seconds']),
        deficit: JsonReader.toInt(json['deficit_seconds']),
        pause: JsonReader.mapOrNull(json['pause']),
      ),
    );
  }

  static String? _note({
    required BoardStatus status,
    required String? lateClass,
    required int lateMinutes,
    required int worked,
    required int deficit,
    required Map<String, dynamic>? pause,
  }) {
    final late = {'n': '$lateMinutes'};
    switch (status) {
      case BoardStatus.paused:
        if (pause == null) return null;
        final reason = PauseReason.fromKey(EnumValue.keyOf(pause['reason']));
        final since = JsonReader.dateTime(pause['started_at']);
        final minutes =
            since == null ? 0 : DateTime.now().difference(since).inMinutes;
        return LocaleKeys.board_notePaused
            .tr(namedArgs: {'reason': reason.label, 'n': '$minutes'});
      case BoardStatus.late:
        return lateClass == 'permitted'
            ? LocaleKeys.board_noteLatePermitted.tr(namedArgs: late)
            : LocaleKeys.board_noteLate.tr(namedArgs: late);
      case BoardStatus.out:
        if (deficit > 0) {
          return LocaleKeys.board_noteDeficit
              .tr(namedArgs: {'n': '${deficit ~/ 60}'});
        }
        if (lateMinutes > 0 && lateClass != null && lateClass != 'on_time') {
          return LocaleKeys.board_noteLate.tr(namedArgs: late);
        }
        return LocaleKeys.board_noteWorked.tr(namedArgs: {
          'h': '${worked ~/ 3600}:${DateHelper.twoDigits(worked % 3600 ~/ 60)}'
        });
      case BoardStatus.present:
      case BoardStatus.absent:
      case BoardStatus.leave:
        return null;
    }
  }

  @override
  List<Object?> get props => [
        userId,
        name,
        jobTitle,
        image,
        status,
        location,
        checkIn,
        checkOut,
        note,
        isLate
      ];
}

class BoardSummary extends Equatable {
  const BoardSummary({
    this.total = 0,
    this.office = 0,
    this.home = 0,
    this.present = 0,
    this.late = 0,
    this.paused = 0,
    this.absent = 0,
    this.out = 0,
    this.leave = 0,
  });

  final int total;
  final int office;
  final int home;
  final int present;
  final int late;
  final int paused;
  final int absent;
  final int out;
  final int leave;

  factory BoardSummary.fromJson(dynamic json) {
    final map = JsonReader.map(json);
    return BoardSummary(
      total: JsonReader.toInt(map['total']),
      office: JsonReader.toInt(map['office']),
      home: JsonReader.toInt(map['home']),
      present: JsonReader.toInt(map['in']),
      late: JsonReader.toInt(map['late']),
      paused: JsonReader.toInt(map['paused']),
      absent: JsonReader.toInt(map['absent']),
      out: JsonReader.toInt(map['out']),
      leave: JsonReader.toInt(map['leave']),
    );
  }

  int count(BoardStatus status) => switch (status) {
        BoardStatus.present => present,
        BoardStatus.paused => paused,
        BoardStatus.late => late,
        BoardStatus.absent => absent,
        BoardStatus.out => out,
        BoardStatus.leave => leave,
      };

  int atLocation(DayType type) => switch (type) {
        DayType.office => office,
        DayType.home => home,
        DayType.off => 0,
      };

  @override
  List<Object?> get props =>
      [total, office, home, present, late, paused, absent, out, leave];
}

class BoardDay extends Equatable {
  const BoardDay({
    required this.date,
    required this.entries,
    required this.summary,
    this.isHoliday = false,
  });

  final DateTime date;
  final List<BoardEntry> entries;
  final BoardSummary summary;
  final bool isHoliday;

  factory BoardDay.fromJson(Map<String, dynamic> json) => BoardDay(
        date: JsonReader.date(json['date']) ?? DateHelper.today(),
        entries:
            JsonReader.list(json['people']).map(BoardEntry.fromJson).toList(),
        summary: BoardSummary.fromJson(json['summary']),
        isHoliday: JsonReader.toBool(json['is_holiday']),
      );

  int get daysAgo => DateHelper.today().difference(date).inDays;

  int count(BoardStatus status) => summary.count(status);

  @override
  List<Object?> get props => [date, entries, summary, isHoliday];
}
