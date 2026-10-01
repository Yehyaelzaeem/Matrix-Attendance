import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../logic/team_cubit.dart';
import 'widgets/employee_editor_sheet.dart';
import 'widgets/schedule_matrix.dart';

class SchedulesScreen extends StatelessWidget {
  const SchedulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<TeamCubit>()..load();
    final muted = AppColors.textSecondaryColor.themeColor;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: BlocBuilder<TeamCubit, TeamState>(
        bloc: cubit,
        builder: (context, _) => ListView(
          padding: EdgeInsets.only(bottom: 30.h),
          children: [
            PageTopBar(
              title: LocaleKeys.team_schedulesTitle.tr(),
              subtitle: LocaleKeys.team_schedulesSub.tr(),
              showBack: true,
            ),
            ScheduleMatrix(
              employees: cubit.employees,
              onTapEmployee: (name) => AppSheet.show(context,
                  child: EmployeeEditorSheet(name: name)),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(18.w, 10.h, 18.w, 0),
              child: Wrap(
                spacing: 14.w,
                children: [
                  AppText(LocaleKeys.team_legendOffice.tr(),
                      fontSize: 12, fontWeight: FontWeight.w600, color: muted),
                  AppText(LocaleKeys.team_legendHome.tr(),
                      fontSize: 12, fontWeight: FontWeight.w600, color: muted),
                  AppText(LocaleKeys.team_legendOff.tr(),
                      fontSize: 12, fontWeight: FontWeight.w600, color: muted),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
