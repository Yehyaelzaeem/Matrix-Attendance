import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/attendance_enums.dart';
import 'shine_overlay.dart';

class AttendanceActions extends StatelessWidget {
  const AttendanceActions({
    super.key,
    required this.phase,
    required this.onMain,
    required this.onPause,
  });

  final AttendancePhase phase;
  final VoidCallback onMain;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    final showPause =
        phase == AttendancePhase.working || phase == AttendancePhase.paused;
    final paused = phase == AttendancePhase.paused;

    final (
      String title,
      IconData icon,
      Gradient? gradient,
      ButtonStyleType type
    ) = switch (phase) {
      AttendancePhase.idle => (
          LocaleKeys.attendance_checkIn.tr(),
          Icons.login_rounded,
          AppColors.primaryGradient,
          ButtonStyleType.primary
        ),
      AttendancePhase.working => (
          LocaleKeys.attendance_checkOut.tr(),
          Icons.logout_rounded,
          AppColors.dangerGradient,
          ButtonStyleType.primary
        ),
      AttendancePhase.paused => (
          LocaleKeys.attendance_resume.tr(),
          Icons.play_arrow_rounded,
          AppColors.successGradient,
          ButtonStyleType.primary
        ),
      AttendancePhase.done => (
          LocaleKeys.attendance_dayClosed.tr(),
          Icons.check_circle_outline_rounded,
          null,
          ButtonStyleType.ghost
        ),
    };

    return Row(
      children: [
        if (showPause) ...[
          CustomButton(
            width: 104.w,
            height: 62,
            radius: 20,
            withShadow: false,
            color: paused
                ? AppColors.errorSoftColor.themeColor
                : AppColors.warningSoftColor.themeColor,
            onTap: onPause,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(paused ? AppEmojis.stop : AppEmojis.pause,
                    style: TextStyle(fontSize: 15.sp)),
                SizedBox(width: 6.w),
                AppText(
                  paused
                      ? LocaleKeys.attendance_leaveNow.tr()
                      : LocaleKeys.attendance_pause.tr(),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: paused
                      ? AppColors.errorColor.themeColor
                      : AppColors.warningTextColor.themeColor,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
        ],
        Expanded(
          child: ShineOverlay(
            enabled: gradient != null,
            radius: 20,
            child: CustomButton(
              height: 62,
              radius: 20,
              fontSize: 17,
              gradient: gradient,
              type: type,
              icon: Icon(icon),
              title: title,
              onTap: onMain,
            ),
          ),
        ),
      ],
    );
  }
}
