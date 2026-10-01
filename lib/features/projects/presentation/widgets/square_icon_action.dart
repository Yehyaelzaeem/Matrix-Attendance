import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class SquareIconAction extends StatelessWidget {
  const SquareIconAction({
    super.key,
    required this.emoji,
    required this.onTap,
    this.danger = false,
    this.tooltip,
  });

  final String emoji;
  final VoidCallback onTap;
  final bool danger;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final box = GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.r,
        height: 36.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: danger
              ? AppColors.errorSoftColor.themeColor
              : AppColors.surfaceColor.themeColor,
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: Text(
          emoji,
          style: TextStyle(
            fontSize: 15.sp,
            color: danger ? AppColors.errorColor.themeColor : null,
          ),
        ),
      ),
    );
    return tooltip == null ? box : Tooltip(message: tooltip!, child: box);
  }
}
