import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/section_title.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../data/models/task_enums.dart';
import '../../data/models/task_model.dart';
import 'task_card.dart';

class TaskGroupSection extends StatelessWidget {
  const TaskGroupSection({
    super.key,
    required this.status,
    required this.title,
    required this.tasks,
    this.hideProject = false,
  });

  final TaskStatus status;
  final String title;
  final List<TaskModel> tasks;
  final bool hideProject;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          title: '${status.emoji} $title',
          fontSize: 15,
          padding: EdgeInsetsDirectional.fromSTEB(20.w, 10.h, 20.w, 8.h),
          trailing: StatusChip(
              small: true,
              label: '${tasks.length}',
              tone: status.tone,
              numeric: true),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              for (var i = 0; i < tasks.length; i++)
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: TaskCard(
                      task: tasks[i], index: i, hideProject: hideProject),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
