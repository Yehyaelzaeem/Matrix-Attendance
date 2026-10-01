import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';

class ReasonBox extends StatelessWidget {
  const ReasonBox({
    super.key,
    required this.label,
    required this.text,
    this.danger = false,
    this.header,
  });

  final String label;
  final String text;
  final bool danger;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final color = danger
        ? AppColors.errorTextColor.themeColor
        : AppColors.textBodyColor.themeColor;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: danger
            ? AppColors.errorSoftColor.themeColor
            : AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) ...[header!, SizedBox(height: 6.h)],
          Text.rich(
            TextSpan(children: [
              TextSpan(
                text: '$label ',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12.sp,
                  color: danger ? color : AppColors.textPrimaryColor.themeColor,
                ),
              ),
              TextSpan(text: text),
            ]),
            style: TextStyle(
              fontFamily: AppFonts.familyFont,
              fontSize: 12.5.sp,
              height: 1.8,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
