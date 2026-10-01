import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class MilestoneItem {
  const MilestoneItem({
    required this.title,
    required this.subtitle,
    required this.done,
    this.lateLabel,
  });

  final String title;
  final String subtitle;
  final bool done;
  final String? lateLabel;
}

class MilestoneTimeline extends StatelessWidget {
  const MilestoneTimeline({super.key, required this.items});

  final List<MilestoneItem> items;

  @override
  Widget build(BuildContext context) {
    final current = items.indexWhere((m) => !m.done);
    return Column(
      children: [
        for (var i = 0; i < items.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Container(
                      width: 28.r,
                      height: 28.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: items[i].done
                            ? AppColors.successColor.themeColor
                            : i == current
                                ? AppColors.warningColor.themeColor
                                : AppColors.idleStepColor.themeColor,
                        boxShadow: i == current
                            ? [
                                BoxShadow(
                                  color: AppColors.warningSoftColor.themeColor,
                                  spreadRadius: 5,
                                ),
                              ]
                            : null,
                      ),
                      child: items[i].done
                          ? Icon(Icons.check_rounded,
                              size: 14.sp, color: Colors.white)
                          : AppText('${i + 1}',
                              numeric: true,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                    ),
                    if (i < items.length - 1)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: items[i].done
                              ? AppColors.successColor.themeColor
                              : AppColors.dividerColor.themeColor,
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: i < items.length - 1 ? 16.h : 0, top: 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(items[i].title, fontWeight: FontWeight.w700),
                        Row(
                          children: [
                            AppText(items[i].subtitle,
                                fontSize: 12,
                                color: AppColors.textSecondaryColor.themeColor),
                            if (items[i].lateLabel != null)
                              AppText(' · ${items[i].lateLabel}',
                                  fontSize: 12,
                                  color: AppColors.errorColor.themeColor),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
