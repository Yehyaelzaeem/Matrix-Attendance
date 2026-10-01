import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/fade_slide_in.dart';

class SplashWordmark extends StatelessWidget {
  const SplashWordmark({super.key});

  @override
  Widget build(BuildContext context) {
    final letters = LocaleKeys.app_company.tr().split('');
    return Column(
      children: [
        ClipRect(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < letters.length; i++)
                  FadeSlideIn(
                    delay: Duration(milliseconds: 900 + i * 50),
                    offset: 34.h,
                    duration: const Duration(milliseconds: 700),
                    child: AppText(
                      letters[i] == ' ' ? ' ' : letters[i],
                      numeric: true,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.h),
        FadeSlideIn(
          delay: const Duration(milliseconds: 1500),
          offset: 0,
          duration: const Duration(milliseconds: 800),
          child: AppText(
            LocaleKeys.app_tagline.tr(),
            color: AppColors.headerTextColor.themeColor,
          ),
        ),
      ],
    );
  }
}
