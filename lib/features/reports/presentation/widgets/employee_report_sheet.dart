import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/key_value_row.dart';
import '../../../../core/widgets/stat_tiles.dart';
import '../../../projects/logic/projects_cubit.dart';
import '../../../tasks/data/models/task_kpi.dart';
import '../../../tasks/logic/tasks_cubit.dart';
import '../../data/models/employee_report.dart';
import '../../logic/reports_cubit.dart';
import 'report_score_color.dart';
import 'score_ring.dart';

class EmployeeReportSheet extends StatelessWidget {
  const EmployeeReportSheet({super.key, required this.name});

  final String name;

  Widget _card(List<Widget> rows) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border:
              Border.all(color: AppColors.dividerColor.themeColor, width: 1.5),
        ),
        child: Column(children: rows),
      );

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<ReportsCubit>();
    final tasks = getIt<TasksCubit>();
    return BlocBuilder<ReportsCubit, ReportsState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is! ReportsSuccess) return const SizedBox.shrink();
        final r = state.reports.firstWhere((e) => e.name == name);
        final k = TaskKpi.of(name, tasks.tasks);
        final overall = r.value(ReportMode.overall, k);
        final none = LocaleKeys.common_none.tr();
        final success = AppColors.successColor.themeColor;
        final danger = AppColors.errorColor.themeColor;
        final warn = AppColors.warningDeepColor.themeColor;
        final projects = getIt<ProjectsCubit>()
            .projects
            .where((p) => p.hasMember(name))
            .map((p) => p.name)
            .join('، ');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: ScoreRing(score: r.attendanceScore)),
            AppText(r.name,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                textAlign: TextAlign.center),
            AppText(r.jobTitle,
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
                color: AppColors.textSecondaryColor.themeColor),
            SizedBox(height: 14.h),
            _card([
              KeyValueRow(
                  label: LocaleKeys.reports_daysPresent.tr(),
                  value: '${r.days} / ${r.workDays}',
                  numeric: true),
              KeyValueRow(
                  label: LocaleKeys.reports_totalHours.tr(),
                  value: DateHelper.hoursAsClock(r.hours),
                  numeric: true),
              KeyValueRow(
                label: LocaleKeys.reports_lateness.tr(),
                value: LocaleKeys.reports_lateValue.tr(namedArgs: {
                  'n': '${r.lateCount}',
                  'm': '${r.lateMinutes}'
                }),
                valueColor: r.lateCount > 3 ? warn : null,
              ),
              KeyValueRow(
                label: LocaleKeys.reports_lateViolations.tr(),
                value: r.lateViolations > 0
                    ? LocaleKeys.reports_timesValue
                        .tr(namedArgs: {'n': '${r.lateViolations}'})
                    : none,
                valueColor: r.lateViolations > 0 ? danger : success,
              ),
              KeyValueRow(
                label: LocaleKeys.reports_deficitDays.tr(),
                value: r.deficitDays > 0
                    ? LocaleKeys.reports_deficitValue.tr(namedArgs: {
                        'n': '${r.deficitDays}',
                        'm': '${r.deficitMinutes}'
                      })
                    : none,
                valueColor: r.deficitDays > 0 ? warn : success,
              ),
              KeyValueRow(
                label: LocaleKeys.reports_locationViolations.tr(),
                value: r.locationViolations > 0
                    ? LocaleKeys.reports_daysValue
                        .tr(namedArgs: {'n': '${r.locationViolations}'})
                    : none,
                valueColor: r.locationViolations > 0 ? danger : success,
              ),
              KeyValueRow(
                label: LocaleKeys.reports_absences.tr(),
                value: r.absences > 0
                    ? LocaleKeys.reports_daysValue
                        .tr(namedArgs: {'n': '${r.absences}'})
                    : none,
                valueColor: r.absences > 0 ? danger : success,
              ),
              KeyValueRow(
                label: LocaleKeys.reports_pauses.tr(),
                value: r.pauses > 0
                    ? LocaleKeys.reports_pausesValue.tr(namedArgs: {
                        'n': '${r.pauses}',
                        'm': '${r.pauseMinutes}'
                      })
                    : none,
              ),
              KeyValueRow(
                label: LocaleKeys.reports_leaves.tr(),
                value: '${r.leaves}',
                numeric: true,
                showDivider: false,
              ),
            ]),
            SizedBox(height: 14.h),
            StatTilesRow(
              background: AppColors.surfaceColor.themeColor,
              valueSize: 20,
              tiles: [
                StatTileData(
                  value: '${r.attendanceScore}%',
                  label: LocaleKeys.reports_scoreAttendance.tr(),
                  color: ReportScoreColor.of(r.attendanceScore),
                ),
                StatTileData(
                  value: k.score == null
                      ? LocaleKeys.common_dash.tr()
                      : '${k.score}%',
                  label: LocaleKeys.reports_scoreKpi.tr(),
                  color: k.score == null
                      ? AppColors.textSecondaryColor.themeColor
                      : ReportScoreColor.of(k.score!),
                ),
                StatTileData(
                  value: '$overall%',
                  label: LocaleKeys.reports_scoreOverall.tr(),
                  color: ReportScoreColor.of(overall),
                  background: AppColors.primarySoftColor.themeColor,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            AppText(LocaleKeys.reports_kpiTitle.tr(),
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondaryColor.themeColor),
            SizedBox(height: 6.h),
            _card([
              KeyValueRow(
                  label: LocaleKeys.reports_kpiAssigned.tr(),
                  value: '${k.total}',
                  numeric: true),
              KeyValueRow(
                label: LocaleKeys.reports_kpiDone.tr(),
                value: LocaleKeys.reports_kpiDoneValue
                    .tr(namedArgs: {'n': '${k.done}', 'p': '${k.completion}'}),
              ),
              KeyValueRow(
                label: LocaleKeys.reports_kpiOnTime.tr(),
                value: k.done == 0
                    ? LocaleKeys.common_dash.tr()
                    : LocaleKeys.reports_kpiOnTimeValue.tr(namedArgs: {
                        'a': '${k.onTime}',
                        'b': '${k.done}',
                        'p': '${k.onTimePercent}',
                      }),
                valueColor: k.done == 0
                    ? null
                    : (k.onTimePercent >= 80 ? success : warn),
              ),
              KeyValueRow(
                label: LocaleKeys.reports_kpiAccuracy.tr(),
                value: k.spent == 0
                    ? LocaleKeys.common_dash.tr()
                    : LocaleKeys.reports_kpiAccuracyValue.tr(
                        namedArgs: {'e': '${k.estimate}', 's': '${k.spent}'}),
                valueColor:
                    k.spent == 0 ? null : (k.efficiency >= 90 ? success : warn),
              ),
              KeyValueRow(
                label: LocaleKeys.reports_kpiReturns.tr(),
                value: k.returns > 0
                    ? LocaleKeys.reports_timesValue
                        .tr(namedArgs: {'n': '${k.returns}'})
                    : LocaleKeys.reports_kpiNoReturns.tr(),
                valueColor: k.returns > 0 ? warn : success,
              ),
              KeyValueRow(
                label: LocaleKeys.reports_kpiLate.tr(),
                value: k.late > 0
                    ? LocaleKeys.reports_kpiLateValue
                        .tr(namedArgs: {'n': '${k.late}'})
                    : none,
                valueColor: k.late > 0 ? danger : success,
              ),
              KeyValueRow(
                label: LocaleKeys.reports_kpiProjects.tr(),
                value:
                    projects.isEmpty ? LocaleKeys.common_dash.tr() : projects,
                showDivider: false,
              ),
            ]),
            SizedBox(height: 8.h),
            AppText(LocaleKeys.reports_formula.tr(),
                fontSize: 11.5,
                height: 1.7,
                color: AppColors.textSecondaryColor.themeColor),
            SizedBox(height: 16.h),
            if (state.isLocked)
              AppText(LocaleKeys.reports_monthClosed.tr(),
                  fontSize: 12,
                  textAlign: TextAlign.center,
                  color: AppColors.textSecondaryColor.themeColor)
            else
              CustomButton(
                title: state.isReviewed(name)
                    ? LocaleKeys.reports_reviewedUndo.tr()
                    : LocaleKeys.reports_markReviewed.tr(),
                type: state.isReviewed(name)
                    ? ButtonStyleType.ghost
                    : ButtonStyleType.primary,
                onTap: () {
                  cubit.toggleReviewed(name);
                  Navigator.of(context).pop();
                },
              ),
          ],
        );
      },
    );
  }
}
