import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/key_value_row.dart';
import '../../../attendance/data/models/month_summary.dart';

class MonthlyReportCard extends StatelessWidget {
  const MonthlyReportCard({super.key, required this.month});

  final MonthSummary month;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.h),
      child: Column(
        children: [
          KeyValueRow(
            label: LocaleKeys.profile_presentDays.tr(),
            value: '${month.presentDays} / ${month.workDays}',
            numeric: true,
          ),
          KeyValueRow(
            label: LocaleKeys.profile_totalHours.tr(),
            value: month.totalDuration,
            numeric: true,
          ),
          KeyValueRow(
            label: LocaleKeys.profile_lateness.tr(),
            value: LocaleKeys.profile_lateValue.tr(namedArgs: {
              'n': '${month.lateCount}',
              'm': '${month.lateMinutes}'
            }),
          ),
          KeyValueRow(
            label: LocaleKeys.profile_deficitDays.tr(),
            value: LocaleKeys.profile_deficitValue.tr(namedArgs: {
              'n': '${month.deficitDays}',
              'm': '${month.deficitMinutes}'
            }),
          ),
          KeyValueRow(
            label: LocaleKeys.profile_violations.tr(),
            value: month.violations == 0
                ? LocaleKeys.common_none.tr()
                : '${month.violations}',
            valueColor: month.violations == 0
                ? AppColors.successColor.themeColor
                : AppColors.errorColor.themeColor,
          ),
          KeyValueRow(
            label: LocaleKeys.profile_leaves.tr(),
            value: '${month.leaves}',
            numeric: true,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
