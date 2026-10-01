import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/models/day_type.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/status_chip.dart';

enum BoardStatus {
  present(ChipTone.green),
  paused(ChipTone.orange),
  late(ChipTone.yellow),
  absent(ChipTone.red),
  out(ChipTone.gray),
  leave(ChipTone.violet);

  const BoardStatus(this.tone);

  final ChipTone tone;

  String get label => switch (this) {
        BoardStatus.present => LocaleKeys.board_statusPresent.tr(),
        BoardStatus.paused => LocaleKeys.board_statusPaused.tr(),
        BoardStatus.late => LocaleKeys.board_statusLate.tr(),
        BoardStatus.absent => LocaleKeys.board_statusAbsent.tr(),
        BoardStatus.out => LocaleKeys.board_statusOut.tr(),
        BoardStatus.leave => LocaleKeys.board_statusLeave.tr(),
      };

  bool get isAtWork =>
      this == BoardStatus.present ||
      this == BoardStatus.late ||
      this == BoardStatus.out ||
      this == BoardStatus.paused;
}

class BoardEntry extends Equatable {
  const BoardEntry({
    required this.name,
    required this.jobTitle,
    required this.status,
    this.location,
    this.checkIn,
    this.checkOut,
    this.note,
    this.isLate = false,
  });

  final String name;
  final String jobTitle;
  final BoardStatus status;
  final DayType? location;
  final String? checkIn;
  final String? checkOut;
  final String? note;
  final bool isLate;

  @override
  List<Object?> get props =>
      [name, jobTitle, status, location, checkIn, checkOut, note, isLate];
}

class BoardDay extends Equatable {
  const BoardDay({required this.daysAgo, required this.entries});

  final int daysAgo;
  final List<BoardEntry> entries;

  int count(BoardStatus status) =>
      entries.where((e) => e.status == status).length;

  int atLocation(DayType type) =>
      entries.where((e) => e.status.isAtWork && e.location == type).length;

  int get lateCount => daysAgo == 0
      ? count(BoardStatus.late)
      : entries.where((e) => e.isLate).length;

  @override
  List<Object?> get props => [daysAgo, entries];
}
