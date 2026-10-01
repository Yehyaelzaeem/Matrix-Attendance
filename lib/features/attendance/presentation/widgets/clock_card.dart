import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/live_ticker.dart';
import '../../data/models/attendance_enums.dart';
import '../../data/models/attendance_overview.dart';
import 'attendance_actions.dart';
import 'attendance_meta_row.dart';
import 'pause_line.dart';
import 'today_type_row.dart';
import 'work_dial.dart';

class ClockCard extends StatelessWidget {
  const ClockCard({
    super.key,
    required this.overview,
    required this.onMainAction,
    required this.onPauseAction,
  });

  final AttendanceOverview overview;
  final VoidCallback onMainAction;
  final VoidCallback onPauseAction;

  @override
  Widget build(BuildContext context) {
    final day = overview.day;
    final live = day.phase == AttendancePhase.working ||
        day.phase == AttendancePhase.paused;
    return AppCard(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      padding: EdgeInsets.all(20.r),
      child: LiveTicker(
        enabled: live,
        builder: (_, now) => Column(
          children: [
            TodayTypeRow(day: day),
            SizedBox(height: 18.h),
            WorkDial(day: day, now: now),
            SizedBox(height: 6.h),
            AttendanceActions(
              phase: day.phase,
              onMain: onMainAction,
              onPause: onPauseAction,
            ),
            SizedBox(height: 14.h),
            AttendanceMetaRow(
                day: day, now: now, lastCheckIn: overview.lastCheckIn),
            if (day.pauses.isNotEmpty) PauseLine(day: day, now: now),
          ],
        ),
      ),
    );
  }
}
