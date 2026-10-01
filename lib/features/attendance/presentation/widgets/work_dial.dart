import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/attendance_day.dart';
import '../../data/models/attendance_enums.dart';

class WorkDial extends StatelessWidget {
  const WorkDial({super.key, required this.day, required this.now});

  final AttendanceDay day;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final phase = day.phase;
    final worked = day.workedSeconds(now);
    final left = day.requiredSeconds - worked;
    final progress = day.requiredSeconds == 0
        ? 0.0
        : (worked / day.requiredSeconds).clamp(0.0, 1.0);
    final paused = phase == AttendancePhase.paused;

    final String label = switch (phase) {
      AttendancePhase.idle => LocaleKeys.attendance_workHours.tr(),
      AttendancePhase.working => LocaleKeys.attendance_worked.tr(),
      AttendancePhase.paused => LocaleKeys.attendance_pausedLabel
          .tr(namedArgs: {'reason': day.activePause?.reason.label ?? ''}),
      AttendancePhase.done => LocaleKeys.attendance_todayTotal.tr(),
    };

    final (String remain, Color? remainColor) = switch (phase) {
      AttendancePhase.idle => (
          LocaleKeys.attendance_requiredHours
              .tr(namedArgs: {'n': '${day.expected.requiredHours}'}),
          null
        ),
      AttendancePhase.paused => (
          LocaleKeys.attendance_pausedSince.tr(namedArgs: {
            'time': DateHelper.hms(day.activePause?.seconds(now) ?? 0),
          }),
          AppColors.orangeTextColor.themeColor
        ),
      AttendancePhase.working => left > 0
          ? (
              LocaleKeys.attendance_remaining
                  .tr(namedArgs: {'time': DateHelper.hms(left)}),
              null
            )
          : (
              LocaleKeys.attendance_overtime
                  .tr(namedArgs: {'time': DateHelper.hms(-left)}),
              AppColors.successColor.themeColor
            ),
      AttendancePhase.done => left > 0
          ? (
              LocaleKeys.attendance_short
                  .tr(namedArgs: {'time': DateHelper.hms(left)}),
              AppColors.errorColor.themeColor
            )
          : (
              LocaleKeys.attendance_over
                  .tr(namedArgs: {'time': DateHelper.hms(-left)}),
              AppColors.successColor.themeColor
            ),
    };

    return SizedBox(
      width: 220.r,
      height: 220.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(end: progress),
            duration: const Duration(seconds: 1),
            builder: (_, v, __) => CustomPaint(
              size: Size.square(220.r),
              painter: DialPainter(
                progress: v,
                track: AppColors.trackColor.themeColor,
                colors: paused
                    ? [
                        AppColors.orangeColor.themeColor,
                        AppColors.orangeColor.themeColor
                      ]
                    : [
                        AppColors.primaryColor.themeColor,
                        AppColors.cyanColor.themeColor
                      ],
              ),
            ),
          ),
          Container(
            width: 160.r,
            height: 160.r,
            decoration: BoxDecoration(
              color: AppColors.cardColor.themeColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.dividerColor.themeColor),
              boxShadow: paused
                  ? [
                      BoxShadow(
                        color: AppColors.orangeColor.themeColor
                            .withValues(alpha: 0.12),
                        spreadRadius: 6,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: AppText(label,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      color: AppColors.textSecondaryColor.themeColor),
                ),
                AppText(
                  DateHelper.hms(worked),
                  numeric: true,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
                SizedBox(height: 4.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: AppText(remain,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      color: remainColor ?? AppColors.primaryColor.themeColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DialPainter extends CustomPainter {
  DialPainter(
      {required this.progress, required this.track, required this.colors});

  final double progress;
  final Color track;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 14.0;
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - stroke / 2 - 1;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = track,
    );
    if (progress <= 0) return;
    canvas.drawArc(
      rect,
      -pi / 2,
      2 * pi * progress,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          colors: colors,
          transform: const GradientRotation(-pi / 2),
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(DialPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.colors != colors;
}
