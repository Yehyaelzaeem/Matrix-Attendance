import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/field_label.dart';
import '../../../../core/widgets/meter_bar.dart';
import '../../data/models/task_model.dart';
import 'task_due_label.dart';

class TaskTimeSection extends StatelessWidget {
  const TaskTimeSection({
    super.key,
    required this.task,
    required this.canLog,
    required this.onLog,
  });

  final TaskModel task;
  final bool canLog;
  final ValueChanged<double> onLog;

  @override
  Widget build(BuildContext context) {
    final pct =
        task.estimate == 0 ? 0 : (task.spent / task.estimate * 100).round();
    final over = task.spent > task.estimate;
    final logs = [
      (0.5, LocaleKeys.tasks_log30.tr()),
      (1.0, LocaleKeys.tasks_log1.tr()),
      (2.0, LocaleKeys.tasks_log2.tr()),
    ];
    return LabeledField(
      label: LocaleKeys.tasks_actualTime.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText(
                  LocaleKeys.tasks_loggedOf.tr(namedArgs: {
                    'spent': TaskDueLabel.hours(task.spent),
                    'est': TaskDueLabel.hours(task.estimate),
                  }),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondaryColor.themeColor,
                ),
              ),
              AppText('$pct%',
                  numeric: true,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: over ? AppColors.errorColor.themeColor : null),
            ],
          ),
          SizedBox(height: 6.h),
          MeterBar(
            value: pct / 100,
            color: over ? AppColors.errorColor.themeColor : null,
            gradient: over ? null : AppColors.primaryGradient,
          ),
          if (canLog) ...[
            SizedBox(height: 10.h),
            Row(
              children: [
                for (var i = 0; i < logs.length; i++) ...[
                  if (i > 0) SizedBox(width: 6.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onLog(logs[i].$1),
                      child: Container(
                        height: 38.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primarySoftColor.themeColor,
                          borderRadius: BorderRadius.circular(11.r),
                        ),
                        child: AppText(logs[i].$2,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor.themeColor),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
