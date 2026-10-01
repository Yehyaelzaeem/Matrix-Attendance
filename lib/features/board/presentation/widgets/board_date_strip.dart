import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

class BoardDateStrip extends StatelessWidget {
  const BoardDateStrip(
      {super.key, required this.daysAgo, required this.onSelect});

  final int daysAgo;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final today = DateHelper.today();
    return SizedBox(
      height: 70.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: 7,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          final date = today.subtract(Duration(days: i));
          final on = i == daysAgo;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 58.w,
              decoration: BoxDecoration(
                color: on ? null : AppColors.cardColor.themeColor,
                gradient: on ? AppColors.primaryGradient : null,
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: on
                    ? [
                        BoxShadow(
                          color: AppColors.primaryColor.themeColor
                              .withValues(alpha: 0.8),
                          blurRadius: 20,
                          spreadRadius: -10,
                          offset: const Offset(0, 10),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    i == 0
                        ? LocaleKeys.board_todayShort.tr()
                        : DateHelper.shortDayName(DateHelper.weekIndex(date)),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    maxLines: 1,
                    color: on
                        ? AppColors.headerTextColor.themeColor
                        : AppColors.textSecondaryColor.themeColor,
                  ),
                  AppText('${date.day}',
                      numeric: true,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: on ? Colors.white : null),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
