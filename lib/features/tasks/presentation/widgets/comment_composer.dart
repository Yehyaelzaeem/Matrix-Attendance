import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text_field.dart';

class CommentComposer extends StatelessWidget {
  const CommentComposer({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.onSend,
    this.hasError = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final VoidCallback onSend;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: CustomTextField(
              controller: controller,
              focusNode: focusNode,
              hint: hint,
              hasError: hasError,
              minLines: 1,
              maxLines: 4,
              height: 48,
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.themeColor
                        .withValues(alpha: 0.8),
                    blurRadius: 20,
                    spreadRadius: -10,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(Icons.send_rounded, color: Colors.white, size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }
}
