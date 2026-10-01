import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/models/day_type.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/emoji_box.dart';
import '../../../board/data/models/board_entry.dart';

class AdminKpiGrid extends StatelessWidget {
  const AdminKpiGrid({super.key, required this.day});

  final BoardDay day;

  Widget _tile(String emoji, Color bg, String value, String label) => Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.navyColor.themeColor.withValues(alpha: 0.2),
              blurRadius: 26,
              spreadRadius: -18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            EmojiBox(emoji: emoji, background: bg, size: 42, fontSize: 19),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(value,
                      numeric: true, fontSize: 24, fontWeight: FontWeight.w700),
                  AppText(label,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      maxLines: 1,
                      color: AppColors.textSecondaryColor.themeColor),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _tile(AppEmojis.office, AppColors.primarySoftColor.themeColor,
          '${day.atLocation(DayType.office)}', LocaleKeys.admin_atOffice.tr()),
      _tile(AppEmojis.home, AppColors.violetSoftColor.themeColor,
          '${day.atLocation(DayType.home)}', LocaleKeys.admin_fromHome.tr()),
      _tile(AppEmojis.alarm, AppColors.warningSoftColor.themeColor,
          '${day.count(BoardStatus.late)}', LocaleKeys.admin_late.tr()),
      _tile(AppEmojis.noEntry, AppColors.errorSoftColor.themeColor,
          '${day.count(BoardStatus.absent)}', LocaleKeys.admin_notArrived.tr()),
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        children: [
          Row(children: [
            Expanded(child: tiles[0]),
            SizedBox(width: 10.w),
            Expanded(child: tiles[1]),
          ]),
          SizedBox(height: 10.h),
          Row(children: [
            Expanded(child: tiles[2]),
            SizedBox(width: 10.w),
            Expanded(child: tiles[3]),
          ]),
        ],
      ),
    );
  }
}
