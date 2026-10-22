import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/models/day_type.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../data/models/board_entry.dart';

class BoardEmployeeCard extends StatelessWidget {
  const BoardEmployeeCard({super.key, required this.entry, this.index = 0});

  final BoardEntry entry;
  final int index;

  @override
  Widget build(BuildContext context) {
    final location = switch (entry.location) {
      DayType.office => AppEmojis.office,
      DayType.home => AppEmojis.home,
      _ => AppEmojis.leave,
    };
    final dash = LocaleKeys.common_dash.tr();
    return FadeSlideIn(
      delay: Duration(milliseconds: index * 40),
      child: Container(
        padding: EdgeInsets.all(13.r),
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            AppAvatar(name: entry.name, imagePath: entry.image),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(entry.name,
                      fontSize: 14.5, fontWeight: FontWeight.w700, maxLines: 1),
                  AppText(entry.jobTitle,
                      fontSize: 12,
                      textDirection: TextDirection.ltr,
                      color: AppColors.textSecondaryColor.themeColor),
                  SizedBox(height: 5.h),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppText('➡ ${entry.checkIn ?? dash}',
                            numeric: true, fontSize: 12),
                        SizedBox(width: 10.w),
                        AppText('⬅ ${entry.checkOut ?? dash}',
                            numeric: true, fontSize: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(location, style: TextStyle(fontSize: 18.sp)),
                SizedBox(height: 6.h),
                StatusChip(
                    label: entry.note ?? entry.status.label,
                    tone: entry.status.tone),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
