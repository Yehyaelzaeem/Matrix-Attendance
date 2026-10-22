import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../data/models/task_enums.dart';
import '../../data/models/task_filter.dart';
import 'filter_pill.dart';

enum TaskFilterKind { project, assignee, due }

class TaskFilterBar extends StatelessWidget {
  const TaskFilterBar({
    super.key,
    required this.filter,
    required this.projectName,
    required this.assigneeName,
    required this.onPick,
    required this.onClear,
  });

  final TaskFilter filter;
  final String Function(int id) projectName;
  final String Function(int id) assigneeName;
  final ValueChanged<TaskFilterKind> onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final assignee =
        filter.assigneeId == null ? null : assigneeName(filter.assigneeId!);
    return SizedBox(
      height: 36.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        children: [
          FilterPill(
            label:
                '${AppEmojis.folder} ${filter.projectId == null ? LocaleKeys.tasks_allProjects.tr() : projectName(filter.projectId!)} ▾',
            active: filter.projectId != null,
            onTap: () => onPick(TaskFilterKind.project),
          ),
          SizedBox(width: 8.w),
          FilterPill(
            label:
                '${AppEmojis.user} ${assignee == null ? LocaleKeys.tasks_allEmployees.tr() : assignee.split(' ').take(2).join(' ')} ▾',
            active: assignee != null,
            onTap: () => onPick(TaskFilterKind.assignee),
          ),
          SizedBox(width: 8.w),
          FilterPill(
            label: '${AppEmojis.calendar} ${filter.due.label} ▾',
            active: filter.due != DueFilter.all,
            onTap: () => onPick(TaskFilterKind.due),
          ),
          if (filter.projectId != null ||
              assignee != null ||
              filter.due != DueFilter.all ||
              filter.query.isNotEmpty) ...[
            SizedBox(width: 8.w),
            FilterPill(
              label: LocaleKeys.tasks_clear.tr(),
              danger: true,
              onTap: onClear,
            ),
          ],
        ],
      ),
    );
  }
}
