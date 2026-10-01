import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../data/models/month_summary.dart';
import 'month_stat_tile.dart';

class MonthStatsGrid extends StatelessWidget {
  const MonthStatsGrid({super.key, required this.month});

  final MonthSummary month;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      MonthStatTile(
        emoji: AppEmojis.checkBox,
        background: AppColors.successSoftColor.themeColor,
        value: '${month.presentDays}',
        label: LocaleKeys.attendance_statPresent.tr(),
      ),
      MonthStatTile(
        emoji: AppEmojis.timer,
        background: AppColors.primarySoftColor.themeColor,
        value: '${month.totalHours}',
        unit: LocaleKeys.common_hoursShort.tr(),
        label: LocaleKeys.attendance_statHours.tr(),
      ),
      MonthStatTile(
        emoji: AppEmojis.yellowDot,
        background: AppColors.warningSoftColor.themeColor,
        value: '${month.lateCount}',
        label: LocaleKeys.attendance_statLate
            .tr(namedArgs: {'n': '${month.lateMinutes}'}),
      ),
      MonthStatTile(
        emoji: AppEmojis.trophy,
        background: AppColors.violetSoftColor.themeColor,
        value: '${month.commitment}%',
        label: LocaleKeys.attendance_statCommitment.tr(),
      ),
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        children: [
          Row(children: [
            Expanded(child: tiles[0]),
            SizedBox(width: 10.w),
            Expanded(child: tiles[1]),
          ]),
          SizedBox(height: 10.h),
          Row(children: [
            Expanded(child: tiles[2]),
            SizedBox(width: 10.w),
            Expanded(child: tiles[3]),
          ]),
        ],
      ),
    );
  }
}
