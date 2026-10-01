import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class BadgeBarcode extends StatefulWidget {
  const BadgeBarcode({super.key});

  @override
  State<BadgeBarcode> createState() => _BadgeBarcodeState();
}

class _BadgeBarcodeState extends State<BadgeBarcode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scan = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) _scan.repeat();
    });
  }

  @override
  void dispose() {
    _scan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cyan = AppColors.cyanColor.themeColor;
    return SizedBox(
      height: 24.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: LayoutBuilder(
          builder: (_, constraints) => Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.9,
                  child: CustomPaint(
                    painter: BarcodePainter(AppColors.textPrimaryColor.light),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _scan,
                builder: (_, __) {
                  final v = _scan.value;
                  final t =
                      Curves.easeInOut.transform(v < 0.5 ? v * 2 : (1 - v) * 2);
                  return PositionedDirectional(
                    top: 0,
                    bottom: 0,
                    start: -4 + t * (constraints.maxWidth + 5),
                    child: Container(
                      width: 3,
                      decoration: BoxDecoration(
                        color: cyan,
                        boxShadow: [
                          BoxShadow(
                            color: cyan.withValues(alpha: 0.8),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BarcodePainter extends CustomPainter {
  BarcodePainter(this.color);

  final Color color;

  static const List<(double, double)> _pattern = [
    (0, 2),
    (4, 5),
    (8, 11),
    (13, 14),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (double offset = 0; offset < size.width; offset += 17) {
      for (final bar in _pattern) {
        canvas.drawRect(
          Rect.fromLTRB(offset + bar.$1, 0, offset + bar.$2, size.height),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(BarcodePainter oldDelegate) => false;
}
