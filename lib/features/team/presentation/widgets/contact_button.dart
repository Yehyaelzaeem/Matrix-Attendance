import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

class ContactButton extends StatelessWidget {
  const ContactButton({
    super.key,
    required this.emoji,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Text(emoji, style: TextStyle(fontSize: 20.sp, height: 1)),
            SizedBox(height: 6.h),
            AppText(label,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: foreground,
                maxLines: 1),
          ],
        ),
      ),
    );
  }
}
