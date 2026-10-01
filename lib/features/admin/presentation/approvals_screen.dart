import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../../core/widgets/segment_tabs.dart';
import '../logic/approvals_cubit.dart';
import '../logic/approvals_tab_cubit.dart';
import 'widgets/approval_log_card.dart';
import 'widgets/approval_request_card.dart';
import 'widgets/new_account_card.dart';

class ApprovalsScreen extends StatelessWidget {
  const ApprovalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<ApprovalsCubit>();
    final tabs = getIt<ApprovalsTabCubit>();
    return ColoredBox(
      color: AppColors.backgroundColor.themeColor,
      child: BlocBuilder<ApprovalsTabCubit, ApprovalsTab>(
        bloc: tabs,
        builder: (context, tab) => BlocBuilder<ApprovalsCubit, ApprovalsState>(
          bloc: cubit,
          builder: (context, state) => CustomScreenStateLayout(
            isLoading: state is! ApprovalsSuccess,
            builder: (_) {
              final data = state as ApprovalsSuccess;
              final List<Widget> items = switch (tab) {
                ApprovalsTab.requests => [
                    for (var i = 0; i < data.requests.length; i++)
                      ApprovalRequestCard(
                          key: ValueKey(data.requests[i].id),
                          request: data.requests[i],
                          index: i),
                  ],
                ApprovalsTab.accounts => [
                    for (var i = 0; i < data.accounts.length; i++)
                      NewAccountCard(
                          key: ValueKey(data.accounts[i].name),
                          account: data.accounts[i],
                          index: i),
                  ],
                ApprovalsTab.log => [
                    for (var i = 0; i < data.log.length; i++)
                      ApprovalLogCard(entry: data.log[i], index: i),
                  ],
              };
              final empty = switch (tab) {
                ApprovalsTab.requests => LocaleKeys.admin_noRequests.tr(),
                ApprovalsTab.accounts => LocaleKeys.admin_noAccounts.tr(),
                ApprovalsTab.log => LocaleKeys.error_notFound.tr(),
              };
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PageTopBar(title: LocaleKeys.admin_approvals.tr()),
                  SegmentTabs<ApprovalsTab>(
                    items: [
                      SegmentItem(ApprovalsTab.requests,
                          LocaleKeys.admin_tabRequests.tr(),
                          count: data.requests.length),
                      SegmentItem(ApprovalsTab.accounts,
                          LocaleKeys.admin_tabAccounts.tr(),
                          count: data.accounts.length),
                      SegmentItem(
                          ApprovalsTab.log, LocaleKeys.admin_tabLog.tr(),
                          count: data.log.length),
                    ],
                    selected: tab,
                    onChanged: tabs.select,
                  ),
                  Expanded(
                    child: items.isEmpty
                        ? AppEmpty(message: empty)
                        : ListView.separated(
                            padding:
                                EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                            itemCount: items.length,
                            separatorBuilder: (_, __) => SizedBox(height: 10.h),
                            itemBuilder: (_, i) => items[i],
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
