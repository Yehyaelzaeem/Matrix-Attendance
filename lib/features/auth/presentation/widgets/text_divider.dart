import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class TextDivider extends StatelessWidget {
  const TextDivider(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Container(height: 1, color: AppColors.dividerColor.themeColor),
    );
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      child: Row(
        children: [
          line,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: AppText(label,
                fontSize: 13, color: AppColors.textSecondaryColor.themeColor),
          ),
          line,
        ],
      ),
    );
  }
}
