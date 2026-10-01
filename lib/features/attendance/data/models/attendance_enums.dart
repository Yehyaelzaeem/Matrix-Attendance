import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/status_chip.dart';

enum AttendancePhase { idle, working, paused, done }

enum ArrivalStatus {
  onTime(ChipTone.green),
  lateGrace(ChipTone.yellow),
  lateViolation(ChipTone.red);

  const ArrivalStatus(this.tone);

  final ChipTone tone;

  String label(int lateMinutes) => switch (this) {
        ArrivalStatus.onTime => LocaleKeys.attendance_onTime.tr(),
        ArrivalStatus.lateGrace =>
          LocaleKeys.attendance_lateGrace.tr(namedArgs: {'n': '$lateMinutes'}),
        ArrivalStatus.lateViolation => LocaleKeys.attendance_lateViolation.tr(),
      };
}

enum PauseReason {
  power(AppEmojis.bolt),
  net(AppEmojis.signal),
  urgent(AppEmojis.siren),
  errand(AppEmojis.car),
  other(AppEmojis.pencil);

  const PauseReason(this.emoji);

  final String emoji;

  String get label => switch (this) {
        PauseReason.power => LocaleKeys.attendance_pausePower.tr(),
        PauseReason.net => LocaleKeys.attendance_pauseNet.tr(),
        PauseReason.urgent => LocaleKeys.attendance_pauseUrgent.tr(),
        PauseReason.errand => LocaleKeys.attendance_pauseErrand.tr(),
        PauseReason.other => LocaleKeys.attendance_pauseOther.tr(),
      };

  bool get requiresNote => this == PauseReason.other;
}
