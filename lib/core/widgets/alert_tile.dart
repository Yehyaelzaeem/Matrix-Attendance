import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';
import 'emoji_box.dart';

class AlertTile extends StatelessWidget {
  const AlertTile({
    super.key,
    required this.emoji,
    required this.background,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.countColor,
    required this.onTap,
  });

  final String emoji;
  final Color background;
  final String title;
  final String subtitle;
  final String count;
  final Color countColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsetsDirectional.fromSTEB(18.w, 0, 18.w, 10.h),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            EmojiBox(emoji: emoji, background: background, fontSize: 20),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(title,
                      fontSize: 14.5, fontWeight: FontWeight.w700, maxLines: 1),
                  AppText(subtitle,
                      fontSize: 12.5,
                      maxLines: 1,
                      color: AppColors.textSecondaryColor.themeColor),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              constraints: BoxConstraints(minWidth: 30.r),
              height: 30.r,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: AppText(count,
                  numeric: true,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: countColor),
            ),
          ],
        ),
      ),
    );
  }
}
