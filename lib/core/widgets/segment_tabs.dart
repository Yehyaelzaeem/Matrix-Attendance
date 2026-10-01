import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';
import 'custom_tap_effect.dart';

class SegmentItem<T> {
  const SegmentItem(this.value, this.label, {this.count});

  final T value;
  final String label;
  final int? count;
}

class SegmentTabs<T> extends StatelessWidget {
  const SegmentTabs({
    super.key,
    required this.items,
    required this.selected,
    required this.onChanged,
    this.padding,
  });

  final List<SegmentItem<T>> items;
  final T selected;
  final ValueChanged<T> onChanged;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 6.w),
        itemBuilder: (_, i) {
          final item = items[i];
          final on = item.value == selected;
          return CustomTapEffect(
            onTap: () => onChanged(item.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: on
                    ? AppColors.navyColor.themeColor
                    : AppColors.cardColor.themeColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    item.label,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: on
                        ? Colors.white
                        : AppColors.textSecondaryColor.themeColor,
                  ),
                  if (item.count != null) ...[
                    SizedBox(width: 6.w),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: on
                            ? Colors.white.withValues(alpha: 0.18)
                            : AppColors.neutralSoftColor.themeColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: AppText(
                        '${item.count}',
                        numeric: true,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: on
                            ? Colors.white
                            : AppColors.textSecondaryColor.themeColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
