import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class SplashRain extends StatefulWidget {
  const SplashRain({super.key});

  @override
  State<SplashRain> createState() => _SplashRainState();
}

class _SplashRainState extends State<SplashRain>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat();

  late final List<RainDrop> _drops = List.generate(16, (_) {
    final random = Random();
    return RainDrop(
      x: random.nextDouble(),
      speed: 2.2 + random.nextDouble() * 2.8,
      phase: random.nextDouble(),
      opacity: 0.3 + random.nextDouble() * 0.6,
    );
  });

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
        builder: (_, __) => CustomPaint(
          painter: RainPainter(
            drops: _drops,
            seconds: _controller.value * 10,
            color: AppColors.cyanColor.themeColor,
          ),
        ),
      ),
    );
  }
}

class RainDrop {
  const RainDrop({
    required this.x,
    required this.speed,
    required this.phase,
    required this.opacity,
  });

  final double x;
  final double speed;
  final double phase;
  final double opacity;
}

class RainPainter extends CustomPainter {
  RainPainter(
      {required this.drops, required this.seconds, required this.color});

  final List<RainDrop> drops;
  final double seconds;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const length = 90.0;
    for (final drop in drops) {
      final progress = ((seconds / drop.speed) + drop.phase) % 1;
      final y = -120 + progress * (size.height + 240);
      final x = drop.x * size.width;
      final rect = Rect.fromLTWH(x, y, 2, length);
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            color.withValues(alpha: 0.8 * drop.opacity)
          ],
        ).createShader(rect);
      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(2)), paint);
    }
  }

  @override
  bool shouldRepaint(RainPainter oldDelegate) => oldDelegate.seconds != seconds;
}
