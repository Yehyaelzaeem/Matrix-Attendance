import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';

class TeamArt extends StatefulWidget {
  const TeamArt({super.key});

  @override
  State<TeamArt> createState() => _TeamArtState();
}

class _TeamArtState extends State<TeamArt> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 56),
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
        painter: TeamArtPainter(
          seconds: _controller.value * 56,
          primary: AppColors.primaryColor.themeColor,
          secondary: AppColors.secondaryColor.themeColor,
          cyan: AppColors.cyanColor.themeColor,
          success: AppColors.successColor.themeColor,
          card: AppColors.cardColor.themeColor,
        ),
      ),
    );
  }
}

class TeamArtPainter extends CustomPainter {
  TeamArtPainter({
    required this.seconds,
    required this.primary,
    required this.secondary,
    required this.cyan,
    required this.success,
    required this.card,
  });

  final double seconds;
  final Color primary;
  final Color secondary;
  final Color cyan;
  final Color success;
  final Color card;

  double _bar(double delay) {
    final cycle = ((seconds - delay) % 3.2) / 3.2;
    final t = cycle < 0.5 ? cycle * 2 : (1 - cycle) * 2;
    return 0.35 + 0.65 * Curves.easeInOut.transform(t);
  }

  double _float(double phase) =>
      -8 * (sin((seconds / 3.5 + phase) * 2 * pi) + 1) / 2;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 300;
    canvas.save();
    canvas.scale(s);

    final cardRect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(56, 70, 188, 160), const Radius.circular(22));
    canvas.drawRRect(cardRect, Paint()..color = card);
    canvas.drawRRect(
        cardRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = AppColors.illustrationLineColor.light);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(80, 86, 70, 10), const Radius.circular(5)),
        Paint()..color = AppColors.illustrationLineColor.light);

    const bars = [
      (82.0, 76.0, 0.0),
      (116.0, 96.0, 0.3),
      (150.0, 60.0, 0.6),
      (184.0, 106.0, 0.9),
    ];
    final colors = [primary, secondary, primary, cyan];
    for (var i = 0; i < bars.length; i++) {
      final h = bars[i].$2 * _bar(bars[i].$3);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(bars[i].$1, 206 - h, 22, h),
            const Radius.circular(7)),
        Paint()..color = colors[i],
      );
    }

    canvas.save();
    canvas.translate(0, _float(0.1));
    canvas.drawCircle(const Offset(240, 78), 30, Paint()..color = card);
    canvas.drawCircle(
        const Offset(240, 78),
        30,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = AppColors.illustrationLineColor.light);
    final emoji = TextPainter(
      text: const TextSpan(
          text: AppEmojis.megaphone, style: TextStyle(fontSize: 28)),
      textDirection: TextDirection.ltr,
    )..layout();
    emoji.paint(canvas,
        const Offset(240, 78) - Offset(emoji.width / 2, emoji.height / 2));
    canvas.restore();

    canvas.save();
    canvas.translate(0, _float(0.6));
    canvas.drawCircle(const Offset(58, 226), 26, Paint()..color = success);
    canvas.drawPath(
      Path()
        ..moveTo(47, 226)
        ..lineTo(55, 234)
        ..lineTo(70, 218),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = Colors.white,
    );
    canvas.restore();

    canvas.restore();
  }

  @override
  bool shouldRepaint(TeamArtPainter oldDelegate) =>
      oldDelegate.seconds != seconds;
}
