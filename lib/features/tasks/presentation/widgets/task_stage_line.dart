import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/task_enums.dart';

class TaskStageLine extends StatelessWidget {
  const TaskStageLine({super.key, required this.status});

  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    final current = status.index;
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h, top: 4.h),
      child: Row(
        children: [
          for (final s in TaskStatus.values) ...[
            if (s.index > 0) SizedBox(width: 4.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 2.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: s.index < current
                      ? AppColors.successSoftColor.themeColor
                      : s.index == current
                          ? AppColors.navyColor.themeColor
                          : AppColors.surfaceColor.themeColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: AppText(
                  '${s.emoji} ${s.label}',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  color: s.index < current
                      ? AppColors.successColor.themeColor
                      : s.index == current
                          ? Colors.white
                          : AppColors.textSecondaryColor.themeColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
