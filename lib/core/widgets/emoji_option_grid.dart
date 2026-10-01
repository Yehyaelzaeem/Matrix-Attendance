import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

class EmojiOption<T> {
  const EmojiOption(this.value, this.emoji, this.label);

  final T value;
  final String emoji;
  final String label;
}

class EmojiOptionGrid<T> extends StatelessWidget {
  const EmojiOptionGrid({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  final List<EmojiOption<T>> options;
  final T? selected;
  final ValueChanged<T> onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 9.h,
      crossAxisSpacing: 9.w,
      childAspectRatio: 1.15,
      children: [
        for (final option in options)
          GestureDetector(
            onTap: () => onSelect(option.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: option.value == selected
                    ? AppColors.primarySoftColor.themeColor
                    : AppColors.surfaceColor.themeColor,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: option.value == selected
                      ? AppColors.primaryColor.themeColor
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(option.emoji, style: TextStyle(fontSize: 22.sp)),
                  SizedBox(height: 6.h),
                  AppText(
                    option.label,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    color: option.value == selected
                        ? AppColors.primaryColor.themeColor
                        : null,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
