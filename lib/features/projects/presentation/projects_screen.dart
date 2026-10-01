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
import '../../tasks/logic/tasks_cubit.dart';
import '../data/models/project_model.dart';
import '../logic/projects_cubit.dart';
import 'widgets/new_project_sheet.dart';
import 'widgets/project_card.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final _cubit = getIt<ProjectsCubit>()..load();
  ProjectStatus? _status;

  String _label(ProjectStatus s) => switch (s) {
        ProjectStatus.active => LocaleKeys.projects_filterActive.tr(),
        ProjectStatus.hold => LocaleKeys.projects_filterHold.tr(),
        ProjectStatus.delivered => LocaleKeys.projects_filterDelivered.tr(),
      };

  @override
  Widget build(BuildContext context) {
    final isAdmin = getIt<TasksCubit>().isAdmin;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: BlocBuilder<ProjectsCubit, ProjectsState>(
        bloc: _cubit,
        builder: (context, state) {
          final all = _cubit.projects;
          final list =
              all.where((p) => _status == null || p.status == _status).toList();
          return CustomScreenStateLayout(
            isLoading: state is ProjectsInitial || state is ProjectsLoading,
            builder: (_) => Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PageTopBar(
                      title: LocaleKeys.projects_title.tr(),
                      subtitle: LocaleKeys.projects_countSub
                          .tr(namedArgs: {'n': '${all.length}'}),
                      showBack: true,
                    ),
                    SegmentTabs<ProjectStatus?>(
                      items: [
                        SegmentItem(null, LocaleKeys.common_all.tr(),
                            count: all.length),
                        for (final s in ProjectStatus.values)
                          SegmentItem(s, _label(s),
                              count: all.where((p) => p.status == s).length),
                      ],
                      selected: _status,
                      onChanged: (s) => setState(() => _status = s),
                    ),
                    Expanded(
                      child: list.isEmpty
                          ? AppEmpty(message: LocaleKeys.projects_empty.tr())
                          : ListView.separated(
                              padding:
                                  EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 100.h),
                              itemCount: list.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 10.h),
                              itemBuilder: (_, i) =>
                                  ProjectCard(project: list[i], index: i),
                            ),
                    ),
                  ],
                ),
                if (isAdmin)
                  PositionedDirectional(
                    bottom: 16.h + MediaQuery.paddingOf(context).bottom,
                    end: 20.w,
                    child: AppFab(
                      label: LocaleKeys.projects_newProject.tr(),
                      onTap: () => AppSheet.show(context,
                          child: const NewProjectSheet()),
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
