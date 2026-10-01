import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';

class HighlightedTitle extends StatelessWidget {
  const HighlightedTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    final pattern = RegExp(r'\[([^\]]+)\]');
    var cursor = 0;
    for (final match in pattern.allMatches(text)) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(color: AppColors.primaryColor.themeColor),
      ));
      cursor = match.end;
    }
    if (cursor < text.length) spans.add(TextSpan(text: text.substring(cursor)));
    return Text.rich(
      TextSpan(children: spans),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: AppFonts.familyFont,
        fontSize: 24.sp,
        fontWeight: FontWeight.w800,
        height: 1.5,
        color: AppColors.textPrimaryColor.themeColor,
      ),
    );
  }
}
