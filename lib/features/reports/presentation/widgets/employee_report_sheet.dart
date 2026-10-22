import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/key_value_row.dart';
import '../../../../core/widgets/stat_tiles.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/custom_loading_widget.dart';
import '../../logic/report_detail_cubit.dart';
import '../../logic/reports_cubit.dart';
import 'report_score_color.dart';
import 'score_ring.dart';

class EmployeeReportSheet extends StatelessWidget {
  const EmployeeReportSheet(
      {super.key, required this.userId, required this.month});

  final int userId;
  final String month;

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
    return BlocProvider<ReportDetailCubit>(
      create: (_) => getIt<ReportDetailCubit>()..load(userId, month),
      child: BlocBuilder<ReportDetailCubit, ReportDetailState>(
        builder: (context, detailState) {
          if (detailState.loading) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: const Center(child: CustomLoadingWidget()),
            );
          }
          final r = detailState.detail;
          if (r == null) {
            return AppEmpty(message: detailState.error);
          }
          final reports = context.watch<ReportsCubit>();
          final reviewed = reports.data?.isReviewed(userId) ?? r.reviewed;
          final locked = reports.data?.isLocked ?? r.closed;
          final none = LocaleKeys.common_none.tr();
          final success = AppColors.successColor.themeColor;
          final danger = AppColors.errorColor.themeColor;
          final warn = AppColors.warningDeepColor.themeColor;
          final projects = r.projects.join('، ');
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: ScoreRing(score: r.attendanceScore)),
              AppText(r.name,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  textAlign: TextAlign.center),
              AppText(r.job,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  color: AppColors.textSecondaryColor.themeColor),
              SizedBox(height: 14.h),
              _card([
                KeyValueRow(
                    label: LocaleKeys.reports_daysPresent.tr(),
                    value: '${r.present} / ${r.required}',
                    numeric: true),
                KeyValueRow(
                    label: LocaleKeys.reports_totalHours.tr(),
                    value: r.totalWorked,
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
                  value: r.lateAfterGrace > 0
                      ? LocaleKeys.reports_timesValue
                          .tr(namedArgs: {'n': '${r.lateAfterGrace}'})
                      : none,
                  valueColor: r.lateAfterGrace > 0 ? danger : success,
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
                  value: r.violations > 0
                      ? LocaleKeys.reports_daysValue
                          .tr(namedArgs: {'n': '${r.violations}'})
                      : none,
                  valueColor: r.violations > 0 ? danger : success,
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
                    value: r.kpiScore == null
                        ? LocaleKeys.common_dash.tr()
                        : '${r.kpiScore}%',
                    label: LocaleKeys.reports_scoreKpi.tr(),
                    color: r.kpiScore == null
                        ? AppColors.textSecondaryColor.themeColor
                        : ReportScoreColor.of(r.kpiScore!),
                  ),
                  StatTileData(
                    value: '${r.overall}%',
                    label: LocaleKeys.reports_scoreOverall.tr(),
                    color: ReportScoreColor.of(r.overall),
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
                    value: '${r.tasksTotal}',
                    numeric: true),
                KeyValueRow(
                  label: LocaleKeys.reports_kpiDone.tr(),
                  value: LocaleKeys.reports_kpiDoneValue.tr(namedArgs: {
                    'n': '${r.tasksDone}',
                    'p': '${r.completion}'
                  }),
                ),
                KeyValueRow(
                  label: LocaleKeys.reports_kpiOnTime.tr(),
                  value: r.onTimePct == null
                      ? LocaleKeys.common_dash.tr()
                      : LocaleKeys.reports_kpiOnTimeValue.tr(namedArgs: {
                          'a': '${r.onTime ?? 0}',
                          'b': '${r.tasksDone}',
                          'p': '${r.onTimePct}',
                        }),
                  valueColor: r.onTimePct == null
                      ? null
                      : (r.onTimePct! >= 80 ? success : warn),
                ),
                KeyValueRow(
                  label: LocaleKeys.reports_kpiAccuracy.tr(),
                  value: r.efficiency == null
                      ? LocaleKeys.common_dash.tr()
                      : '${r.efficiency}%',
                  valueColor: r.efficiency == null
                      ? null
                      : (r.efficiency! >= 90 ? success : warn),
                ),
                KeyValueRow(
                  label: LocaleKeys.reports_kpiReturns.tr(),
                  value: r.returns > 0
                      ? LocaleKeys.reports_timesValue
                          .tr(namedArgs: {'n': '${r.returns}'})
                      : LocaleKeys.reports_kpiNoReturns.tr(),
                  valueColor: r.returns > 0 ? warn : success,
                ),
                KeyValueRow(
                  label: LocaleKeys.reports_kpiLate.tr(),
                  value: r.openLate > 0
                      ? LocaleKeys.reports_kpiLateValue
                          .tr(namedArgs: {'n': '${r.openLate}'})
                      : none,
                  valueColor: r.openLate > 0 ? danger : success,
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
              if (locked)
                AppText(LocaleKeys.reports_monthClosed.tr(),
                    fontSize: 12,
                    textAlign: TextAlign.center,
                    color: AppColors.textSecondaryColor.themeColor)
              else
                CustomButton(
                  title: reviewed
                      ? LocaleKeys.reports_reviewedUndo.tr()
                      : LocaleKeys.reports_markReviewed.tr(),
                  type: reviewed
                      ? ButtonStyleType.ghost
                      : ButtonStyleType.primary,
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    final ok =
                        await reports.setReviewed(r.userId, r.name, !reviewed);
                    if (ok) navigator.pop();
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
