import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/info_box.dart';
import '../../data/models/task_enums.dart';
import '../../data/models/task_model.dart';

class TaskFlowActions extends StatelessWidget {
  const TaskFlowActions({
    super.key,
    required this.task,
    required this.canManage,
    required this.isMine,
    required this.onMove,
    required this.onReturn,
  });

  final TaskModel task;
  final bool canManage;
  final bool isMine;
  final ValueChanged<TaskStatus> onMove;
  final VoidCallback onReturn;

  Widget _button(String title, Color bg, Color fg, VoidCallback onTap) =>
      CustomButton(
        title: title,
        height: 48,
        radius: 14,
        fontSize: 14,
        color: bg,
        textColor: fg,
        withShadow: false,
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) {
    final Widget? content;
    if (canManage) {
      final returnBtn = _button(
          LocaleKeys.tasks_return.tr(),
          AppColors.errorSoftColor.themeColor,
          AppColors.errorColor.themeColor,
          onReturn);
      final doneBtn = _button(
          LocaleKeys.tasks_markDone.tr(),
          AppColors.successColor.themeColor,
          Colors.white,
          () => onMove(TaskStatus.done));
      content = switch (task.status) {
        TaskStatus.review => Column(
            children: [
              Row(children: [
                Expanded(child: returnBtn),
                SizedBox(width: 8.w),
                Expanded(
                  child: _button(
                      LocaleKeys.tasks_toTest.tr(),
                      AppColors.orangeSoftColor.themeColor,
                      AppColors.orangeTextColor.themeColor,
                      () => onMove(TaskStatus.test)),
                ),
              ]),
              SizedBox(height: 8.h),
              doneBtn,
            ],
          ),
        TaskStatus.test => Row(children: [
            Expanded(child: returnBtn),
            SizedBox(width: 8.w),
            Expanded(child: doneBtn),
          ]),
        _ => null,
      };
    } else if (isMine) {
      content = switch (task.status) {
        TaskStatus.todo => CustomButton(
            title: LocaleKeys.tasks_start.tr(),
            onTap: () => onMove(TaskStatus.doing)),
        TaskStatus.doing => CustomButton(
            title: LocaleKeys.tasks_submitReview.tr(),
            onTap: () => onMove(TaskStatus.review)),
        TaskStatus.review => InfoBox(
            emoji: AppEmojis.hourglass,
            text: LocaleKeys.tasks_withReviewerInfo.tr()),
        TaskStatus.test => InfoBox(
            emoji: AppEmojis.hourglass, text: LocaleKeys.tasks_inTestInfo.tr()),
        TaskStatus.done => InfoBox(
            emoji: AppEmojis.party,
            text: LocaleKeys.tasks_closedInfo.tr(),
            tone: InfoTone.success),
      };
    } else {
      content = null;
    }
    if (content == null) return const SizedBox.shrink();
    return Padding(padding: EdgeInsets.only(bottom: 16.h), child: content);
  }
}
