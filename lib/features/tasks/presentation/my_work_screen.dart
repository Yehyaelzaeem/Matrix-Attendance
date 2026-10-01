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
import '../../../core/widgets/stat_tiles.dart';
import '../../projects/logic/projects_cubit.dart';
import '../../projects/presentation/widgets/project_card.dart';
import '../data/models/task_enums.dart';
import '../data/models/task_model.dart';
import '../logic/tasks_cubit.dart';
import 'widgets/filter_pill.dart';
import 'widgets/project_dot.dart';
import 'widgets/task_group_section.dart';

class MyWorkScreen extends StatefulWidget {
  const MyWorkScreen({super.key});

  @override
  State<MyWorkScreen> createState() => _MyWorkScreenState();
}

class _MyWorkScreenState extends State<MyWorkScreen> {
  final _tasks = getIt<TasksCubit>();
  final _projects = getIt<ProjectsCubit>();
  bool _showProjects = false;
  String? _projectId;

  static int _openOrder(TaskModel a, TaskModel b) {
    if (a.returned != b.returned) return a.returned ? -1 : 1;
    return a.due.compareTo(b.due);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      bloc: _tasks,
      builder: (context, state) => BlocBuilder<ProjectsCubit, ProjectsState>(
        bloc: _projects,
        builder: (context, _) {
          final me = _tasks.me;
          final mine = _tasks.tasks.where((t) => t.assignee == me).toList();
          final open = mine.where((t) => !t.isDone).toList();
          final projects =
              _projects.projects.where((p) => p.hasMember(me)).toList();
          final visible = mine
              .where((t) => _projectId == null || t.projectId == _projectId)
              .toList();
          List<TaskModel> group(TaskStatus s) {
            final list = visible.where((t) => t.status == s).toList();
            if (s == TaskStatus.done) {
              list.sort(
                  (a, b) => (b.doneAt ?? b.due).compareTo(a.doneAt ?? a.due));
              return list.take(4).toList();
            }
            return list..sort(_openOrder);
          }

          final groups = [
            (TaskStatus.doing, LocaleKeys.tasks_groupDoing.tr()),
            (TaskStatus.todo, LocaleKeys.tasks_groupTodo.tr()),
            (TaskStatus.review, LocaleKeys.tasks_groupReview.tr()),
            (TaskStatus.test, LocaleKeys.tasks_groupTest.tr()),
            (TaskStatus.done, LocaleKeys.tasks_groupDone.tr()),
          ];
          return CustomScreenStateLayout(
            isLoading: state is TasksInitial || state is TasksLoading,
            builder: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageTopBar(
                  title: LocaleKeys.tasks_myWork.tr(),
                  subtitle: LocaleKeys.tasks_myWorkSub.tr(namedArgs: {
                    'open': '${open.length}',
                    'projects': '${projects.length}',
                  }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: StatTilesRow(tiles: [
                    StatTileData(
                        value: '${open.length}',
                        label: LocaleKeys.tasks_open.tr()),
                    StatTileData(
                      value: '${mine.where((t) => t.isLate).length}',
                      label: LocaleKeys.tasks_late.tr(),
                      color: AppColors.errorColor.themeColor,
                    ),
                    StatTileData(
                      value:
                          '${mine.where((t) => t.status == TaskStatus.review || t.status == TaskStatus.test).length}',
                      label: LocaleKeys.tasks_atReviewer.tr(),
                      color: AppColors.violetColor.themeColor,
                    ),
                  ]),
                ),
                SizedBox(height: 14.h),
                SegmentTabs<bool>(
                  items: [
                    SegmentItem(false, LocaleKeys.tasks_tabTasks.tr(),
                        count: mine.length),
                    SegmentItem(true, LocaleKeys.tasks_tabProjects.tr(),
                        count: projects.length),
                  ],
                  selected: _showProjects,
                  onChanged: (v) => setState(() => _showProjects = v),
                ),
                if (!_showProjects) ...[
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 36.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      children: [
                        FilterPill(
                          label: LocaleKeys.tasks_allProjects.tr(),
                          active: _projectId == null,
                          onTap: () => setState(() => _projectId = null),
                        ),
                        for (final p in projects) ...[
                          SizedBox(width: 8.w),
                          FilterPill(
                            label: p.name,
                            leading: ProjectDot(color: p.color, size: 9),
                            active: _projectId == p.id,
                            onTap: () => setState(() => _projectId = p.id),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
                Expanded(
                  child: _showProjects
                      ? ListView.separated(
                          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 24.h),
                          itemCount: projects.length,
                          separatorBuilder: (_, __) => SizedBox(height: 10.h),
                          itemBuilder: (_, i) =>
                              ProjectCard(project: projects[i], index: i),
                        )
                      : visible.isEmpty
                          ? AppEmpty(message: LocaleKeys.tasks_empty.tr())
                          : ListView(
                              padding: EdgeInsets.only(bottom: 24.h, top: 4.h),
                              children: [
                                for (final g in groups)
                                  TaskGroupSection(
                                    status: g.$1,
                                    title: g.$2,
                                    tasks: group(g.$1),
                                  ),
                              ],
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
