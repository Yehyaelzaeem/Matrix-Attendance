import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/holiday_model.dart';

class HolidayCard extends StatelessWidget {
  const HolidayCard({super.key, required this.holiday});

  final HolidayModel holiday;

  @override
  Widget build(BuildContext context) {
    final diff = DateHelper.dayDiff(holiday.date);
    final passed = diff < 0;
    final status = passed
        ? LocaleKeys.team_passed.tr()
        : diff == 0
            ? LocaleKeys.common_today.tr()
            : LocaleKeys.team_inDays.tr(namedArgs: {'n': '$diff'});
    final danger = AppColors.errorColor.themeColor;
    return Opacity(
      opacity: passed ? 0.55 : 1,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            Container(
              width: 52.r,
              height: 56.r,
              decoration: BoxDecoration(
                color: AppColors.errorSoftColor.themeColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText('${holiday.date.day}',
                      numeric: true,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: danger),
                  AppText(DateHelper.monthName(holiday.date.month),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: danger,
                      maxLines: 1),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(holiday.name,
                      fontSize: 14.5, fontWeight: FontWeight.w700),
                  AppText(
                    '${DateHelper.dayName(DateHelper.weekIndex(holiday.date))} · $status',
                    fontSize: 12,
                    color: AppColors.textSecondaryColor.themeColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
