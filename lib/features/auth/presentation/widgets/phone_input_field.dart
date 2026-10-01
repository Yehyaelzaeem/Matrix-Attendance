import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';

class PhoneInputField extends StatelessWidget {
  const PhoneInputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return CustomTextField(
      controller: controller,
      hint: hint,
      onChanged: onChanged,
      numeric: true,
      keyboardType: TextInputType.phone,
      maxLength: 11,
      textDirection: TextDirection.ltr,
      textAlign: isRtl ? TextAlign.right : TextAlign.left,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      prefixIcon: const Icon(Icons.smartphone_rounded),
      suffixIcon: Container(
        margin: EdgeInsetsDirectional.only(end: 14.w, top: 14.h, bottom: 14.h),
        padding: EdgeInsetsDirectional.only(start: 10.w),
        decoration: BoxDecoration(
          border: BorderDirectional(
            start: BorderSide(
                color: AppColors.dividerColor.themeColor, width: 1.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.ltr,
          children: [
            Text(AppEmojis.egypt, style: TextStyle(fontSize: 14.sp)),
            SizedBox(width: 4.w),
            AppText(AppConstants.countryCode,
                numeric: true, fontWeight: FontWeight.w600, fontSize: 14),
          ],
        ),
      ),
    );
  }
}
