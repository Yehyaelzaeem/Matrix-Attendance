import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/day_type.dart';
import '../utils/app_colors.dart';
import '../utils/date_helper.dart';
import 'app_text.dart';

class ScheduleEditor extends StatelessWidget {
  const ScheduleEditor({
    super.key,
    required this.schedule,
    this.onChanged,
    this.dimOff = false,
  });

  final WeeklySchedule schedule;
  final ValueChanged<WeeklySchedule>? onChanged;
  final bool dimOff;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final i in DateHelper.weekDays) ...[
          if (i > 0) SizedBox(width: 6.w),
          Expanded(
            child: GestureDetector(
              onTap: onChanged == null
                  ? null
                  : () => onChanged!({
                        ...schedule,
                        i: (schedule[i] ?? DayType.off).next,
                      }),
              child: Opacity(
                opacity: dimOff && schedule[i] == DayType.off ? 0.6 : 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: dimOff && schedule[i] == DayType.off
                        ? AppColors.cardColor.themeColor
                        : (schedule[i] ?? DayType.off).softColor,
                    borderRadius: BorderRadius.circular(14.r),
                    border: onChanged != null
                        ? Border.all(
                            color: AppColors.dividerColor.themeColor,
                            width: 1.5)
                        : null,
                  ),
                  child: Column(
                    children: [
                      AppText(DateHelper.shortDayName(i),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          maxLines: 1),
                      SizedBox(height: 4.h),
                      Text((schedule[i] ?? DayType.off).emoji,
                          style: TextStyle(fontSize: 16.sp)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
