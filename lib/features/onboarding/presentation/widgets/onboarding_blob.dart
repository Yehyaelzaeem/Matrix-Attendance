import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class OnboardingBlob extends StatefulWidget {
  const OnboardingBlob({super.key});

  @override
  State<OnboardingBlob> createState() => _OnboardingBlobState();
}

class _OnboardingBlobState extends State<OnboardingBlob>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final t = (sin(_controller.value * 2 * pi - pi / 2) + 1) / 2;
          double lerp(double a, double b) => a + (b - a) * t;
          return Transform.rotate(
            angle: t * 0.14,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primarySoftColor.themeColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(lerp(118, 151), lerp(130, 117)),
                  topRight: Radius.elliptical(lerp(140, 108), lerp(117, 156)),
                  bottomRight:
                      Radius.elliptical(lerp(156, 104), lerp(143, 104)),
                  bottomLeft: Radius.elliptical(lerp(104, 156), lerp(130, 143)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
