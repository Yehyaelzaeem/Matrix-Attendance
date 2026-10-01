import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/locale_keys.dart';
import 'app_text.dart';

class AppEmpty extends StatelessWidget {
  const AppEmpty({super.key, this.message, this.padding = 30});

  final String? message;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding.h, horizontal: 16.w),
      child: AppText(
        message ?? LocaleKeys.error_notFound.tr(),
        textAlign: TextAlign.center,
        color: AppColors.textSecondaryColor.themeColor,
      ),
    );
  }
}
