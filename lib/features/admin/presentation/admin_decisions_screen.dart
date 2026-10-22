import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../../../core/widgets/pagination_widgets/pagination_list.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../decisions/data/models/decision_model.dart';
import '../../decisions/logic/decisions_cubit.dart';
import '../../decisions/presentation/widgets/admin_decision_card.dart';
import '../../decisions/presentation/widgets/compose_decision_sheet.dart';

class AdminDecisionsScreen extends StatelessWidget {
  const AdminDecisionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DecisionsCubit>()..load();
    return ColoredBox(
      color: AppColors.backgroundColor.themeColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageTopBar(
            title: LocaleKeys.decisions_adminTitle.tr(),
            trailing: CustomButton(
              width: 120.w,
              height: 42,
              radius: 13,
              fontSize: 13.5,
              icon: const Icon(Icons.add_rounded),
              title: LocaleKeys.decisions_publishNew.tr(),
              onTap: () =>
                  AppSheet.show(context, child: const ComposeDecisionSheet()),
            ),
          ),
          Expanded(
            child: BlocBuilder<DecisionsCubit, DecisionsState>(
              builder: (context, state) => CustomScreenStateLayout(
                isLoading:
                    state is DecisionsInitial || state is DecisionsLoading,
                error: state is DecisionsError
                    ? ErrorModel(
                        code: ErrorEnum.otherError, errorMessage: state.message)
                    : null,
                onRetry: cubit.refresh,
                builder: (_) {
                  final page = (state as DecisionsSuccess).page;
                  return CustomPaginationListView<DecisionModel>(
                    itemCount: page.items.length,
                    hasMorePages: page.hasMore,
                    isMoreLoading: page.loadingMore,
                    onLoadMore: cubit.loadMore,
                    onRefresh: cubit.refresh,
                    padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                    builder: (_, i) =>
                        AdminDecisionCard(decision: page.items[i], index: i),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
