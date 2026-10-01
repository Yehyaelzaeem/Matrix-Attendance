import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

class SelectField extends StatelessWidget {
  const SelectField({
    super.key,
    required this.placeholder,
    required this.onTap,
    this.value,
    this.icon,
    this.valueDirection,
  });

  final String placeholder;
  final String? value;
  final IconData? icon;
  final VoidCallback onTap;
  final TextDirection? valueDirection;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(16.r),
          border:
              Border.all(color: AppColors.dividerColor.themeColor, width: 1.5),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon,
                  size: 20.sp, color: AppColors.textSecondaryColor.themeColor),
              SizedBox(width: 10.w),
            ],
            Expanded(
              child: AppText(
                hasValue ? value! : placeholder,
                fontSize: 15,
                maxLines: 1,
                textDirection: hasValue ? valueDirection : null,
                fontWeight: hasValue ? FontWeight.w600 : FontWeight.w500,
                color: hasValue
                    ? AppColors.textPrimaryColor.themeColor
                    : AppColors.hintColor.themeColor,
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded,
                size: 22.sp, color: AppColors.textSecondaryColor.themeColor),
          ],
        ),
      ),
    );
  }
}
