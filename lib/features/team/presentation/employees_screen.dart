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
import '../../../core/widgets/pagination_widgets/pagination_list.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../../core/widgets/search_field.dart';
import '../data/models/employee_model.dart';
import '../logic/employees_cubit.dart';
import 'widgets/add_employee_sheet.dart';
import 'widgets/employee_list_card.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmployeesCubit>(
      create: (_) => getIt<EmployeesCubit>()..load(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor.themeColor,
        body: BlocBuilder<EmployeesCubit, EmployeesState>(
          builder: (context, state) {
            final cubit = context.read<EmployeesCubit>();
            final page = state.page;
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PageTopBar(
                      title: LocaleKeys.team_employeesTitle.tr(),
                      subtitle: LocaleKeys.team_employeesCount
                          .tr(namedArgs: {'n': '${page?.total ?? 0}'}),
                      showBack: true,
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.w, 0, 20.w, 8.h),
                      child: SearchField(
                        hint: LocaleKeys.team_searchHint.tr(),
                        onChanged: cubit.search,
                      ),
                    ),
                    Expanded(
                      child: CustomScreenStateLayout(
                        isLoading: state.loading && page == null,
                        error: state.error != null && page == null
                            ? ErrorModel(
                                code: ErrorEnum.otherError,
                                errorMessage: state.error!)
                            : null,
                        onRetry: cubit.refresh,
                        builder: (_) => CustomPaginationListView<EmployeeModel>(
                          itemCount: page!.items.length,
                          hasMorePages: page.hasMore,
                          isMoreLoading: page.loadingMore,
                          onLoadMore: cubit.loadMore,
                          onRefresh: cubit.refresh,
                          emptyMessage: LocaleKeys.common_noResults.tr(),
                          padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 100.h),
                          builder: (_, i) => EmployeeListCard(
                            employee: page.items[i],
                            metrics: state.metrics[page.items[i].id],
                            index: i,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                PositionedDirectional(
                  bottom: 22.h + MediaQuery.paddingOf(context).bottom,
                  end: 20.w,
                  child: AppFab(
                    label: LocaleKeys.team_newEmployee.tr(),
                    onTap: () => AppSheet.show(context,
                        child: AddEmployeeSheet(onCreated: cubit.upsert)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
