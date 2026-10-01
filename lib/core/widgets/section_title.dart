import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.trailing,
    this.padding,
    this.fontSize = 17,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? EdgeInsetsDirectional.fromSTEB(20.w, 24.h, 20.w, 12.h),
      child: Row(
        children: [
          Expanded(
            child:
                AppText(title, fontSize: fontSize, fontWeight: FontWeight.w800),
          ),
          if (trailing != null) trailing!,
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              behavior: HitTestBehavior.opaque,
              child: AppText(
                actionLabel!,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor.themeColor,
              ),
            ),
        ],
      ),
    );
  }
}
