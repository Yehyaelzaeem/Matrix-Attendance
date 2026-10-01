import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class ReviewedDot extends StatelessWidget {
  const ReviewedDot({super.key, required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    final success = AppColors.successColor.themeColor;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22.r,
      height: 22.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: on ? success : Colors.transparent,
        border: Border.all(
          color: on ? success : AppColors.dividerColor.themeColor,
          width: 2,
        ),
      ),
      child: on
          ? Icon(Icons.check_rounded, size: 13.sp, color: Colors.white)
          : null,
    );
  }
}
