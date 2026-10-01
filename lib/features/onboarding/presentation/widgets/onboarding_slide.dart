import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import 'highlighted_title.dart';
import 'onboarding_blob.dart';

class OnboardingSlide extends StatefulWidget {
  const OnboardingSlide({
    super.key,
    required this.active,
    required this.art,
    required this.title,
    required this.subtitle,
  });

  final bool active;
  final Widget art;
  final String title;
  final String subtitle;

  @override
  State<OnboardingSlide> createState() => _OnboardingSlideState();
}

class _OnboardingSlideState extends State<OnboardingSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  late final Animation<double> _art = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.17, 0.83, curve: Cubic(0.2, 0.8, 0.2, 1)),
  );

  late final Animation<double> _text = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.33, 1, curve: Cubic(0.2, 0.8, 0.2, 1)),
  );

  @override
  void initState() {
    super.initState();
    if (widget.active) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant OnboardingSlide oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) _controller.forward(from: 0);
    if (!widget.active && oldWidget.active) _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _reveal(Animation<double> animation, Widget child) => AnimatedBuilder(
        animation: animation,
        builder: (_, c) => Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - animation.value)),
            child: c,
          ),
        ),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
      child: Column(
        children: [
          _reveal(
            _art,
            SizedBox(
              width: 300.r,
              height: 300.r,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Positioned.fill(child: OnboardingBlob()),
                  SizedBox(width: 260.r, height: 260.r, child: widget.art),
                ],
              ),
            ),
          ),
          SizedBox(height: 26.h),
          _reveal(
            _text,
            Column(
              children: [
                HighlightedTitle(widget.title),
                SizedBox(height: 10.h),
                AppText(
                  widget.subtitle,
                  fontSize: 15,
                  height: 1.9,
                  textAlign: TextAlign.center,
                  color: AppColors.textSecondaryColor.themeColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
