import 'dart:math';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

class OtpArt extends StatefulWidget {
  const OtpArt({super.key});

  @override
  State<OtpArt> createState() => _OtpArtState();
}

class _OtpArtState extends State<OtpArt> with SingleTickerProviderStateMixin {
  final _seconds = ValueNotifier<double>(0);
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker =
        createTicker((elapsed) => _seconds.value = elapsed.inMicroseconds / 1e6)
          ..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _seconds.dispose();
    super.dispose();
  }

  static double _keyframes(double t, List<(double, double)> stops) {
    if (t <= stops.first.$1) return stops.first.$2;
    for (var i = 1; i < stops.length; i++) {
      final (t1, v1) = stops[i];
      final (t0, v0) = stops[i - 1];
      if (t <= t1) {
        final p = Curves.easeInOut.transform((t - t0) / (t1 - t0));
        return v0 + (v1 - v0) * p;
      }
    }
    return stops.last.$2;
  }

  static double _phase(double seconds, double period, [double delay = 0]) {
    final s = seconds - delay;
    if (s < 0) return 0;
    return (s % period) / period;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260.r,
      height: 230.r,
      child: ValueListenableBuilder<double>(
        valueListenable: _seconds,
        builder: (_, s, __) => Stack(
          clipBehavior: Clip.none,
          children: [
            for (final delay in const [0.0, 1.4]) _wave(s, delay),
            _phone(s),
            _chip(
              s,
              right: -4,
              top: 34,
              period: 3.6,
              offset: 0,
              child: AppText(
                  '${AppEmojis.speech} ${LocaleKeys.auth_otpSmsChip.tr()}',
                  numeric: true,
                  fontSize: 12,
                  fontWeight: FontWeight.w800),
            ),
            _chip(
              s,
              left: 0,
              top: 96,
              period: 4.2,
              offset: 1.5,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                textDirection: TextDirection.ltr,
                children: [
                  AppText(AppEmojis.lock, fontSize: 12),
                  SizedBox(width: 6.r),
                  AppText('•' * AppConstants.otpLength,
                      numeric: true,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: AppColors.primaryColor.themeColor),
                ],
              ),
            ),
            _okBadge(s),
          ],
        ),
      ),
    );
  }

  Widget _wave(double s, double delay) {
    final p = _phase(s, 2.8, delay);
    final scale = 0.8 + 1.1 * Curves.easeOut.transform(p);
    final opacity = s < delay ? 0.0 : 0.9 * (1 - p);
    return Positioned(
      left: 55.r,
      top: 40.r,
      child: Opacity(
        opacity: opacity.clamp(0, 1),
        child: Transform.scale(
          scale: scale,
          child: Container(
            width: 150.r,
            height: 150.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color:
                      AppColors.primaryColor.themeColor.withValues(alpha: 0.35),
                  width: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _phone(double s) {
    final drop = s >= 0.9
        ? 0.0
        : -1.2 * (1 - const Cubic(0.2, 1.35, 0.4, 1).transform(s / 0.9));
    final f = _phase(s, 5);
    final wave = (1 - cos(f * 2 * pi)) / 2;
    final frame = AppColors.deviceFrameColor.themeColor;
    return Positioned(
      left: 71.r,
      top: 8.r,
      child: Transform.translate(
        offset: Offset(0, drop * 206.r - 8.r * wave),
        child: Transform.rotate(
          angle: (-4 + 3 * wave) * pi / 180,
          child: Container(
            width: 118.r,
            height: 206.r,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.cardColor.themeColor,
              borderRadius: BorderRadius.circular(26.r),
              border: Border.all(color: frame, width: 3),
              boxShadow: [
                BoxShadow(
                  color:
                      AppColors.primaryColor.themeColor.withValues(alpha: 0.6),
                  blurRadius: 44,
                  spreadRadius: -24,
                  offset: const Offset(0, 30),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: 46.r,
                  child: const DecoratedBox(
                    decoration: BoxDecoration(gradient: AppColors.darkGradient),
                  ),
                ),
                Positioned(
                  top: 7.r,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 34.r,
                      height: 8.r,
                      decoration: BoxDecoration(
                        color: frame,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 12.r,
                  right: 12.r,
                  top: 112.r,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final w in const [1.0, 0.7, 0.45]) ...[
                        FractionallySizedBox(
                          widthFactor: w,
                          child: Container(
                            height: 7.r,
                            margin: EdgeInsets.only(bottom: 7.r),
                            decoration: BoxDecoration(
                              color: AppColors.trackColor.themeColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Positioned(
                  left: 12.r,
                  right: 12.r,
                  bottom: 14.r,
                  child: Opacity(
                    opacity: _keyframes(_phase(s, 5.2), const [
                      (0.46, 0.25),
                      (0.54, 1),
                      (0.82, 1),
                      (0.90, 0.25),
                    ]),
                    child: Container(
                      height: 26.r,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(9.r),
                      ),
                    ),
                  ),
                ),
                _message(s),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _message(double s) {
    final p = _phase(s, 5.2);
    final shown = _keyframes(p, const [
      (0, 0),
      (0.09, 1),
      (0.86, 1),
      (0.94, 0),
    ]);
    return Positioned(
      left: 9.r,
      right: 9.r,
      top: 30.r,
      child: Opacity(
        opacity: shown,
        child: Transform.translate(
          offset: Offset(0, -70.r * (1 - shown)),
          child: Container(
            padding: EdgeInsets.fromLTRB(8.r, 8.r, 8.r, 9.r),
            decoration: BoxDecoration(
              color: AppColors.cardColor.themeColor,
              borderRadius: BorderRadius.circular(13.r),
              border: Border.all(color: AppColors.dividerColor.themeColor),
              boxShadow: [
                BoxShadow(
                  color: AppColors.navyColor.themeColor.withValues(alpha: 0.45),
                  blurRadius: 20,
                  spreadRadius: -10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 16.r,
                      height: 16.r,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    SizedBox(width: 5.r),
                    Container(
                      width: 44.r,
                      height: 5.r,
                      decoration: BoxDecoration(
                        color: AppColors.otpSenderLineColor.themeColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7.r),
                Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    for (var i = 0; i < AppConstants.otpLength; i++) ...[
                      if (i > 0) SizedBox(width: 3.r),
                      Expanded(child: _cell(s, i)),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cell(double s, int index) {
    final p = _phase(s, 5.2, 0.55 + index * 0.3);
    final scale = s < 0.55 + index * 0.3
        ? 0.0
        : _keyframes(p, const [
            (0, 0),
            (0.05, 1.5),
            (0.09, 1),
            (0.62, 1),
            (0.70, 0),
          ]);
    return Container(
      height: 20.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primarySoftColor.themeColor,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: 6.r,
          height: 6.r,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.themeColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _okBadge(double s) {
    final p = _phase(s, 5.2);
    final scale = _keyframes(p, const [
      (0.52, 0),
      (0.60, 1),
      (0.84, 1),
      (0.92, 0),
    ]);
    final angle = p < 0.6 ? -40 * (1 - scale) : 0.0;
    return Positioned(
      left: 166.r,
      top: 150.r,
      child: Transform.rotate(
        angle: angle * pi / 180,
        child: Transform.scale(
          scale: scale,
          child: Container(
            width: 46.r,
            height: 46.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.successColor.themeColor,
              shape: BoxShape.circle,
              border:
                  Border.all(color: AppColors.cardColor.themeColor, width: 4),
              boxShadow: [
                BoxShadow(
                  color:
                      AppColors.successColor.themeColor.withValues(alpha: 0.7),
                  blurRadius: 20,
                  spreadRadius: -8,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(Icons.check_rounded, color: Colors.white, size: 24.r),
          ),
        ),
      ),
    );
  }

  Widget _chip(
    double s, {
    double? left,
    double? right,
    required double top,
    required double period,
    required double offset,
    required Widget child,
  }) {
    final wave = (1 - cos(_phase(s + offset, period) * 2 * pi)) / 2;
    return Positioned(
      left: left?.r,
      right: right?.r,
      top: top.r,
      child: Transform.translate(
        offset: Offset(0, -8.r * wave),
        child: Container(
          height: 34.r,
          padding: EdgeInsets.symmetric(horizontal: 12.r),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.cardColor.themeColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.dividerColor.themeColor),
            boxShadow: [
              BoxShadow(
                color: AppColors.navyColor.themeColor.withValues(alpha: 0.5),
                blurRadius: 24,
                spreadRadius: -14,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
