import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_fab.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../logic/team_cubit.dart';
import 'widgets/add_holiday_sheet.dart';
import 'widgets/holiday_card.dart';

class HolidaysScreen extends StatelessWidget {
  const HolidaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<TeamCubit>()..load();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: BlocBuilder<TeamCubit, TeamState>(
        bloc: cubit,
        builder: (context, state) {
          final holidays = state is TeamSuccess ? state.holidays : const [];
          return Stack(
            children: [
              ListView(
                padding: EdgeInsets.only(bottom: 110.h),
                children: [
                  PageTopBar(
                    title: LocaleKeys.team_holidaysTitle.tr(),
                    subtitle: LocaleKeys.team_holidaysCount
                        .tr(namedArgs: {'n': '${holidays.length}'}),
                    showBack: true,
                  ),
                  for (final h in holidays)
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.w, 0, 20.w, 10.h),
                      child: HolidayCard(holiday: h),
                    ),
                ],
              ),
              PositionedDirectional(
                bottom: 16.h + MediaQuery.paddingOf(context).bottom,
                end: 20.w,
                child: AppFab(
                  label: LocaleKeys.team_newHoliday.tr(),
                  onTap: () =>
                      AppSheet.show(context, child: const AddHolidaySheet()),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
