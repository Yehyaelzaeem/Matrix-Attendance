import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class OnboardingDots extends StatelessWidget {
  const OnboardingDots({super.key, required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final on = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: EdgeInsetsDirectional.only(end: 7.w),
          width: (on ? 28 : 8).w,
          height: 8.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: on ? null : AppColors.dividerColor.themeColor,
            gradient: on ? AppColors.primaryGradient : null,
          ),
        );
      }),
    );
  }
}
