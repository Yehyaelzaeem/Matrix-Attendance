import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/app_fab.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/segment_tabs.dart';
import '../../../core/widgets/stat_tiles.dart';
import '../data/models/task_enums.dart';
import '../data/models/task_filter.dart';
import '../logic/tasks_cubit.dart';
import 'widgets/new_task_sheet.dart';
import 'widgets/task_card.dart';
import 'widgets/task_filter_bar.dart';
import 'widgets/task_filter_picker_sheet.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({
    super.key,
    this.isTab = false,
    this.initialStatus,
    this.initialAssigneeId,
    this.initialDue = DueFilter.all,
  });

  final bool isTab;
  final TaskStatus? initialStatus;
  final int? initialAssigneeId;
  final DueFilter initialDue;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late final TasksCubit _cubit = context.read<TasksCubit>();
  final _search = TextEditingController();
  late TaskFilter _filter = TaskFilter(
    status: widget.initialStatus,
    assigneeId: widget.initialAssigneeId,
    due: widget.initialDue,
  );

  @override
  void initState() {
    super.initState();
    _cubit.load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  int _count(TaskFilter f) =>
      _cubit.tasks.where((t) => f.matches(t, ignoreStatus: true)).length;

  Future<void> _pick(TaskFilterKind kind) async {
    final picked = await AppSheet.show<TaskFilter>(
      context,
      child:
          TaskFilterPickerSheet(kind: kind, filter: _filter, countFor: _count),
    );
    if (picked != null) setState(() => _filter = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          final all = _cubit.tasks;
          final list = all.where(_filter.matches).toList()
            ..sort(TaskFilter.sort);
          final open = all.where((t) => !t.isDone).length;
          final late = all.where((t) => t.isLate).length;
          final review = all.where((t) => t.status == TaskStatus.review).length;
          final doneWeek = all
              .where((t) =>
                  t.isDone &&
                  t.doneAt != null &&
                  DateHelper.dayDiff(t.doneAt!) >= -7)
              .length;
          int countStatus(TaskStatus? s) => all
              .where((t) => _filter
                  .copyWith(status: s, clearStatus: s == null)
                  .matches(t))
              .length;
          return CustomScreenStateLayout(
            isLoading: state is TasksInitial || state is TasksLoading,
            error: state is TasksError
                ? ErrorModel(
                    code: ErrorEnum.otherError, errorMessage: state.message)
                : null,
            onRetry: _cubit.refresh,
            builder: (_) => Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PageTopBar(
                      title: widget.isTab
                          ? LocaleKeys.tasks_reviewTitle.tr()
                          : LocaleKeys.tasks_title.tr(),
                      subtitle: LocaleKeys.tasks_listSub.tr(namedArgs: {
                        'open': '$open',
                        'late': '$late',
                        'review': '$review',
                      }),
                      showBack: !widget.isTab,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: StatTilesRow(tiles: [
                        StatTileData(
                            value: '$open', label: LocaleKeys.tasks_open.tr()),
                        StatTileData(
                            value: '$late',
                            label: LocaleKeys.tasks_late.tr(),
                            color: AppColors.errorColor.themeColor),
                        StatTileData(
                            value: '$doneWeek',
                            label: LocaleKeys.tasks_doneWeek.tr(),
                            color: AppColors.successColor.themeColor),
                      ]),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.w, 12.h, 20.w, 8.h),
                      child: SearchField(
                        controller: _search,
                        hint: LocaleKeys.tasks_searchHint.tr(),
                        height: 46,
                        onChanged: (v) => setState(
                            () => _filter = _filter.copyWith(query: v)),
                      ),
                    ),
                    TaskFilterBar(
                      filter: _filter,
                      projectName: (id) => _cubit.projectNames[id] ?? '',
                      assigneeName: (id) => _cubit.assignees[id]?.name ?? '',
                      onPick: _pick,
                      onClear: () => setState(() {
                        _search.clear();
                        _filter = _filter.cleared();
                      }),
                    ),
                    SizedBox(height: 10.h),
                    SegmentTabs<TaskStatus?>(
                      items: [
                        SegmentItem(null, LocaleKeys.common_all.tr(),
                            count: countStatus(null)),
                        for (final s in TaskStatus.values)
                          SegmentItem(s, s.label, count: countStatus(s)),
                      ],
                      selected: _filter.status,
                      onChanged: (s) => setState(() => _filter =
                          _filter.copyWith(status: s, clearStatus: s == null)),
                    ),
                    Expanded(
                      child: list.isEmpty
                          ? AppEmpty(message: LocaleKeys.tasks_emptyFilter.tr())
                          : RefreshIndicator(
                              onRefresh: _cubit.refresh,
                              child: ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.fromLTRB(
                                    20.w, 12.h, 20.w, 100.h),
                                itemCount: list.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 10.h),
                                itemBuilder: (_, i) =>
                                    TaskCard(task: list[i], index: i),
                              ),
                            ),
                    ),
                  ],
                ),
                if (_cubit.canManage)
                  PositionedDirectional(
                    bottom: 16.h +
                        MediaQuery.paddingOf(context).bottom *
                            (widget.isTab ? 0 : 1),
                    end: 20.w,
                    child: AppFab(
                      label: LocaleKeys.tasks_newTask.tr(),
                      onTap: () => AppSheet.show(
                        context,
                        child: NewTaskSheet(projectId: _filter.projectId),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
