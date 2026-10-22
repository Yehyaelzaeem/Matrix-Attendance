import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/stat_tiles.dart';
import '../../data/models/employee_report.dart';
import 'report_score_color.dart';

class ReportsSummary extends StatelessWidget {
  const ReportsSummary({super.key, required this.board});

  final ReportBoard board;

  @override
  Widget build(BuildContext context) {
    final b = board;
    StatTileData avgTile(String key, String label) {
      final avg = b.summaryIntOrNull(key);
      return StatTileData(
        value: avg == null ? LocaleKeys.common_dash.tr() : '$avg%',
        label: label,
        color: ReportScoreColor.of(avg ?? 0),
      );
    }

    final List<StatTileData> tiles = switch (b.mode) {
      ReportMode.attendance => [
          avgTile('avg_attendance', LocaleKeys.reports_avgAttendance.tr()),
          StatTileData(
            value: '${b.summaryInt('late_count')}',
            label: LocaleKeys.reports_lateCount.tr(),
          ),
          StatTileData(
            value: '${b.summaryInt('unexcused_absences')}',
            label: LocaleKeys.reports_unexcused.tr(),
            color: AppColors.errorColor.themeColor,
          ),
        ],
      ReportMode.kpi => [
          avgTile('avg_kpi', LocaleKeys.reports_avgKpi.tr()),
          StatTileData(
            value:
                '${b.summaryInt('tasks_done')}/${b.summaryInt('tasks_total')}',
            label: LocaleKeys.reports_tasksDone.tr(),
          ),
          StatTileData(
            value: '${b.summaryInt('open_late')}',
            label: LocaleKeys.reports_lateNow.tr(),
            color: AppColors.errorColor.themeColor,
          ),
        ],
      ReportMode.overall => () {
          final ranked = [...b.people]
            ..sort((x, y) => (y.score ?? 0).compareTo(x.score ?? 0));
          final top = ranked.firstOrNull;
          return [
            avgTile('avg_overall', LocaleKeys.reports_avgOverall.tr()),
            StatTileData(
              value: top == null
                  ? LocaleKeys.common_dash.tr()
                  : top.name.split(' ').first,
              numeric: false,
              label: LocaleKeys.reports_top
                  .tr(namedArgs: {'n': '${top?.score ?? 0}'}),
            ),
            StatTileData(
              value: '${b.people.where((p) => (p.score ?? 0) < 70).length}',
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
