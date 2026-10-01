import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/stat_tiles.dart';
import '../../../tasks/data/models/task_kpi.dart';
import '../../../tasks/data/models/task_model.dart';
import '../../data/models/employee_report.dart';
import '../../logic/reports_cubit.dart';
import 'report_score_color.dart';

class ReportsSummary extends StatelessWidget {
  const ReportsSummary({super.key, required this.data, required this.tasks});

  final ReportsSuccess data;
  final List<TaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    final reports = data.reports;
    final kpis = {for (final r in reports) r.name: TaskKpi.of(r.name, tasks)};
    int value(EmployeeReport r) => r.value(data.mode, kpis[r.name]!);
    final avg = reports.isEmpty
        ? 0
        : (reports.fold<int>(0, (a, r) => a + value(r)) / reports.length)
            .round();
    final avgTile = StatTileData(
      value: '$avg%',
      label: switch (data.mode) {
        ReportMode.attendance => LocaleKeys.reports_avgAttendance.tr(),
        ReportMode.kpi => LocaleKeys.reports_avgKpi.tr(),
        ReportMode.overall => LocaleKeys.reports_avgOverall.tr(),
      },
      color: ReportScoreColor.of(avg),
    );
    final List<StatTileData> tiles = switch (data.mode) {
      ReportMode.attendance => [
          avgTile,
          StatTileData(
            value: '${reports.fold<int>(0, (a, r) => a + r.lateMinutes)}',
            label: LocaleKeys.reports_lateMinutes.tr(),
          ),
          StatTileData(
            value:
                '${reports.fold<int>(0, (a, r) => a + r.violations + r.absences)}',
            label: LocaleKeys.reports_violationsAbsence.tr(),
            color: AppColors.errorColor.themeColor,
          ),
        ],
      ReportMode.kpi => [
          avgTile,
          StatTileData(
            value:
                '${kpis.values.fold<int>(0, (a, k) => a + k.done)}/${kpis.values.fold<int>(0, (a, k) => a + k.total)}',
            label: LocaleKeys.reports_tasksDone.tr(),
          ),
          StatTileData(
            value: '${kpis.values.fold<int>(0, (a, k) => a + k.late)}',
            label: LocaleKeys.reports_lateNow.tr(),
            color: AppColors.errorColor.themeColor,
          ),
        ],
      ReportMode.overall => () {
          final top = [...reports]
            ..sort((a, b) => value(b).compareTo(value(a)));
          return [
            avgTile,
            StatTileData(
              value: top.first.name.split(' ').first,
              numeric: false,
              label: LocaleKeys.reports_top
                  .tr(namedArgs: {'n': '${value(top.first)}'}),
            ),
            StatTileData(
              value: '${reports.where((r) => value(r) < 70).length}',
              label: LocaleKeys.reports_below70.tr(),
            ),
          ];
        }(),
    };
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 12.h, 20.w, 0),
      child: StatTilesRow(tiles: tiles),
    );
  }
}
