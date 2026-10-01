import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_constants.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? height;
  final TextOverflow? overflow;
  final bool numeric;
  final double? letterSpacing;
  final TextDecoration? decoration;
  final TextDirection? textDirection;

  const AppText(
    this.text, {
    super.key,
    this.fontSize,
    this.height,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.numeric = false,
    this.letterSpacing,
    this.decoration,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      textDirection: textDirection ?? (numeric ? TextDirection.ltr : null),
      style: TextStyle(
        height: height,
        fontFamily: numeric ? AppFonts.numbersFont : AppFonts.familyFont,
        fontFeatures: numeric ? const [FontFeature.tabularFigures()] : null,
        fontSize: (fontSize ?? 14).sp,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: color ?? AppColors.textPrimaryColor.themeColor,
        letterSpacing: letterSpacing,
        decoration: decoration,
        decorationColor: color ?? AppColors.textSecondaryColor.themeColor,
      ),
    );
  }
}
