import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

class WhatsappPreview extends StatelessWidget {
  const WhatsappPreview({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final text = AppColors.whatsappTextColor.themeColor;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whatsappSoftColor.themeColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.chat_bubble_rounded,
                  size: 14.sp, color: AppColors.successTextColor.themeColor),
              SizedBox(width: 6.w),
              AppText(LocaleKeys.common_sentToGroup.tr(),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.successTextColor.themeColor),
            ],
          ),
          SizedBox(height: 2.h),
          AppText(message, fontSize: 13, height: 1.8, color: text),
        ],
      ),
    );
  }
}
