import 'dart:math';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';

class ClockArt extends StatefulWidget {
  const ClockArt({super.key});

  @override
  State<ClockArt> createState() => _ClockArtState();
}

class _ClockArtState extends State<ClockArt> with TickerProviderStateMixin {
  late final AnimationController _hands = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat();

  late final AnimationController _ring = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2500),
  )..repeat(reverse: true);

  late final AnimationController _pop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..forward();

  @override
  void dispose() {
    _hands.dispose();
    _ring.dispose();
    _pop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_hands, _ring, _pop]),
      builder: (_, __) => CustomPaint(
        painter: ClockArtPainter(
          hands: _hands.value,
          ring: Curves.easeOut.transform(_ring.value),
          pop: _pop.value,
          timeLabel: LocaleKeys.onboarding_badgeTime.tr(),
          checkLabel: LocaleKeys.onboarding_badgeCheck.tr(),
          primary: AppColors.primaryColor.themeColor,
          cyan: AppColors.cyanColor.themeColor,
          secondary: AppColors.secondaryColor.themeColor,
          navy: AppColors.navyColor.themeColor,
          success: AppColors.successColor.themeColor,
          card: AppColors.cardColor.themeColor,
        ),
      ),
    );
  }
}

class ClockArtPainter extends CustomPainter {
  ClockArtPainter({
    required this.hands,
    required this.ring,
    required this.pop,
    required this.timeLabel,
    required this.checkLabel,
    required this.primary,
    required this.cyan,
    required this.secondary,
    required this.navy,
    required this.success,
    required this.card,
  });

  final double hands;
  final double ring;
  final double pop;
  final String timeLabel;
  final String checkLabel;
  final Color primary;
  final Color cyan;
  final Color secondary;
  final Color navy;
  final Color success;
  final Color card;

  double _popAt(double start) {
    final t = ((pop - start) / 0.45).clamp(0.0, 1.0);
    return Curves.elasticOut.transform(t);
  }

  void _badge(Canvas canvas, Rect rect, Color fill, String label,
      TextStyle style, double scale,
      {Color? border}) {
    if (scale <= 0) return;
    canvas.save();
    canvas.translate(rect.center.dx, rect.center.dy);
    canvas.scale(scale);
    canvas.translate(-rect.center.dx, -rect.center.dy);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    canvas.drawRRect(rrect, Paint()..color = fill);
    if (border != null) {
      canvas.drawRRect(
          rrect,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = border);
    }
    final painter = TextPainter(
      text: TextSpan(text: label, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
        canvas, rect.center - Offset(painter.width / 2, painter.height / 2));
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 300;
    canvas.save();
    canvas.scale(s);
    const center = Offset(150, 150);

    canvas.drawCircle(center, 86, Paint()..color = card);
    canvas.drawCircle(
        center,
        86,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = AppColors.illustrationLineColor.light);
    canvas.drawCircle(
        center,
        70,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12
          ..color = AppColors.illustrationTrackColor.light);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 70),
      -pi / 2,
      2 * pi * 0.75 * ring,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          colors: [primary, cyan, primary],
          transform: const GradientRotation(-pi / 2),
        ).createShader(Rect.fromCircle(center: center, radius: 70)),
    );

    void hand(double angle, double length, double width, Color color) {
      final end = center + Offset(sin(angle) * length, -cos(angle) * length);
      canvas.drawLine(
          center,
          end,
          Paint()
            ..strokeWidth = width
            ..strokeCap = StrokeCap.round
            ..color = color);
    }

    hand(hands * 2 * pi, 46, 6, navy);
    hand(hands * 5 * 2 * pi, 54, 3, secondary);
    canvas.drawCircle(center, 8, Paint()..color = navy);

    _badge(
      canvas,
      const Rect.fromLTWH(196, 64, 78, 34),
      success,
      timeLabel,
      const TextStyle(
        fontFamily: AppFonts.numbersFont,
        fontWeight: FontWeight.w700,
        fontSize: 15,
        color: Colors.white,
      ),
      _popAt(0.3),
    );
    _badge(
      canvas,
      const Rect.fromLTWH(24, 200, 70, 34),
      card,
      checkLabel,
      TextStyle(
        fontFamily: AppFonts.familyFont,
        fontWeight: FontWeight.w800,
        fontSize: 13,
        color: primary,
      ),
      _popAt(0.55),
      border: AppColors.illustrationLineColor.light,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(ClockArtPainter oldDelegate) => true;
}
