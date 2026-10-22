import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/task_model.dart';
import 'task_due_label.dart';

class TaskReadonlyGrid extends StatelessWidget {
  const TaskReadonlyGrid({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    final items = [
      (LocaleKeys.tasks_assignee.tr(), task.assignee, false),
      (LocaleKeys.tasks_priority.tr(), task.priority.label, false),
      (
        LocaleKeys.tasks_dueDate.tr(),
        DateHelper.dayMonthOrNotYet(task.due),
        false
      ),
      (
        LocaleKeys.tasks_estimateShort.tr(),
        LocaleKeys.common_hourCount
            .tr(namedArgs: {'n': TaskDueLabel.hours(task.estimate)}),
        true
      ),
    ];
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: LayoutBuilder(
        builder: (_, c) => Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            for (final item in items)
              Container(
                width: (c.maxWidth - 8.w) / 2,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor.themeColor,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(item.$1,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondaryColor.themeColor),
                    AppText(item.$2,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        maxLines: 1),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
