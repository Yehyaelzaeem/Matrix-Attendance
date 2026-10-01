import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';
import 'custom_tap_effect.dart';

class ChoiceItem<T> {
  const ChoiceItem(this.value, this.label);

  final T value;
  final String label;
}

class ChoiceChipsPicker<T> extends StatelessWidget {
  const ChoiceChipsPicker({
    super.key,
    required this.items,
    required this.isSelected,
    required this.onTap,
  });

  final List<ChoiceItem<T>> items;
  final bool Function(T value) isSelected;
  final ValueChanged<T> onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: items.map((item) {
        final on = isSelected(item.value);
        return CustomTapEffect(
          onTap: () => onTap(item.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 36.h,
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            decoration: BoxDecoration(
              color: on
                  ? AppColors.primarySoftColor.themeColor
                  : AppColors.surfaceColor.themeColor,
              borderRadius: BorderRadius.circular(11.r),
              border: Border.all(
                color:
                    on ? AppColors.primaryColor.themeColor : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Center(
              widthFactor: 1,
              child: AppText(
                item.label,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: on
                    ? AppColors.primaryColor.themeColor
                    : AppColors.textSecondaryColor.themeColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
