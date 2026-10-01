import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.badge});

  final String text;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Flexible(
              child: AppText(text, fontSize: 13, fontWeight: FontWeight.w700)),
          if (badge != null) ...[SizedBox(width: 6.w), badge!],
        ],
      ),
    );
  }
}

class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.child,
    this.badge,
    this.hint,
  });

  final String label;
  final Widget child;
  final Widget? badge;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FieldLabel(label, badge: badge),
          child,
          if (hint != null) ...[
            SizedBox(height: 6.h),
            AppText(hint!,
                fontSize: 11.5, color: AppColors.textSecondaryColor.themeColor),
          ],
        ],
      ),
    );
  }
}
