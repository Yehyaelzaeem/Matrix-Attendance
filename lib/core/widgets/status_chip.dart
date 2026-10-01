import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

enum ChipTone { blue, green, yellow, red, orange, violet, gray, glass }

extension ChipToneColors on ChipTone {
  Color get background => switch (this) {
        ChipTone.blue => AppColors.primarySoftColor.themeColor,
        ChipTone.green => AppColors.successSoftColor.themeColor,
        ChipTone.yellow => AppColors.warningSoftColor.themeColor,
        ChipTone.red => AppColors.errorSoftColor.themeColor,
        ChipTone.orange => AppColors.orangeSoftColor.themeColor,
        ChipTone.violet => AppColors.violetSoftColor.themeColor,
        ChipTone.gray => AppColors.neutralSoftColor.themeColor,
        ChipTone.glass => Colors.white.withValues(alpha: 0.16),
      };

  Color get foreground => switch (this) {
        ChipTone.blue => AppColors.primaryColor.themeColor,
        ChipTone.green => AppColors.successColor.themeColor,
        ChipTone.yellow => AppColors.warningTextColor.themeColor,
        ChipTone.red => AppColors.errorColor.themeColor,
        ChipTone.orange => AppColors.orangeTextColor.themeColor,
        ChipTone.violet => AppColors.violetColor.themeColor,
        ChipTone.gray => AppColors.textSecondaryColor.themeColor,
        ChipTone.glass => Colors.white,
      };
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.tone = ChipTone.gray,
    this.leading,
    this.small = false,
    this.numeric = false,
    this.background,
  });

  final String label;
  final ChipTone tone;
  final Widget? leading;
  final bool small;
  final bool numeric;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (small ? 22 : 26).h,
      padding: EdgeInsets.symmetric(horizontal: (small ? 8 : 10).w),
      decoration: BoxDecoration(
        color: background ?? tone.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[leading!, SizedBox(width: 5.w)],
          AppText(
            label,
            fontSize: small ? 11 : 12,
            fontWeight: FontWeight.w700,
            color: tone.foreground,
            numeric: numeric,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
