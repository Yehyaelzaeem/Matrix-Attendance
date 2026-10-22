import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_pickers.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/icon_square_button.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/segment_tabs.dart';
import '../data/models/board_entry.dart';
import '../logic/board_cubit.dart';
import 'widgets/board_date_strip.dart';
import 'widgets/board_employee_card.dart';
import 'widgets/board_summary_row.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  late final BoardCubit _cubit = context.read<BoardCubit>();
  int _daysAgo = 0;
  BoardStatus? _tab;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _cubit.loadDay(0);
  }

  void _selectDay(int daysAgo) {
    setState(() => _daysAgo = daysAgo);
    _cubit.loadDay(daysAgo);
  }

  Future<void> _pickDate() async {
    final today = DateHelper.today();
    final picked = await AppPickers.pickDate(
      context,
      initial: today.subtract(Duration(days: _daysAgo)),
    );
    if (picked == null) return;
    final diff = today.difference(DateHelper.dateOnly(picked)).inDays;
    if (diff >= 0) _selectDay(diff);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.backgroundColor.themeColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageTopBar(
            title: LocaleKeys.board_title.tr(),
            trailing: IconSquareButton(
                icon: Icons.calendar_month_outlined, onTap: _pickDate),
          ),
          BoardDateStrip(daysAgo: _daysAgo, onSelect: _selectDay),
          Expanded(
            child: BlocBuilder<BoardCubit, BoardState>(
              builder: (context, state) => CustomScreenStateLayout(
                isLoading: state is BoardInitial || state is BoardLoading,
                error: state is BoardError
                    ? ErrorModel(
                        code: ErrorEnum.otherError, errorMessage: state.message)
                    : null,
                onRetry: () => _cubit.loadDay(_daysAgo),
                builder: (_) {
                  final day = (state as BoardSuccess).day;
                  final q = _query.trim().toLowerCase();
                  final list = day.entries
                      .where((e) =>
                          (_tab == null || e.status == _tab) &&
                          (q.isEmpty ||
                              e.name.contains(q) ||
                              e.jobTitle.toLowerCase().contains(q)))
                      .toList();
                  final summary = day.summary;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 14.h),
                      BoardSummaryRow(summary: summary),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(20.w, 6.h, 20.w, 0),
                        child: SearchField(
                          hint: LocaleKeys.board_searchHint.tr(),
                          onChanged: (v) => setState(() => _query = v),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      SegmentTabs<BoardStatus?>(
                        items: [
                          SegmentItem(null, LocaleKeys.common_all.tr(),
                              count: day.entries.length),
                          SegmentItem(
                              BoardStatus.present, BoardStatus.present.label,
                              count: summary.present),
                          SegmentItem(BoardStatus.paused,
                              LocaleKeys.board_tabPaused.tr(),
                              count: summary.paused),
                          SegmentItem(BoardStatus.late, BoardStatus.late.label,
                              count: summary.late),
                          SegmentItem(
                              BoardStatus.absent, BoardStatus.absent.label,
                              count: summary.absent),
                          SegmentItem(BoardStatus.out, BoardStatus.out.label,
                              count: summary.out),
                          SegmentItem(
                              BoardStatus.leave, BoardStatus.leave.label,
                              count: summary.leave),
                        ],
                        selected: _tab,
                        onChanged: (s) => setState(() => _tab = s),
                      ),
                      Expanded(
                        child: list.isEmpty
                            ? AppEmpty(
                                message: day.isHoliday
                                    ? LocaleKeys.board_holiday.tr()
                                    : LocaleKeys.board_empty.tr())
                            : RefreshIndicator(
                                onRefresh: () =>
                                    _cubit.loadDay(_daysAgo, silent: true),
                                child: ListView.separated(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 10.h, 20.w, 20.h),
                                  itemCount: list.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 10.h),
                                  itemBuilder: (_, i) => BoardEmployeeCard(
                                      entry: list[i], index: i),
                                ),
                              ),
                      ),
                    ],
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
