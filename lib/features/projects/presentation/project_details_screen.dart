import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_fab.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../../../core/widgets/segment_tabs.dart';
import '../../../core/widgets/status_chip.dart';
import '../../tasks/logic/tasks_cubit.dart';
import '../../tasks/presentation/widgets/new_task_sheet.dart';
import '../data/models/project_progress.dart';
import '../logic/projects_cubit.dart';
import 'widgets/project_client_tab.dart';
import 'widgets/project_finance_tab.dart';
import 'widgets/project_hero.dart';
import 'widgets/project_overview_tab.dart';
import 'widgets/project_tasks_tab.dart';
import 'widgets/project_team_tab.dart';

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen(
      {super.key, required this.projectId, this.initialTab = 0});

  final int projectId;
  final int initialTab;

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late int _tab = widget.initialTab;

  @override
  void initState() {
    super.initState();
    context.read<ProjectsCubit>().reload(widget.projectId);
    context.read<TasksCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectsCubit>();
    final tasks = context.watch<TasksCubit>();
    final isAdmin = tasks.isAdmin;
    final tabs = [
      LocaleKeys.projects_tabOverview.tr(),
      LocaleKeys.projects_tabTeam.tr(),
      LocaleKeys.projects_tabTasks.tr(),
      if (isAdmin) LocaleKeys.projects_tabFinance.tr(),
      if (isAdmin) LocaleKeys.projects_tabClient.tr(),
    ];
    if (_tab >= tabs.length) _tab = 0;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: Builder(
        builder: (context) {
          final project = projects.byId(widget.projectId);
          if (project == null) {
            return const Center(child: CustomLoadingWidget());
          }
          final progress = ProjectProgress.of(project, tasks.tasks);
          final open = tasks.tasks
              .where((t) => t.projectId == project.id && !t.isDone)
              .length;
          final Widget body = switch (_tab) {
            0 => ProjectOverviewTab(
                project: project,
                isAdmin: isAdmin,
                onChangeManager: () => setState(() => _tab = 1),
              ),
            1 => ProjectTeamTab(project: project, isAdmin: isAdmin),
            2 => ProjectTasksTab(projectId: project.id),
            3 => ProjectFinanceTab(project: project),
            _ => ProjectClientTab(project: project),
          };
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PageTopBar(
                    title: project.name,
                    subtitle: project.client.company,
                    showBack: true,
                    trailing: StatusChip(
                        label: project.status.label, tone: project.status.tone),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(bottom: 110.h),
                      children: [
                        ProjectHero(
                            project: project,
                            progress: progress,
                            openTasks: open),
                        SizedBox(height: 14.h),
                        SegmentTabs<int>(
                          items: [
                            for (var i = 0; i < tabs.length; i++)
                              SegmentItem(i, tabs[i]),
                          ],
                          selected: _tab,
                          onChanged: (i) => setState(() => _tab = i),
                        ),
                        SizedBox(height: 10.h),
                        body,
                      ],
                    ),
                  ),
                ],
              ),
              if (_tab == 2 && tasks.canManage)
                PositionedDirectional(
                  bottom: 16.h + MediaQuery.paddingOf(context).bottom,
                  end: 20.w,
                  child: AppFab(
                    label: LocaleKeys.tasks_newTask.tr(),
                    onTap: () => AppSheet.show(context,
                        child: NewTaskSheet(projectId: project.id)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
