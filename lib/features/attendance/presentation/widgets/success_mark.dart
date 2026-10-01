import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class SuccessMark extends StatelessWidget {
  const SuccessMark({super.key, this.emoji, this.background});

  final String? emoji;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (_, v, child) => Transform.scale(scale: v, child: child),
      child: Container(
        width: 110.r,
        height: 110.r,
        margin: EdgeInsets.only(top: 4.h, bottom: 14.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background ?? AppColors.successSoftColor.themeColor,
          shape: BoxShape.circle,
        ),
        child: emoji != null
            ? Text(emoji!, style: TextStyle(fontSize: 46.sp))
            : Icon(Icons.check_rounded,
                size: 56.sp, color: AppColors.successColor.themeColor),
      ),
    );
  }
}
