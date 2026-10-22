import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/task_model.dart';
import 'comment_bubble.dart';

class TaskCommentsThread extends StatelessWidget {
  const TaskCommentsThread({super.key, required this.task, required this.me});

  final TaskModel task;
  final int me;

  @override
  Widget build(BuildContext context) {
    final count = task.userCommentsCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          '${LocaleKeys.tasks_comments.tr()}${count > 0 ? ' ($count)' : ''}',
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: AppColors.textSecondaryColor.themeColor,
        ),
        SizedBox(height: 6.h),
        if (task.comments.isEmpty)
          AppText(LocaleKeys.tasks_noComments.tr(),
              fontSize: 11.5, color: AppColors.textSecondaryColor.themeColor)
        else
          for (final comment in task.comments)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child:
                  CommentBubble(comment: comment, isMine: comment.byId == me),
            ),
      ],
    );
  }
}
