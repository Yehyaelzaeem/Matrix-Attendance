import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_text.dart';
import 'widgets/clock_art.dart';
import 'widgets/location_art.dart';
import 'widgets/onboarding_dots.dart';
import 'widgets/onboarding_next_button.dart';
import 'widgets/onboarding_slide.dart';
import 'widgets/team_art.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  static const _slides = [
    (LocaleKeys.onboarding_slide1Title, LocaleKeys.onboarding_slide1Subtitle),
    (LocaleKeys.onboarding_slide2Title, LocaleKeys.onboarding_slide2Subtitle),
    (LocaleKeys.onboarding_slide3Title, LocaleKeys.onboarding_slide3Subtitle),
  ];

  bool get _isLast => _page == _slides.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await getIt<LocalStorage>().setOnboardingSeen();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.loginScreen, (_) => false);
  }

  void _next() {
    if (_isLast) {
      _finish();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: const Cubic(0.2, 0.8, 0.2, 1),
      );
    }
  }

  Widget _artFor(int index) => switch (index) {
        0 => const LocationArt(),
        1 => const ClockArt(),
        _ => const TeamArt(),
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardColor.themeColor,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: 16.w, top: 8.h),
                child: TextButton(
                  onPressed: _finish,
                  child: AppText(
                    LocaleKeys.onboarding_skip.tr(),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondaryColor.themeColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => OnboardingSlide(
                  active: i == _page,
                  art: _artFor(i),
                  title: _slides[i].$1.tr(),
                  subtitle: _slides[i].$2.tr(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24.w, 0, 24.w, 32.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OnboardingDots(count: _slides.length, index: _page),
                  OnboardingNextButton(expanded: _isLast, onTap: _next),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
