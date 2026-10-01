import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/info_box.dart';
import '../../logic/reports_cubit.dart';

class CloseMonthSheet extends StatelessWidget {
  const CloseMonthSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<ReportsCubit>();
    final total = cubit.data?.reports.length ?? 0;
    final items = [
      LocaleKeys.reports_closeAllReviewed
          .tr(namedArgs: {'a': '$total', 'b': '$total'}),
      LocaleKeys.reports_closeNoFixes.tr(),
      LocaleKeys.reports_closeDaysClosed.tr(),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          LocaleKeys.reports_closeTitle.tr(
              namedArgs: {'month': DateHelper.monthName(DateTime.now().month)}),
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        SizedBox(height: 8.h),
        for (var i = 0; i < items.length; i++)
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              border: i == items.length - 1
                  ? null
                  : Border(
                      bottom:
                          BorderSide(color: AppColors.dividerColor.themeColor)),
            ),
            child: Row(
              children: [
                Container(
                  width: 24.r,
                  height: 24.r,
                  decoration: BoxDecoration(
                    color: AppColors.successColor.themeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_rounded,
                      size: 14.sp, color: Colors.white),
                ),
                SizedBox(width: 10.w),
                Expanded(child: AppText(items[i], fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        InfoBox(
          text: LocaleKeys.reports_closeWarning.tr(),
          tone: InfoTone.warning,
          margin: EdgeInsets.symmetric(vertical: 14.h),
        ),
        CustomButton(
          title: LocaleKeys.reports_closeConfirm.tr(),
          onTap: () {
            cubit.closeMonth();
            Navigator.of(context).pop();
          },
        ),
        SizedBox(height: 6.h),
        CustomButton(
          title: LocaleKeys.common_cancel.tr(),
          type: ButtonStyleType.plain,
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
