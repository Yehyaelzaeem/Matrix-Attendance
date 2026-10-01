import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

class SegmentedToggle<T> extends StatelessWidget {
  const SegmentedToggle({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<(T, String)> options;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: options.map((option) {
          final on = option.$1 == selected;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(option.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 38.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      on ? AppColors.cardColor.themeColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: on
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 10,
                            spreadRadius: -6,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: AppText(
                  option.$2,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  maxLines: 1,
                  color: on
                      ? AppColors.primaryColor.themeColor
                      : AppColors.textSecondaryColor.themeColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
