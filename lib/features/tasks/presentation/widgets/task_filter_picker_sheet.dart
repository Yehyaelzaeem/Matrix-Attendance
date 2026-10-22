import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/option_tile.dart';
import '../../../projects/logic/projects_cubit.dart';
import '../../logic/tasks_cubit.dart';
import '../../data/models/task_enums.dart';
import '../../data/models/task_filter.dart';
import 'project_dot.dart';
import 'task_filter_bar.dart';

class TaskFilterPickerSheet extends StatelessWidget {
  const TaskFilterPickerSheet({
    super.key,
    required this.kind,
    required this.filter,
    required this.countFor,
  });

  final TaskFilterKind kind;
  final TaskFilter filter;
  final int Function(TaskFilter candidate) countFor;

  String get _title => switch (kind) {
        TaskFilterKind.project => LocaleKeys.tasks_filterProject.tr(),
        TaskFilterKind.assignee => LocaleKeys.tasks_filterAssignee.tr(),
        TaskFilterKind.due => LocaleKeys.tasks_filterDue.tr(),
      };

  Widget _count(int n) => Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor.themeColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: AppText('$n',
            numeric: true,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondaryColor.themeColor),
      );

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[];
    void add(String title, TaskFilter candidate, bool selected,
        {String? emoji, Widget? leading}) {
      tiles.add(OptionTile(
        title: title,
        leading: emoji,
        leadingWidget: leading,
        selected: selected,
        trailing: _count(countFor(candidate)),
        onTap: () => Navigator.of(context).pop(candidate),
      ));
    }

    switch (kind) {
      case TaskFilterKind.project:
        add(LocaleKeys.tasks_allProjects.tr(),
            filter.copyWith(clearProject: true), filter.projectId == null,
            emoji: AppEmojis.folder);
        final projects = context.read<ProjectsCubit>();
        for (final p in context.read<TasksCubit>().projectNames.entries) {
          add(p.value, filter.copyWith(projectId: p.key),
              filter.projectId == p.key,
              leading: SizedBox(
                width: 38.r,
                height: 38.r,
                child: Center(
                    child:
                        ProjectDot(color: projects.colorOf(p.key), size: 12)),
              ));
        }
      case TaskFilterKind.assignee:
        add(LocaleKeys.tasks_allEmployees.tr(),
            filter.copyWith(clearAssignee: true), filter.assigneeId == null,
            emoji: AppEmojis.users);
        for (final e in context.read<TasksCubit>().assignees.entries) {
          add(e.value.name, filter.copyWith(assigneeId: e.key),
              filter.assigneeId == e.key,
              leading: AppAvatar(
                  name: e.value.name,
                  imagePath: e.value.image,
                  size: 38,
                  radius: 12));
        }
      case TaskFilterKind.due:
        for (final d in DueFilter.values) {
          add(d.label, filter.copyWith(due: d), filter.due == d,
              emoji: d.emoji);
        }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(_title, fontSize: 18, fontWeight: FontWeight.w800),
        SizedBox(height: 10.h),
        ...tiles,
      ],
    );
  }
}
