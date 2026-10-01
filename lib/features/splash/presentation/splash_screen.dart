import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/grid_background.dart';
import '../../auth/logic/auth_cubit.dart';
import 'widgets/splash_clouds.dart';
import 'widgets/splash_loader.dart';
import 'widgets/splash_logo.dart';
import 'widgets/splash_rain.dart';
import 'widgets/splash_wordmark.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 3700), _navigate);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _navigate() {
    if (!mounted) return;
    final user = getIt<AuthCubit>().restoreSession();
    final String route;
    if (user != null) {
      route = user.isActive ? Routes.layoutScreen : Routes.pendingScreen;
    } else if (getIt<LocalStorage>().isOnboardingSeen) {
      route = Routes.loginScreen;
    } else {
      route = Routes.onBoardingScreen;
    }
    Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.navyColor.themeColor,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(gradient: AppColors.darkGradient),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Positioned.fill(child: GridBackground(lineAlpha: 0.06)),
              const Positioned.fill(child: SplashRain()),
              const Positioned.fill(child: SplashClouds()),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SplashLogo(),
                  SizedBox(height: 34.h),
                  const SplashWordmark(),
                ],
              ),
              PositionedDirectional(
                bottom: 60.h,
                start: 0,
                end: 0,
                child: const SplashLoader(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
