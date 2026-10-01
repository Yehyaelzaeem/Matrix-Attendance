import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

class IconSquareButton extends StatelessWidget {
  const IconSquareButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 44,
    this.background,
    this.color,
    this.showDot = false,
    this.dotBorderColor,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color? background;
  final Color? color;
  final bool showDot;
  final Color? dotBorderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.r,
        height: size.r,
        decoration: BoxDecoration(
          color: background ?? AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular((size * 0.32).r),
          boxShadow: background == null
              ? [
                  BoxShadow(
                    color:
                        AppColors.navyColor.themeColor.withValues(alpha: 0.18),
                    blurRadius: 16,
                    spreadRadius: -10,
                    offset: const Offset(0, 6),
                  )
                ]
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon,
                size: (size * 0.48).sp,
                color: color ?? AppColors.textPrimaryColor.themeColor),
            if (showDot)
              PositionedDirectional(
                top: 10.r,
                end: 11.r,
                child: Container(
                  width: 9.r,
                  height: 9.r,
                  decoration: BoxDecoration(
                    color: AppColors.errorColor.themeColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: dotBorderColor ?? Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
