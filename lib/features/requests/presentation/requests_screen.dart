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
import '../../../core/widgets/segment_tabs.dart';
import '../data/models/request_model.dart';
import '../logic/requests_cubit.dart';
import 'widgets/new_request_sheet.dart';
import 'widgets/request_card.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key, this.showBack = false});

  final bool showBack;

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  late final RequestsCubit _cubit = context.read<RequestsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageTopBar(
                title: LocaleKeys.requests_title.tr(),
                subtitle:
                    widget.showBack ? LocaleKeys.requests_subtitle.tr() : null,
                showBack: widget.showBack,
              ),
              BlocBuilder<RequestsCubit, RequestsState>(
                buildWhen: (a, b) =>
                    b is RequestsSuccess || a.runtimeType != b.runtimeType,
                builder: (context, state) {
                  final summary = state is RequestsSuccess
                      ? state.summary
                      : const RequestSummary();
                  return SegmentTabs<RequestStatus?>(
                    items: [
                      SegmentItem(null, LocaleKeys.common_all.tr(),
                          count: summary.all),
                      SegmentItem(RequestStatus.pending,
                          LocaleKeys.requests_tabPending.tr(),
                          count: summary.pending),
                      SegmentItem(RequestStatus.approved,
                          LocaleKeys.requests_tabApproved.tr(),
                          count: summary.approved),
                      SegmentItem(RequestStatus.rejected,
                          LocaleKeys.requests_tabRejected.tr(),
                          count: summary.rejected),
                    ],
                    selected: _cubit.filter,
                    onChanged: _cubit.setFilter,
                  );
                },
              ),
              Expanded(
                child: BlocBuilder<RequestsCubit, RequestsState>(
                  builder: (context, state) => CustomScreenStateLayout(
                    isLoading:
                        state is RequestsInitial || state is RequestsLoading,
                    error: state is RequestsError
                        ? ErrorModel(
                            code: ErrorEnum.otherError,
                            errorMessage: state.message)
                        : null,
                    onRetry: () => _cubit.setFilter(_cubit.filter),
                    builder: (_) {
                      final page = (state as RequestsSuccess).page;
                      return CustomPaginationListView<RequestModel>(
                        itemCount: page.items.length,
                        hasMorePages: page.hasMore,
                        isMoreLoading: page.loadingMore,
                        onLoadMore: _cubit.loadMore,
                        onRefresh: _cubit.refresh,
                        emptyMessage: LocaleKeys.requests_empty.tr(),
                        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 100.h),
                        builder: (_, i) =>
                            RequestCard(request: page.items[i], index: i),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          PositionedDirectional(
            bottom: 16.h +
                (widget.showBack ? MediaQuery.paddingOf(context).bottom : 0),
            end: 20.w,
            child: AppFab(
              label: LocaleKeys.requests_new.tr(),
              onTap: () =>
                  AppSheet.show(context, child: const NewRequestSheet()),
            ),
          ),
        ],
      ),
    );
  }
}
