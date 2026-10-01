import 'package:app_base/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.fillColor,
    this.hasError = false,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.maxLength,
    this.focusNode,
    this.height,
    this.numeric = false,
  });

  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final int? minLines;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color? fillColor;
  final bool hasError;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final FocusNode? focusNode;
  final double? height;
  final bool numeric;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppConstants.defaultBorderRadius.r);
    final border = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(
        color: hasError
            ? AppColors.errorColor.themeColor
            : AppColors.dividerColor.themeColor,
        width: 1.5,
      ),
    );
    final isMultiline = maxLines > 1 || (minLines ?? 1) > 1;
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      onChanged: onChanged,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      focusNode: focusNode,
      textDirection: textDirection,
      textAlign: textAlign,
      inputFormatters: [
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
        ...?inputFormatters,
      ],
      cursorColor: AppColors.primaryColor.themeColor,
      style: TextStyle(
        fontFamily: numeric ? AppFonts.numbersFont : AppFonts.familyFont,
        fontWeight: FontWeight.w600,
        fontSize: 15.sp,
        height: isMultiline ? 1.7 : null,
        color: AppColors.textPrimaryColor.themeColor,
      ),
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        hintTextDirection: textDirection,
        hintStyle: TextStyle(
          fontFamily: AppFonts.familyFont,
          fontWeight: FontWeight.w500,
          fontSize: 15.sp,
          color: AppColors.hintColor.themeColor,
        ),
        prefixIcon: prefixIcon == null
            ? null
            : IconTheme(
                data: IconThemeData(
                    color: AppColors.textSecondaryColor.themeColor,
                    size: 20.sp),
                child: prefixIcon!,
              ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: fillColor ?? AppColors.cardColor.themeColor,
        border: border,
        enabledBorder: border,
        disabledBorder: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide:
              BorderSide(color: AppColors.primaryColor.themeColor, width: 1.5),
        ),
        errorBorder: border.copyWith(
            borderSide:
                BorderSide(color: AppColors.errorColor.themeColor, width: 1.5)),
        focusedErrorBorder: border.copyWith(
            borderSide:
                BorderSide(color: AppColors.errorColor.themeColor, width: 1.5)),
        contentPadding: EdgeInsetsDirectional.symmetric(
          horizontal: 16.w,
          vertical: isMultiline ? 14.h : ((height ?? 56) - 22).h / 2,
        ),
      ),
    );
  }
}
