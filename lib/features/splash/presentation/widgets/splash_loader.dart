import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

class SplashLoader extends StatefulWidget {
  const SplashLoader({super.key});

  @override
  State<SplashLoader> createState() => _SplashLoaderState();
}

class _SplashLoaderState extends State<SplashLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 140.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: AlignmentDirectional.centerStart,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => FractionallySizedBox(
              widthFactor:
                  const Cubic(0.6, 0, 0.3, 1).transform(_controller.value),
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    colors: [AppColors.cyanColor.themeColor, Colors.white],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 14.h),
        AppText(
          LocaleKeys.app_versionLabel.tr(),
          numeric: true,
          fontSize: 11,
          letterSpacing: 2,
          color: AppColors.splashCaptionColor.themeColor,
        ),
      ],
    );
  }
}
