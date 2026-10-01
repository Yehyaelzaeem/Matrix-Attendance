import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../projects/data/models/project_model.dart';
import '../../data/models/task_enums.dart';
import '../../data/models/task_model.dart';
import 'project_dot.dart';

class TaskHeaderChips extends StatelessWidget {
  const TaskHeaderChips({super.key, required this.task, required this.project});

  final TaskModel task;
  final ProjectModel? project;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.w,
      runSpacing: 6.h,
      children: [
        if (project != null)
          StatusChip(
              label: project!.name, leading: ProjectDot(color: project!.color)),
        StatusChip(label: '#${task.id}', numeric: true),
        if (task.isLate)
          StatusChip(
              label: LocaleKeys.tasks_lateBadge.tr(), tone: ChipTone.red),
        if (task.returned && task.status == TaskStatus.doing)
          StatusChip(
              label: LocaleKeys.tasks_returnedBadge.tr(), tone: ChipTone.red),
        if (task.returns > 0)
          StatusChip(
            label: LocaleKeys.tasks_returnsBadge
                .tr(namedArgs: {'n': '${task.returns}'}),
            tone: ChipTone.orange,
          ),
      ],
    );
  }
}
