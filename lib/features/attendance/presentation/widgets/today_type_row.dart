import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/models/day_type.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/emoji_box.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../data/models/attendance_day.dart';
import '../../data/models/attendance_enums.dart';

class TodayTypeRow extends StatelessWidget {
  const TodayTypeRow({super.key, required this.day});

  final AttendanceDay day;

  static String placeLabel(DayType type) => switch (type) {
        DayType.office => LocaleKeys.attendance_fromOffice.tr(),
        DayType.home => LocaleKeys.attendance_fromHome.tr(),
        DayType.off => LocaleKeys.attendance_restDay.tr(),
      };

  (String, ChipTone) get _chip => switch (day.phase) {
        AttendancePhase.idle => (
            LocaleKeys.attendance_notCheckedIn.tr(),
            ChipTone.gray
          ),
        AttendancePhase.working => day.location == DayType.home
            ? (LocaleKeys.attendance_atHome.tr(), ChipTone.violet)
            : (LocaleKeys.attendance_atOffice.tr(), ChipTone.blue),
        AttendancePhase.paused => (
            LocaleKeys.attendance_pausedChip.tr(),
            ChipTone.orange
          ),
        AttendancePhase.done => (
            LocaleKeys.attendance_checkedOutChip.tr(),
            ChipTone.green
          ),
      };

  @override
  Widget build(BuildContext context) {
    final type = day.expected;
    final chip = _chip;
    return Row(
      children: [
        EmojiBox(emoji: type.emoji, background: type.softColor, fontSize: 21),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                LocaleKeys.attendance_todayFrom
                    .tr(namedArgs: {'place': placeLabel(type)}),
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                maxLines: 1,
              ),
              AppText(
                LocaleKeys.attendance_hoursRange.tr(namedArgs: {
                  'n':
                      '${day.requiredHours > 0 ? day.requiredHours : type.requiredHours}',
                  'range': type.range,
                }),
                fontSize: 12.5,
                maxLines: 1,
                color: AppColors.textSecondaryColor.themeColor,
              ),
            ],
          ),
        ),
        StatusChip(label: chip.$1, tone: chip.$2),
      ],
    );
  }
}
