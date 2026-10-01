import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

class OnboardingNextButton extends StatelessWidget {
  const OnboardingNextButton({
    super.key,
    required this.expanded,
    required this.onTap,
  });

  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        curve: const Cubic(0.2, 0.8, 0.2, 1),
        width: (expanded ? 150 : 64).w,
        height: 64.h,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.themeColor.withValues(alpha: 0.8),
              blurRadius: 26,
              spreadRadius: -10,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: expanded
              ? AppText(
                  LocaleKeys.onboarding_getStarted.tr(),
                  key: const ValueKey('label'),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  maxLines: 1,
                )
              : Icon(
                  Icons.arrow_forward_ios_rounded,
                  key: const ValueKey('icon'),
                  color: Colors.white,
                  size: 22.sp,
                ),
        ),
      ),
    );
  }
}
