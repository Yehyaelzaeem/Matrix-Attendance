import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';
import 'emoji_box.dart';

class MenuItemTile extends StatelessWidget {
  const MenuItemTile({
    super.key,
    required this.emoji,
    required this.background,
    required this.label,
    required this.onTap,
    this.badge,
    this.danger = false,
    this.showDivider = true,
  });

  final String emoji;
  final Color background;
  final String label;
  final VoidCallback onTap;
  final Widget? badge;
  final bool danger;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(
                  bottom: BorderSide(color: AppColors.dividerColor.themeColor))
              : null,
        ),
        child: Row(
          children: [
            EmojiBox(
                emoji: emoji,
                background: background,
                size: 40,
                radius: 13,
                fontSize: 18),
            SizedBox(width: 12.w),
            Expanded(
              child: AppText(label,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: danger ? AppColors.errorColor.themeColor : null),
            ),
            if (badge != null) ...[badge!, SizedBox(width: 6.w)],
            if (!danger)
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 16.sp, color: AppColors.hintColor.themeColor),
          ],
        ),
      ),
    );
  }
}
