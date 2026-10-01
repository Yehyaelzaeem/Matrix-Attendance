import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../projects/logic/projects_cubit.dart';
import '../../data/models/task_enums.dart';
import '../../data/models/task_model.dart';
import '../../logic/tasks_cubit.dart';
import 'attachments_field.dart';
import 'comment_composer.dart';
import 'task_comments_thread.dart';
import 'task_editor_fields.dart';
import 'task_flow_actions.dart';
import 'task_header_chips.dart';
import 'task_readonly_grid.dart';
import 'task_stage_line.dart';
import 'task_time_section.dart';

class TaskDetailsSheet extends StatefulWidget {
  const TaskDetailsSheet({super.key, required this.taskId});

  final String taskId;

  static Future<void> open(BuildContext context, String taskId) =>
      AppSheet.show(context, child: TaskDetailsSheet(taskId: taskId));

  @override
  State<TaskDetailsSheet> createState() => _TaskDetailsSheetState();
}

class _TaskDetailsSheetState extends State<TaskDetailsSheet> {
  final _cubit = getIt<TasksCubit>();
  final _comment = TextEditingController();
  final _commentFocus = FocusNode();
  final _editorKey = GlobalKey<TaskEditorFieldsState>();
  bool _commentError = false;

  @override
  void dispose() {
    _comment.dispose();
    _commentFocus.dispose();
    super.dispose();
  }

  void _send(TaskModel task) {
    final text = _comment.text.trim();
    if (text.isEmpty) {
      AppOverlay.showError(LocaleKeys.tasks_writeCommentFirst.tr());
      return;
    }
    _cubit.addComment(task.id, text);
    _comment.clear();
    setState(() => _commentError = false);
  }

  void _return(TaskModel task) {
    final text = _comment.text.trim();
    if (text.isEmpty) {
      setState(() => _commentError = true);
      _commentFocus.requestFocus();
      AppOverlay.showError(LocaleKeys.tasks_writeReturnReason.tr());
      return;
    }
    _cubit.returnTask(task.id, text);
    _comment.clear();
    setState(() => _commentError = false);
  }

  Future<void> _save() async {
    final values = _editorKey.currentState?.values;
    if (values == null) return;
    await _cubit.saveEdits(
      widget.taskId,
      status: values.status,
      assignee: values.assignee,
      priority: values.priority,
      due: values.due,
      estimate: values.estimate,
    );
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    Navigator.of(context).pop();
    await _cubit.delete(widget.taskId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      bloc: _cubit,
      builder: (context, _) {
        final task = _cubit.byId(widget.taskId);
        if (task == null) return const SizedBox.shrink();
        final project = getIt<ProjectsCubit>().byId(task.projectId);
        final manage = _cubit.canManage;
        final mine = task.assignee == _cubit.me;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TaskHeaderChips(task: task, project: project),
            SizedBox(height: 8.h),
            AppText(task.title, fontSize: 18, fontWeight: FontWeight.w800),
            if (task.description.isNotEmpty) ...[
              SizedBox(height: 6.h),
              AppText(task.description,
                  fontSize: 13.5,
                  height: 1.8,
                  color: AppColors.textBodyColor.themeColor),
            ],
            SizedBox(height: 12.h),
            TaskStageLine(status: task.status),
            TaskFlowActions(
              task: task,
              canManage: manage,
              isMine: mine,
              onMove: (status) => _cubit.move(task.id, status),
              onReturn: () => _return(task),
            ),
            if (manage)
              TaskEditorFields(
                key: _editorKey,
                task: task,
                team: project?.team.map((m) => m.name).toList() ??
                    [task.assignee],
              )
            else
              TaskReadonlyGrid(task: task),
            TaskTimeSection(
              task: task,
              canLog: mine && !task.isDone,
              onLog: (h) => _cubit.logTime(task.id, h),
            ),
            AttachmentsField(
              attachments: task.attachments,
              onAdd: (files) => _cubit.addAttachments(task.id, files),
              onRemove: (i) => _cubit.removeAttachment(task.id, i),
            ),
            if (manage)
              CustomButton(
                  title: LocaleKeys.common_saveChanges.tr(), onTap: _save),
            SizedBox(height: 20.h),
            TaskCommentsThread(task: task, me: _cubit.me),
            CommentComposer(
              controller: _comment,
              focusNode: _commentFocus,
              hasError: _commentError,
              hint: manage &&
                      (task.status == TaskStatus.review ||
                          task.status == TaskStatus.test)
                  ? LocaleKeys.tasks_commentOrReturnHint.tr()
                  : LocaleKeys.tasks_commentHint.tr(),
              onSend: () => _send(task),
            ),
            if (_cubit.isAdmin) ...[
              SizedBox(height: 10.h),
              CustomButton(
                title: LocaleKeys.tasks_deleteTask.tr(),
                type: ButtonStyleType.plain,
                textColor: AppColors.errorColor.themeColor,
                onTap: _delete,
              ),
            ],
          ],
        );
      },
    );
  }
}
