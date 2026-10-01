import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class ProgressStatLine extends StatelessWidget {
  const ProgressStatLine({super.key, required this.label, required this.bar});

  final String label;
  final Widget bar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Row(
        children: [
          AppText(label,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondaryColor.themeColor),
          SizedBox(width: 10.w),
          Expanded(child: bar),
        ],
      ),
    );
  }
}
