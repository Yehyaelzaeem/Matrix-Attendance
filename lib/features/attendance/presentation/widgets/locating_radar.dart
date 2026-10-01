import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class LocatingRadar extends StatefulWidget {
  const LocatingRadar({super.key});

  @override
  State<LocatingRadar> createState() => _LocatingRadarState();
}

class _LocatingRadarState extends State<LocatingRadar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final size = 170.r;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primarySoftColor.themeColor,
                  AppColors.primarySoftColor.themeColor,
                  AppColors.radarInnerColor.themeColor,
                  AppColors.radarInnerColor.themeColor,
                  AppColors.radarOuterColor.themeColor,
                ],
                stops: const [0, 0.35, 0.36, 0.6, 0.61],
              ),
            ),
          ),
          RotationTransition(
            turns: _controller,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    primary.withValues(alpha: 0.35),
                    primary.withValues(alpha: 0)
                  ],
                  stops: const [0, 0.3],
                  transform: const GradientRotation(-pi / 2),
                ),
              ),
            ),
          ),
          Container(
            width: 62.r,
            height: 62.r,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.8),
                  blurRadius: 20,
                  spreadRadius: -6,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(Icons.location_on_rounded,
                color: Colors.white, size: 28.sp),
          ),
        ],
      ),
    );
  }
}
