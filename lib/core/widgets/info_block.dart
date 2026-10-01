import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

class InfoBlock extends StatelessWidget {
  const InfoBlock({
    super.key,
    required this.child,
    this.title,
    this.trailing,
    this.margin,
  });

  final String? title;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsetsDirectional.fromSTEB(18.w, 0, 18.w, 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null || trailing != null) ...[
            Row(
              children: [
                if (title != null)
                  Expanded(
                    child: AppText(title!,
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                if (trailing != null) trailing!,
              ],
            ),
            SizedBox(height: 10.h),
          ],
          child,
        ],
      ),
    );
  }
}
