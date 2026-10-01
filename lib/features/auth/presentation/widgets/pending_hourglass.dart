import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class PendingHourglass extends StatefulWidget {
  const PendingHourglass({super.key});

  @override
  State<PendingHourglass> createState() => _PendingHourglassState();
}

class _PendingHourglassState extends State<PendingHourglass>
    with TickerProviderStateMixin {
  late final AnimationController _ring = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  )..repeat();

  late final AnimationController _flip = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  @override
  void dispose() {
    _ring.dispose();
    _flip.dispose();
    super.dispose();
  }

  double _flipAngle(double v) {
    if (v < 0.4) return 0;
    if (v < 0.5) return Curves.easeInOut.transform((v - 0.4) / 0.1) * pi;
    if (v < 0.9) return pi;
    return pi + Curves.easeInOut.transform((v - 0.9) / 0.1) * pi;
  }

  @override
  Widget build(BuildContext context) {
    final size = 150.r;
    return SizedBox(
      width: size + 28.r,
      height: size + 28.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: _ring,
            child: CustomPaint(
              size: Size.square(size + 28.r),
              painter: DashedCirclePainter(
                  color: AppColors.warningDashColor.themeColor),
            ),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.warningSoftColor.themeColor,
              shape: BoxShape.circle,
            ),
            child: AnimatedBuilder(
              animation: _flip,
              builder: (_, child) => Transform.rotate(
                  angle: _flipAngle(_flip.value), child: child),
              child: Icon(Icons.hourglass_bottom_rounded,
                  size: 64.sp, color: AppColors.warningDeepColor.themeColor),
            ),
          ),
        ],
      ),
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  DashedCirclePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final radius = size.width / 2 - 1;
    const dashes = 48;
    for (var i = 0; i < dashes; i++) {
      final start = i * 2 * pi / dashes;
      canvas.drawArc(
        Rect.fromCircle(center: size.center(Offset.zero), radius: radius),
        start,
        pi / dashes,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(DashedCirclePainter oldDelegate) => false;
}
