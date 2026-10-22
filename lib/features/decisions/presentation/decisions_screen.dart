import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../../../core/widgets/pagination_widgets/pagination_list.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../data/models/decision_model.dart';
import '../logic/decisions_cubit.dart';
import 'widgets/decision_card.dart';

class DecisionsScreen extends StatefulWidget {
  const DecisionsScreen({super.key});

  @override
  State<DecisionsScreen> createState() => _DecisionsScreenState();
}

class _DecisionsScreenState extends State<DecisionsScreen> {
  late final DecisionsCubit _cubit = context.read<DecisionsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.load().then((_) => _cubit.markInfoSeen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageTopBar(
            title: LocaleKeys.decisions_title.tr(),
            subtitle: LocaleKeys.decisions_subtitle.tr(),
            showBack: true,
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
                onRetry: _cubit.refresh,
                builder: (_) {
                  final page = (state as DecisionsSuccess).page;
                  return CustomPaginationListView<DecisionModel>(
                    itemCount: page.items.length,
                    hasMorePages: page.hasMore,
                    isMoreLoading: page.loadingMore,
                    onLoadMore: _cubit.loadMore,
                    onRefresh: _cubit.refresh,
                    padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 30.h),
                    builder: (_, i) =>
                        DecisionCard(decision: page.items[i], index: i),
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
