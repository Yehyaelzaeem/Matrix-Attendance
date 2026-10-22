import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/status_chip.dart';

enum AttendancePhase {
  idle,
  working,
  paused,
  done;

  static AttendancePhase fromKey(String? key) => switch (key) {
        'in' => AttendancePhase.working,
        'paused' => AttendancePhase.paused,
        'closed' || 'auto_closed' => AttendancePhase.done,
        _ => AttendancePhase.idle,
      };
}

enum ArrivalStatus {
  onTime(ChipTone.green),
  lateGrace(ChipTone.yellow),
  lateViolation(ChipTone.red),
  permitted(ChipTone.blue);

  const ArrivalStatus(this.tone);

  final ChipTone tone;

  String label(int lateMinutes) => switch (this) {
        ArrivalStatus.onTime => LocaleKeys.attendance_onTime.tr(),
        ArrivalStatus.lateGrace =>
          LocaleKeys.attendance_lateGrace.tr(namedArgs: {'n': '$lateMinutes'}),
        ArrivalStatus.lateViolation => LocaleKeys.attendance_lateViolation.tr(),
        ArrivalStatus.permitted => LocaleKeys.attendance_latePermitted
            .tr(namedArgs: {'n': '$lateMinutes'}),
      };

  static ArrivalStatus fromKey(String? key) => switch (key) {
        'grace' => ArrivalStatus.lateGrace,
        'after_1030' => ArrivalStatus.lateViolation,
        'permitted' => ArrivalStatus.permitted,
        _ => ArrivalStatus.onTime,
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

  static PauseReason fromKey(String? key) => PauseReason.values.firstWhere(
        (e) => e.name == key,
        orElse: () => PauseReason.other,
      );
}
