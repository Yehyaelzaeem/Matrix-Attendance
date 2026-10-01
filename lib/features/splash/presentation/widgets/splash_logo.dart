import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/brand_logo_tile.dart';

class SplashLogo extends StatefulWidget {
  const SplashLogo({super.key});

  @override
  State<SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo> with TickerProviderStateMixin {
  late final AnimationController _rings = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  late final AnimationController _pop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _pop.forward();
    });
  }

  @override
  void dispose() {
    _rings.dispose();
    _pop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = 136.r;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < 3; i++)
            AnimatedBuilder(
              animation: _rings,
              builder: (_, __) {
                final t = (_rings.value + i / 3) % 1;
                return Opacity(
                  opacity: (0.9 * (1 - t)).clamp(0, 1),
                  child: Transform.scale(
                    scale: 0.8 + 1.1 * t,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.r),
                        border: Border.all(
                          color: AppColors.cyanColor.themeColor
                              .withValues(alpha: 0.55),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          AnimatedBuilder(
            animation: _pop,
            builder: (_, child) {
              final t = Curves.elasticOut.transform(_pop.value);
              return Opacity(
                opacity: _pop.value.clamp(0, 1),
                child: Transform.rotate(
                  angle: (1 - t) * -0.44,
                  child: Transform.scale(scale: 0.2 + 0.8 * t, child: child),
                ),
              );
            },
            child: BrandLogoTile(
              size: 124,
              radius: 36,
              padding: 16,
              shadows: [
                BoxShadow(
                  color:
                      AppColors.primaryColor.themeColor.withValues(alpha: 0.8),
                  blurRadius: 50,
                  spreadRadius: -10,
                  offset: const Offset(0, 20),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.08),
                  spreadRadius: 6,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
