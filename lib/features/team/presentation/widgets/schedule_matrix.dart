import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/models/day_type.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/employee_model.dart';

class ScheduleMatrix extends StatelessWidget {
  const ScheduleMatrix(
      {super.key, required this.employees, required this.onTapEmployee});

  final List<EmployeeModel> employees;
  final ValueChanged<EmployeeModel> onTapEmployee;

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.textSecondaryColor.themeColor;
    final line = BorderSide(color: AppColors.dividerColor.themeColor);
    Widget cell(Widget child) => Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 1.w),
          child: Center(child: child),
        );
    int count(int day, DayType type) =>
        employees.where((e) => e.schedule[day] == type).length;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Table(
        columnWidths: {0: FixedColumnWidth(104.w)},
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            cell(Align(
              alignment: AlignmentDirectional.centerStart,
              child: AppText(LocaleKeys.team_employee.tr(),
                  fontSize: 10.5, fontWeight: FontWeight.w800, color: muted),
            )),
            for (final d in DateHelper.weekDays)
              cell(AppText(DateHelper.shortDayName(d),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  color: muted,
                  maxLines: 1)),
          ]),
          for (final e in employees)
            TableRow(
              decoration: BoxDecoration(border: Border(top: line)),
              children: [
                TableRowInkWell(
                  onTap: () => onTapEmployee(e),
                  child: cell(Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: AppText(e.name,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        maxLines: 1),
                  )),
                ),
                for (final d in DateHelper.weekDays)
                  TableRowInkWell(
                    onTap: () => onTapEmployee(e),
                    child: cell(Text((e.schedule[d] ?? DayType.off).emoji,
                        style: TextStyle(fontSize: 15.sp))),
                  ),
              ],
            ),
          TableRow(
            decoration: BoxDecoration(border: Border(top: line)),
            children: [
              cell(Align(
                alignment: AlignmentDirectional.centerStart,
                child: AppText(LocaleKeys.team_totals.tr(),
                    fontSize: 11, fontWeight: FontWeight.w800),
              )),
              for (final d in DateHelper.weekDays)
                cell(AppText(
                  '${count(d, DayType.office)}\n${count(d, DayType.home)}',
                  numeric: true,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                  textAlign: TextAlign.center,
                  color: muted,
                )),
            ],
          ),
        ],
      ),
    );
  }
}
