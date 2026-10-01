import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class LocationArt extends StatefulWidget {
  const LocationArt({super.key});

  @override
  State<LocationArt> createState() => _LocationArtState();
}

class _LocationArtState extends State<LocationArt>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 63),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => CustomPaint(
        painter: LocationArtPainter(
          seconds: _controller.value * 63,
          primary: AppColors.primaryColor.themeColor,
          secondary: AppColors.secondaryColor.themeColor,
          card: AppColors.cardColor.themeColor,
        ),
      ),
    );
  }
}

class LocationArtPainter extends CustomPainter {
  LocationArtPainter({
    required this.seconds,
    required this.primary,
    required this.secondary,
    required this.card,
  });

  final double seconds;
  final Color primary;
  final Color secondary;
  final Color card;

  double _wave(double period, {double phase = 0}) =>
      (sin((seconds / period + phase) * 2 * pi) + 1) / 2;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 300;
    canvas.save();
    canvas.scale(s);

    final pulse = (seconds % 1.8) / 1.8;
    canvas.drawCircle(
      const Offset(150, 200),
      46 * (0.5 + 1.1 * pulse),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = primary.withValues(alpha: 0.9 * (1 - pulse)),
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(150, 208), width: 108, height: 24),
      Paint()..color = primary.withValues(alpha: 0.12),
    );

    final buildingY = -8 * _wave(3.5);
    canvas.save();
    canvas.translate(0, buildingY);
    final building = RRect.fromRectAndRadius(
        const Rect.fromLTWH(44, 120, 62, 92), const Radius.circular(10));
    canvas.drawRRect(building, Paint()..color = card);
    canvas.drawRRect(
        building,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = AppColors.illustrationStrokeColor.light);
    final window = Paint()..color = primary.withValues(alpha: 0.85);
    for (final o in const [
      Offset(56, 134),
      Offset(82, 134),
      Offset(56, 156),
      Offset(82, 156),
    ]) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              o & const Size(12, 12), const Radius.circular(3)),
          window);
    }
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(68, 182, 16, 30), const Radius.circular(4)),
        Paint()..color = secondary);
    canvas.restore();

    final homeY = -8 * _wave(3.5, phase: 0.43);
    canvas.save();
    canvas.translate(0, homeY);
    final house = Path()
      ..moveTo(196, 150)
      ..lineTo(228, 124)
      ..lineTo(260, 150)
      ..lineTo(260, 208)
      ..quadraticBezierTo(260, 214, 254, 214)
      ..lineTo(202, 214)
      ..quadraticBezierTo(196, 214, 196, 208)
      ..close();
    canvas.drawPath(house, Paint()..color = card);
    canvas.drawPath(
        house,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = AppColors.illustrationStrokeColor.light);
    canvas.drawPath(
      Path()
        ..moveTo(188, 154)
        ..lineTo(228, 121)
        ..lineTo(268, 154),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = primary,
    );
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(218, 178, 20, 36), const Radius.circular(4)),
        Paint()..color = secondary);
    canvas.restore();

    final pinY = -12 * _wave(1.8, phase: 0.75);
    canvas.save();
    canvas.translate(0, pinY);
    final pin = Path()
      ..moveTo(150, 72)
      ..cubicTo(126, 72, 108, 90, 108, 113)
      ..cubicTo(108, 144, 150, 192, 150, 192)
      ..cubicTo(150, 192, 192, 144, 192, 113)
      ..cubicTo(192, 90, 174, 72, 150, 72)
      ..close();
    canvas.drawPath(
      pin,
      Paint()
        ..shader = LinearGradient(colors: [primary, secondary])
            .createShader(const Rect.fromLTWH(108, 72, 84, 120)),
    );
    canvas.drawCircle(
        const Offset(150, 113), 15, Paint()..color = Colors.white);
    canvas.restore();

    canvas.restore();
  }

  @override
  bool shouldRepaint(LocationArtPainter oldDelegate) =>
      oldDelegate.seconds != seconds;
}
