import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/attendance_day.dart';

class PauseLine extends StatelessWidget {
  const PauseLine({super.key, required this.day, required this.now});

  final AttendanceDay day;
  final DateTime now;

  static String countLabel(int n) =>
      '$n ${n > 1 ? LocaleKeys.common_times.tr() : LocaleKeys.common_once.tr()}';

  @override
  Widget build(BuildContext context) {
    final color = AppColors.orangeDeepColor.themeColor;
    final parts = [
      LocaleKeys.attendance_pauseToday.tr(),
      countLabel(day.pauses.length),
      if (day.activePause != null) LocaleKeys.attendance_pauseRunning.tr(),
    ];
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.orangeSoftColor.themeColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppText(parts.join(' · '),
                fontSize: 12.5, fontWeight: FontWeight.w700, color: color),
          ),
          AppText(DateHelper.hms(day.pausedSeconds(now)),
              numeric: true,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: color),
        ],
      ),
    );
  }
}
