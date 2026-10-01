import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import 'custom_tap_effect.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.gradient,
    this.radius = AppConstants.cardBorderRadius,
    this.border,
    this.onTap,
    this.withShadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Gradient? gradient;
  final double radius;
  final BoxBorder? border;
  final VoidCallback? onTap;
  final bool withShadow;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      padding: padding ?? EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color:
            gradient == null ? (color ?? AppColors.cardColor.themeColor) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius.r),
        border: border,
        boxShadow: withShadow
            ? [
                BoxShadow(
                  color: AppColors.navyColor.themeColor.withValues(alpha: 0.10),
                  blurRadius: 22,
                  spreadRadius: -14,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: child,
    );
    if (onTap == null) return card;
    return CustomTapEffect(onTap: onTap, child: card);
  }
}
