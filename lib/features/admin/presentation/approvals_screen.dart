import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/models/paginated.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../../../core/widgets/pagination_widgets/pagination_list.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../../core/widgets/segment_tabs.dart';
import '../../requests/data/models/request_model.dart';
import '../logic/approvals_cubit.dart';
import '../logic/approvals_tab_cubit.dart';
import 'widgets/approval_log_card.dart';
import 'widgets/approval_request_card.dart';
import 'widgets/requester_role_filter.dart';

class ApprovalsScreen extends StatefulWidget {
  const ApprovalsScreen({super.key});

  @override
  State<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends State<ApprovalsScreen> {
  late final ApprovalsCubit _cubit = context.read<ApprovalsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.load();
  }

  void _selectTab(ApprovalsTab tab) {
    context.read<ApprovalsTabCubit>().select(tab);
    final data = _cubit.state;
    if (tab == ApprovalsTab.log && data is ApprovalsSuccess) _cubit.loadLog();
  }

  @override
  Widget build(BuildContext context) {
    final tab = context.watch<ApprovalsTabCubit>().state;
    return ColoredBox(
      color: AppColors.backgroundColor.themeColor,
      child: BlocBuilder<ApprovalsCubit, ApprovalsState>(
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageTopBar(title: LocaleKeys.admin_approvals.tr()),
            SegmentTabs<ApprovalsTab>(
              items: [
                SegmentItem(
                    ApprovalsTab.requests, LocaleKeys.admin_tabRequests.tr(),
                    count:
                        state is ApprovalsSuccess ? state.pending.total : null),
                SegmentItem(ApprovalsTab.log, LocaleKeys.admin_tabLog.tr(),
                    count: state is ApprovalsSuccess ? state.log?.total : null),
              ],
              selected: tab,
              onChanged: _selectTab,
            ),
            if (tab == ApprovalsTab.requests && state is ApprovalsSuccess)
              RequesterRoleFilter(
                selected: state.role,
                countOf: state.countFrom,
                onChanged: _cubit.setRole,
              ),
            Expanded(
              child: CustomScreenStateLayout(
                isLoading:
                    state is ApprovalsInitial || state is ApprovalsLoading,
                error: state is ApprovalsError
                    ? ErrorModel(
                        code: ErrorEnum.otherError, errorMessage: state.message)
                    : null,
                onRetry: () => _cubit.setRole(_cubit.role),
                builder: (_) {
                  final data = state as ApprovalsSuccess;
                  return tab == ApprovalsTab.requests
                      ? _list(
                          page: data.pending,
                          onLoadMore: _cubit.loadMore,
                          onRefresh: _cubit.refresh,
                          empty: LocaleKeys.admin_noRequests.tr(),
                          builder: (r, i) => ApprovalRequestCard(
                              key: ValueKey(r.id), request: r, index: i),
                        )
                      : data.log == null || data.logLoading
                          ? const Center(child: CustomLoadingWidget())
                          : _list(
                              page: data.log!,
                              onLoadMore: _cubit.loadMoreLog,
                              onRefresh: _cubit.loadLog,
                              empty: LocaleKeys.error_notFound.tr(),
                              builder: (r, i) =>
                                  ApprovalLogCard(request: r, index: i),
                            );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list({
    required Paginated<RequestModel> page,
    required Future<void> Function() onLoadMore,
    required Future<void> Function() onRefresh,
    required String empty,
    required Widget Function(RequestModel request, int index) builder,
  }) =>
      CustomPaginationListView<RequestModel>(
        itemCount: page.items.length,
        hasMorePages: page.hasMore,
        isMoreLoading: page.loadingMore,
        onLoadMore: onLoadMore,
        onRefresh: onRefresh,
        emptyMessage: empty,
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
        builder: (_, i) => builder(page.items[i], i),
      );
}
