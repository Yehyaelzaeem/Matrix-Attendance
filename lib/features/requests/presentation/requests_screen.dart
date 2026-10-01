import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/app_fab.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../../core/widgets/segment_tabs.dart';
import '../data/models/request_model.dart';
import '../logic/requests_cubit.dart';
import 'widgets/new_request_sheet.dart';
import 'widgets/request_card.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  late final _cubit = getIt<RequestsCubit>()..load();
  RequestStatus? _tab;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.backgroundColor.themeColor,
      child: BlocBuilder<RequestsCubit, RequestsState>(
        bloc: _cubit,
        builder: (context, state) => CustomScreenStateLayout(
          isLoading: state is RequestsInitial || state is RequestsLoading,
          builder: (_) {
            final all = state is RequestsSuccess
                ? state.requests
                : const <RequestModel>[];
            final list =
                all.where((r) => _tab == null || r.status == _tab).toList();
            int count(RequestStatus s) =>
                all.where((r) => r.status == s).length;
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PageTopBar(title: LocaleKeys.requests_title.tr()),
                    SegmentTabs<RequestStatus?>(
                      items: [
                        SegmentItem(null, LocaleKeys.common_all.tr(),
                            count: all.length),
                        SegmentItem(RequestStatus.pending,
                            LocaleKeys.requests_tabPending.tr(),
                            count: count(RequestStatus.pending)),
                        SegmentItem(RequestStatus.approved,
                            LocaleKeys.requests_tabApproved.tr(),
                            count: count(RequestStatus.approved)),
                        SegmentItem(RequestStatus.rejected,
                            LocaleKeys.requests_tabRejected.tr(),
                            count: count(RequestStatus.rejected)),
                      ],
                      selected: _tab,
                      onChanged: (s) => setState(() => _tab = s),
                    ),
                    Expanded(
                      child: list.isEmpty
                          ? AppEmpty(message: LocaleKeys.requests_empty.tr())
                          : ListView.separated(
                              padding:
                                  EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 100.h),
                              itemCount: list.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 10.h),
                              itemBuilder: (_, i) =>
                                  RequestCard(request: list[i], index: i),
                            ),
                    ),
                  ],
                ),
                PositionedDirectional(
                  bottom: 16.h,
                  end: 20.w,
                  child: AppFab(
                    label: LocaleKeys.requests_new.tr(),
                    onTap: () =>
                        AppSheet.show(context, child: const NewRequestSheet()),
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
