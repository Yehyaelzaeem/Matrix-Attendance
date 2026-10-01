import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class SummaryItem {
  const SummaryItem(this.label, this.value,
      {this.color, this.wide = false, this.background});

  final String label;
  final String value;
  final Color? color;
  final bool wide;
  final Color? background;
}

class SummaryGrid extends StatelessWidget {
  const SummaryGrid({super.key, required this.items});

  final List<SummaryItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: LayoutBuilder(
        builder: (_, constraints) {
          final half = (constraints.maxWidth - 10.w) / 2;
          return Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: [
              for (final item in items)
                Container(
                  width: item.wide ? constraints.maxWidth : half,
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: item.background ?? AppColors.surfaceColor.themeColor,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(item.label,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondaryColor.themeColor),
                      AppText(item.value,
                          numeric: true,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: item.color),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
