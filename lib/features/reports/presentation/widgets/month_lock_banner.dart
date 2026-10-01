import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/app_text.dart';
import 'reopen_month_sheet.dart';

class MonthLockBanner extends StatelessWidget {
  const MonthLockBanner({super.key, required this.isAdmin});

  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(20.w, 12.h, 20.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.navyColor.themeColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppText(LocaleKeys.reports_locked.tr(),
                fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          if (isAdmin)
            CustomButton(
              width: 92.w,
              height: 36,
              radius: 10,
              fontSize: 12.5,
              type: ButtonStyleType.white,
              title: LocaleKeys.reports_reopen.tr(),
              onTap: () =>
                  AppSheet.show(context, child: const ReopenMonthSheet()),
            ),
        ],
      ),
    );
  }
}
