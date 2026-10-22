import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../tasks/data/models/task_enums.dart';
import '../../../tasks/logic/tasks_cubit.dart';
import '../../../tasks/presentation/widgets/task_group_section.dart';

class ProjectTasksTab extends StatelessWidget {
  const ProjectTasksTab({super.key, required this.projectId});

  final int projectId;

  @override
  Widget build(BuildContext context) {
    final tasks = context
        .watch<TasksCubit>()
        .tasks
        .where((t) => t.projectId == projectId)
        .toList();
    if (tasks.isEmpty) {
      return AppEmpty(message: LocaleKeys.tasks_emptyProject.tr());
    }
    const order = [
      TaskStatus.doing,
      TaskStatus.review,
      TaskStatus.test,
      TaskStatus.todo,
      TaskStatus.done,
    ];
    return Column(
      children: [
        for (final status in order)
          TaskGroupSection(
            status: status,
            title: status.label,
            hideProject: true,
            tasks: tasks.where((t) => t.status == status).toList()
              ..sort((a, b) => a.dueOrFar.compareTo(b.dueOrFar)),
          ),
      ],
    );
  }
}
