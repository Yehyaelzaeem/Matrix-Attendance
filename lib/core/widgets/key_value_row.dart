import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

class KeyValueRow extends StatelessWidget {
  const KeyValueRow({
    super.key,
    required this.label,
    this.value,
    this.valueWidget,
    this.valueColor,
    this.numeric = false,
    this.showDivider = true,
  });

  final String label;
  final String? value;
  final Widget? valueWidget;
  final Color? valueColor;
  final bool numeric;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 13.h),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(color: AppColors.dividerColor.themeColor))
            : null,
      ),
      child: Row(
        children: [
          AppText(label,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryColor.themeColor),
          SizedBox(width: 12.w),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: valueWidget ??
                  AppText(
                    value ?? '',
                    fontWeight: FontWeight.w700,
                    numeric: numeric,
                    color: valueColor,
                    textAlign: TextAlign.end,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
