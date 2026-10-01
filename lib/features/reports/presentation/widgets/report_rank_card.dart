import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/meter_bar.dart';
import '../../../tasks/data/models/task_kpi.dart';
import '../../data/models/employee_report.dart';
import 'report_score_color.dart';
import 'reviewed_dot.dart';

class ReportRankCard extends StatelessWidget {
  const ReportRankCard({
    super.key,
    required this.report,
    required this.kpi,
    required this.mode,
    required this.onTap,
    this.position,
    this.reviewed,
    this.index = 0,
  });

  final EmployeeReport report;
  final TaskKpi kpi;
  final ReportMode mode;
  final VoidCallback onTap;
  final int? position;
  final bool? reviewed;
  final int index;

  String get _subtitle => switch (mode) {
        ReportMode.attendance =>
          LocaleKeys.reports_subAttendance.tr(namedArgs: {
                'n': '${report.lateCount}',
                'm': '${report.lateMinutes}',
              }) +
              (report.violations > 0
                  ? LocaleKeys.reports_subViolations
                      .tr(namedArgs: {'n': '${report.violations}'})
                  : ''),
        ReportMode.kpi => kpi.total == 0
            ? LocaleKeys.reports_subNoTasks.tr()
            : LocaleKeys.reports_subKpi.tr(namedArgs: {
                  'a': '${kpi.done}',
                  'b': '${kpi.total}',
                  'p': '${kpi.onTimePercent}',
                }) +
                (kpi.late > 0
                    ? LocaleKeys.reports_subKpiLate
                        .tr(namedArgs: {'n': '${kpi.late}'})
                    : ''),
        ReportMode.overall => LocaleKeys.reports_subOverall.tr(namedArgs: {
            'a': '${report.attendanceScore}',
            'b': kpi.score == null
                ? LocaleKeys.common_dash.tr()
                : '${kpi.score}%',
          }),
      };

  @override
  Widget build(BuildContext context) {
    final value = report.value(mode, kpi);
    final color = ReportScoreColor.of(value);
    final muted = AppColors.textSecondaryColor.themeColor;
    return FadeSlideIn(
      delay: Duration(milliseconds: index * 35),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(13.r),
          decoration: BoxDecoration(
            color: AppColors.cardColor.themeColor,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Row(
            children: [
              if (position != null) ...[
                SizedBox(
                  width: 20.w,
                  child: AppText('$position',
                      numeric: true,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                      color: muted),
                ),
                SizedBox(width: 8.w),
              ],
              AppAvatar(name: report.name),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(report.name,
                        fontWeight: FontWeight.w700, maxLines: 1),
                    AppText(_subtitle,
                        fontSize: 11.5, color: muted, maxLines: 1),
                    SizedBox(height: 7.h),
                    MeterBar(value: value / 100, color: color, height: 6),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              SizedBox(
                width: 52.w,
                child: Column(
                  children: [
                    AppText('$value%',
                        numeric: true,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: color),
                    AppText(mode.unit,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: muted),
                  ],
                ),
              ),
              if (reviewed != null) ...[
                SizedBox(width: 6.w),
                ReviewedDot(on: reviewed!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
