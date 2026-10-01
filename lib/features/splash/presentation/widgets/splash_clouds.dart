import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashClouds extends StatefulWidget {
  const SplashClouds({super.key});

  @override
  State<SplashClouds> createState() => _SplashCloudsState();
}

class _SplashCloudsState extends State<SplashClouds>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final t = sin(_controller.value * 2 * pi);
          return Stack(
            children: [
              Positioned(
                top: MediaQuery.sizeOf(context).height * 0.14,
                right: -40.w + t * 24,
                child: Transform.translate(
                  offset: Offset(0, t * -8),
                  child: CloudShape(width: 180.w),
                ),
              ),
              Positioned(
                bottom: MediaQuery.sizeOf(context).height * 0.18,
                left: -30.w - t * 24,
                child: Transform.translate(
                  offset: Offset(0, t * 8),
                  child: CloudShape(width: 140.w),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CloudShape extends StatelessWidget {
  const CloudShape({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final color = Colors.white.withValues(alpha: 0.07);
    final height = width * 0.31;
    return SizedBox(
      width: width,
      height: height * 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Positioned(
            bottom: height * 0.3,
            left: width * 0.22,
            child: CircleAvatar(radius: width * 0.22, backgroundColor: color),
          ),
          Positioned(
            bottom: height * 0.4,
            left: width * 0.55,
            child: CircleAvatar(radius: width * 0.15, backgroundColor: color),
          ),
        ],
      ),
    );
  }
}
