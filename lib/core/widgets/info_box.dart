import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

enum InfoTone { info, warning, success, orange, danger }

class InfoBox extends StatelessWidget {
  const InfoBox({
    super.key,
    required this.text,
    this.emoji,
    this.tone = InfoTone.info,
    this.margin,
    this.child,
  });

  final String text;
  final String? emoji;
  final InfoTone tone;
  final EdgeInsetsGeometry? margin;
  final Widget? child;

  Color get _background => switch (tone) {
        InfoTone.info => AppColors.primarySoftColor.themeColor,
        InfoTone.warning => AppColors.warningSoftColor.themeColor,
        InfoTone.success => AppColors.successSoftColor.themeColor,
        InfoTone.orange => AppColors.orangeSoftColor.themeColor,
        InfoTone.danger => AppColors.errorSoftColor.themeColor,
      };

  Color get _foreground => switch (tone) {
        InfoTone.info => AppColors.infoTextColor.themeColor,
        InfoTone.warning => AppColors.warningTextColor.themeColor,
        InfoTone.success => AppColors.successTextColor.themeColor,
        InfoTone.orange => AppColors.orangeDeepColor.themeColor,
        InfoTone.danger => AppColors.errorTextColor.themeColor,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (emoji != null) ...[
            Text(emoji!, style: TextStyle(fontSize: 14.sp)),
            SizedBox(width: 10.w),
          ],
          Expanded(
            child: child ??
                AppText(text,
                    fontSize: 12.5,
                    height: 1.8,
                    fontWeight: FontWeight.w600,
                    color: _foreground),
          ),
        ],
      ),
    );
  }
}
