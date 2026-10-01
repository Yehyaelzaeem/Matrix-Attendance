import 'package:easy_localization/easy_localization.dart';

import '../../../../core/models/day_type.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../data/models/attendance_day.dart';
import '../../data/models/attendance_enums.dart';

class WhatsappMessages {
  WhatsappMessages._();

  static String place(DayType? type) => type == DayType.home
      ? LocaleKeys.attendance_placeHome.tr()
      : LocaleKeys.attendance_placeOffice.tr();

  static String checkIn(String name, AttendanceDay day) {
    final late = day.lateMinutes > 0 && day.arrival != ArrivalStatus.onTime;
    return LocaleKeys.attendance_waCheckIn.tr(namedArgs: {
      'icon': late ? AppEmojis.yellowDot : AppEmojis.checkBox,
      'name': name,
      'place': place(day.location),
      'time': DateHelper.time12(day.checkIn!),
      'late': late
          ? LocaleKeys.attendance_waLate
              .tr(namedArgs: {'n': '${day.lateMinutes}'})
          : '',
    });
  }

  static String pause(String name, PauseEntry pause) {
    final reason = '${pause.reason.emoji} ${pause.reason.label}'
        '${pause.note.isNotEmpty ? ' (${pause.note})' : ''}';
    return LocaleKeys.attendance_waPause.tr(namedArgs: {
      'name': name,
      'time': DateHelper.time12(pause.start),
      'reason': reason,
    });
  }

  static String resume(String name, PauseEntry pause) =>
      LocaleKeys.attendance_waResume.tr(namedArgs: {
        'name': name,
        'time': DateHelper.time12(pause.end!),
        'duration': DateHelper.hms(pause.seconds(pause.end!)),
        'reason': pause.reason.label,
      });

  static String checkOut(String name, AttendanceDay day) {
    final out = day.checkOut!;
    final paused = day.pausedSeconds(out);
    return LocaleKeys.attendance_waCheckOut.tr(namedArgs: {
      'name': name,
      'time': DateHelper.time12(out),
      'worked': DateHelper.hms(day.workedSeconds(out)),
      'pause': paused > 0
          ? LocaleKeys.attendance_waPausePart
              .tr(namedArgs: {'duration': DateHelper.hms(paused)})
          : '',
    });
  }
}
