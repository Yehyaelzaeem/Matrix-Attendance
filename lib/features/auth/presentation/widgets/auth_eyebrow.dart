import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class AuthEyebrow extends StatelessWidget {
  const AuthEyebrow(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    return Container(
      height: 28.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.primarySoftColor.themeColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: primary.withValues(alpha: 0.2), spreadRadius: 3),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          AppText(label,
              fontSize: 12, fontWeight: FontWeight.w800, color: primary),
        ],
      ),
    );
  }
}
