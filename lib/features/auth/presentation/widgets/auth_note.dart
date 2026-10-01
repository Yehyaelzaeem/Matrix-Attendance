import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class AuthNote extends StatelessWidget {
  const AuthNote(this.text, {super.key, this.icon = Icons.shield_outlined});

  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.textSecondaryColor.themeColor;
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14.sp, color: muted),
            SizedBox(width: 6.w),
          ],
          Flexible(
            child: AppText(text,
                fontSize: 12, color: muted, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
