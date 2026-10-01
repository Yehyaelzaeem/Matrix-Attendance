import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

class MeterBar extends StatelessWidget {
  const MeterBar({
    super.key,
    required this.value,
    this.color,
    this.gradient,
    this.height = 8,
    this.trackColor,
  });

  final double value;
  final Color? color;
  final Gradient? gradient;
  final double height;
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(height.r),
      child: Container(
        height: height.h,
        color: trackColor ?? AppColors.trackColor.themeColor,
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: clamped),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (_, v, __) => FractionallySizedBox(
              widthFactor: v,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: gradient == null
                      ? (color ?? AppColors.primaryColor.themeColor)
                      : null,
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(height.r),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
