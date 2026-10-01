import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

class PendingSteps extends StatelessWidget {
  const PendingSteps({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      (
        AppEmojis.check,
        AppColors.successColor.themeColor,
        LocaleKeys.auth_pendingStep1,
        LocaleKeys.auth_pendingStep1Sub
      ),
      (
        '…',
        AppColors.warningColor.themeColor,
        LocaleKeys.auth_pendingStep2,
        LocaleKeys.auth_pendingStep2Sub
      ),
      (
        '3',
        AppColors.idleStepColor.themeColor,
        LocaleKeys.auth_pendingStep3,
        LocaleKeys.auth_pendingStep3Sub
      ),
    ];
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Container(
                      width: 32.r,
                      height: 32.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: steps[i].$2,
                        shape: BoxShape.circle,
                      ),
                      child: AppText(steps[i].$1,
                          fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    if (i < steps.length - 1)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: AppColors.dividerColor.themeColor,
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 18.h, top: 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(steps[i].$3.tr(),
                            fontSize: 14.5, fontWeight: FontWeight.w700),
                        AppText(steps[i].$4.tr(),
                            fontSize: 12.5,
                            color: AppColors.textSecondaryColor.themeColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
