import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_fab.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../../../core/widgets/pagination_widgets/pagination_list.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/holiday_model.dart';
import '../logic/team_cubit.dart';
import 'widgets/add_holiday_sheet.dart';
import 'widgets/holiday_card.dart';

class HolidaysScreen extends StatelessWidget {
  const HolidaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TeamCubit>()..load();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: BlocBuilder<TeamCubit, TeamState>(
        builder: (context, state) {
          final page = state is TeamSuccess ? state.holidays : null;
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PageTopBar(
                    title: LocaleKeys.team_holidaysTitle.tr(),
                    subtitle: LocaleKeys.team_holidaysCount
                        .tr(namedArgs: {'n': '${page?.total ?? 0}'}),
                    showBack: true,
                  ),
                  Expanded(
                    child: CustomScreenStateLayout(
                      isLoading: state is TeamInitial || state is TeamLoading,
                      error: state is TeamError
                          ? ErrorModel(
                              code: ErrorEnum.otherError,
                              errorMessage: state.message)
                          : null,
                      onRetry: cubit.refresh,
                      builder: (_) => CustomPaginationListView<HolidayModel>(
                        itemCount: page!.items.length,
                        hasMorePages: page.hasMore,
                        isMoreLoading: page.loadingMore,
                        onLoadMore: cubit.loadMoreHolidays,
                        onRefresh: cubit.refresh,
                        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 110.h),
                        builder: (_, i) => HolidayCard(holiday: page.items[i]),
                      ),
                    ),
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
