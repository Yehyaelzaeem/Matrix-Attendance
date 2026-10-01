import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../projects/logic/projects_cubit.dart';
import '../../data/models/task_enums.dart';
import '../../data/models/task_model.dart';
import '../../logic/tasks_cubit.dart';
import 'project_dot.dart';
import 'task_details_sheet.dart';
import 'task_due_label.dart';

class TaskCard extends StatelessWidget {
  const TaskCard(
      {super.key,
      required this.task,
      this.index = 0,
      this.hideProject = false});

  final TaskModel task;
  final int index;
  final bool hideProject;

  @override
  Widget build(BuildContext context) {
    final tasks = getIt<TasksCubit>();
    final project = getIt<ProjectsCubit>().byId(task.projectId);
    final done = task.isDone;
    return FadeSlideIn(
      delay: Duration(milliseconds: index * 30),
      child: GestureDetector(
        onTap: () => TaskDetailsSheet.open(context, task.id),
        child: Container(
          padding: EdgeInsets.all(13.r),
          decoration: BoxDecoration(
            color: AppColors.cardColor.themeColor,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.navyColor.themeColor.withValues(alpha: 0.12),
                blurRadius: 18,
                spreadRadius: -16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (tasks.canManage)
                GestureDetector(
                  onTap: () => tasks.toggleDone(task.id),
                  child: Container(
                    width: 26.r,
                    height: 26.r,
                    margin: EdgeInsets.only(top: 1.h),
                    decoration: BoxDecoration(
                      color: done
                          ? AppColors.successColor.themeColor
                          : AppColors.cardColor.themeColor,
                      borderRadius: BorderRadius.circular(9.r),
                      border: Border.all(
                        color: done
                            ? AppColors.successColor.themeColor
                            : AppColors.dashedBorderColor.themeColor,
                        width: 2,
                      ),
                    ),
                    child: done
                        ? Icon(Icons.check_rounded,
                            size: 16.sp, color: Colors.white)
                        : null,
                  ),
                )
              else
                Container(
                  width: 26.r,
                  height: 26.r,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 1.h),
                  decoration: BoxDecoration(
                    color: task.status.softColor,
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  child: Text(task.status.emoji,
                      style: TextStyle(fontSize: 12.sp)),
                ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      task.title,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      height: 1.55,
                      decoration: done ? TextDecoration.lineThrough : null,
                      color:
                          done ? AppColors.textSecondaryColor.themeColor : null,
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 6.h,
                      children: [
                        if (!hideProject && project != null)
                          StatusChip(
                            small: true,
                            label: project.name,
                            leading: ProjectDot(color: project.color),
                          ),
                        StatusChip(
                            small: true,
                            label: task.status.label,
                            tone: task.status.tone),
                        if (task.priority == TaskPriority.high && !done)
                          StatusChip(
                              small: true,
                              label: LocaleKeys.tasks_highBadge.tr(),
                              tone: ChipTone.red),
                        StatusChip(
                          small: true,
                          label:
                              '${AppEmojis.calendar} ${TaskDueLabel.text(task)}',
                          tone: TaskDueLabel.tone(task),
                        ),
                        if (task.returned && task.status == TaskStatus.doing)
                          StatusChip(
                              small: true,
                              label: LocaleKeys.tasks_returnedBadge.tr(),
                              tone: ChipTone.red),
                        if (task.attachments.isNotEmpty)
                          StatusChip(
                              small: true,
                              label:
                                  '${AppEmojis.paperclip} ${task.attachments.length}'),
                        if (task.userCommentsCount > 0)
                          StatusChip(
                              small: true,
                              label:
                                  '${AppEmojis.speech} ${task.userCommentsCount}'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppAvatar(name: task.assignee, size: 30, radius: 10),
                  SizedBox(height: 6.h),
                  AppText(
                    LocaleKeys.tasks_hoursProgress.tr(namedArgs: {
                      'spent': TaskDueLabel.hours(task.spent),
                      'est': TaskDueLabel.hours(task.estimate),
                    }),
                    numeric: true,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondaryColor.themeColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
