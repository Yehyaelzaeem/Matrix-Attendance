import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class FilterPill extends StatelessWidget {
  const FilterPill({
    super.key,
    required this.label,
    required this.onTap,
    this.active = false,
    this.danger = false,
    this.leading,
  });

  final String label;
  final VoidCallback onTap;
  final bool active;
  final bool danger;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final fg = danger
        ? AppColors.errorColor.themeColor
        : active
            ? AppColors.primaryColor.themeColor
            : AppColors.textPrimaryColor.themeColor;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: danger
              ? AppColors.errorSoftColor.themeColor
              : active
                  ? AppColors.primarySoftColor.themeColor
                  : AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color:
                active ? AppColors.primaryColor.themeColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[leading!, SizedBox(width: 6.w)],
            AppText(label,
                fontSize: 12.5, fontWeight: FontWeight.w700, color: fg),
          ],
        ),
      ),
    );
  }
}
