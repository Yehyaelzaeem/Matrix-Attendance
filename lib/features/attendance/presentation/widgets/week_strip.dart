import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/models/day_type.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/widgets/app_text.dart';

class WeekStrip extends StatelessWidget {
  const WeekStrip({super.key, required this.schedule});

  final WeeklySchedule schedule;

  @override
  Widget build(BuildContext context) {
    final today = DateHelper.today();
    final todayIndex = DateHelper.weekIndex(today);
    final start = today.subtract(Duration(days: todayIndex));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Row(
        children: [
          for (final i in DateHelper.weekDays) ...[
            if (i > 0) SizedBox(width: 8.w),
            Expanded(
              child: Opacity(
                opacity: schedule[i] == DayType.off ? 0.55 : 1,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color:
                        i == todayIndex ? null : AppColors.cardColor.themeColor,
                    gradient:
                        i == todayIndex ? AppColors.primaryGradient : null,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      AppText(
                        DateHelper.shortDayName(i),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        maxLines: 1,
                        color: i == todayIndex
                            ? AppColors.headerTextColor.themeColor
                            : AppColors.textSecondaryColor.themeColor,
                      ),
                      SizedBox(height: 6.h),
                      Text((schedule[i] ?? DayType.off).emoji,
                          style: TextStyle(fontSize: 17.sp)),
                      SizedBox(height: 6.h),
                      AppText(
                        '${start.add(Duration(days: i)).day}',
                        numeric: true,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: i == todayIndex ? Colors.white : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
