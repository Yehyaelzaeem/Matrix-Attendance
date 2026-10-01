import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';
import 'custom_tap_effect.dart';

class AppFab extends StatelessWidget {
  const AppFab({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.themeColor.withValues(alpha: 0.9),
              blurRadius: 28,
              spreadRadius: -10,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, color: Colors.white, size: 22.sp),
            SizedBox(width: 8.w),
            AppText(label,
                fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
