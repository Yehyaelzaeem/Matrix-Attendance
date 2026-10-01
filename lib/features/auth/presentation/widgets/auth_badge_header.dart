import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import 'employee_lanyard.dart';

class AuthBadgeHeader extends StatefulWidget {
  const AuthBadgeHeader({super.key});

  @override
  State<AuthBadgeHeader> createState() => _AuthBadgeHeaderState();
}

class _AuthBadgeHeaderState extends State<AuthBadgeHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glow = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat();

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.paddingOf(context).top;
    return SizedBox(
      height: safeTop + 312.h,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.authTopColor.themeColor,
                    AppColors.authMiddleColor.themeColor,
                    AppColors.cardColor.themeColor,
                  ],
                  stops: const [0, 0.55, 1],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.black, Colors.transparent],
                stops: [0, 0.55, 1],
              ).createShader(rect),
              child: CustomPaint(
                painter: MeshPainter(
                  primary: AppColors.primaryColor.themeColor,
                  cyan: AppColors.cyanColor.themeColor,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 26.h,
            child: Center(
              child: AnimatedBuilder(
                animation: _glow,
                builder: (_, __) {
                  final t = sin(_glow.value * 2 * pi);
                  return Transform.translate(
                    offset: Offset(6 * t, 0),
                    child: Transform.scale(
                      scaleX: 1 + 0.05 * t,
                      child: Container(
                        width: 220.w,
                        height: 26.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          gradient: RadialGradient(
                            colors: [
                              AppColors.primaryColor.themeColor
                                  .withValues(alpha: 0.22),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(child: EmployeeLanyard(ribbonHeight: safeTop + 64.h)),
          ),
        ],
      ),
    );
  }
}

class MeshPainter extends CustomPainter {
  MeshPainter({required this.primary, required this.cyan});

  final Color primary;
  final Color cyan;

  @override
  void paint(Canvas canvas, Size size) {
    void glow(Offset center, double radius, Color color) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = RadialGradient(colors: [color, color.withValues(alpha: 0)])
              .createShader(Rect.fromCircle(center: center, radius: radius)),
      );
    }

    glow(Offset(size.width * 0.85, size.height * 0.2), 130,
        cyan.withValues(alpha: 0.18));
    glow(Offset(size.width * 0.1, size.height * 0.6), 120,
        primary.withValues(alpha: 0.14));
    final dot = Paint()..color = AppColors.meshDotColor.light;
    for (double y = 0; y < size.height; y += 18) {
      for (double x = 0; x < size.width; x += 18) {
        canvas.drawCircle(Offset(x, y), 1.1, dot);
      }
    }
  }

  @override
  bool shouldRepaint(MeshPainter oldDelegate) => false;
}
