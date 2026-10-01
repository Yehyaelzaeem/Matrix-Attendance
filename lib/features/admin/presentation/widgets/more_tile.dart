import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../../core/widgets/emoji_box.dart';

class MoreTile extends StatelessWidget {
  const MoreTile({
    super.key,
    required this.emoji,
    required this.background,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.big = false,
  });

  final String emoji;
  final Color background;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool big;

  @override
  Widget build(BuildContext context) {
    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: (big ? 132 : 116).h),
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(
          color: big ? null : AppColors.cardColor.themeColor,
          gradient: big
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.cardColor.themeColor,
                    AppColors.primarySoftColor.themeColor,
                  ],
                  stops: const [0.4, 1],
                )
              : null,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.navyColor.themeColor.withValues(alpha: 0.12),
              blurRadius: 22,
              spreadRadius: -18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EmojiBox(emoji: emoji, background: background, fontSize: 21),
            SizedBox(height: 10.h),
            AppText(title, fontSize: 15, fontWeight: FontWeight.w700),
            AppText(subtitle,
                fontSize: 12,
                height: 1.6,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondaryColor.themeColor),
          ],
        ),
      ),
    );
  }
}
