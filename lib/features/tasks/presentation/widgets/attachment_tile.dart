import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/task_enums.dart';
import '../../data/models/task_model.dart';

class AttachmentTile extends StatelessWidget {
  const AttachmentTile({
    super.key,
    required this.attachment,
    required this.onTap,
    required this.onRemove,
  });

  final TaskAttachment attachment;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final navy = AppColors.navyColor.themeColor;
    final Widget content = switch (attachment.type) {
      AttachmentType.image when attachment.path != null =>
        Image.file(File(attachment.path!), fit: BoxFit.cover),
      AttachmentType.video => Container(
          color: navy.withValues(alpha: 0.85),
          alignment: Alignment.center,
          child: Container(
            width: 34.r,
            height: 34.r,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.play_arrow_rounded, color: navy, size: 20.sp),
          ),
        ),
      _ => Container(
          color: AppColors.errorSoftColor.themeColor,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText('${AppEmojis.document} ${LocaleKeys.common_pdf.tr()}',
                  numeric: true,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.errorColor.themeColor),
              AppText(attachment.name,
                  numeric: true,
                  fontSize: 9,
                  maxLines: 1,
                  color: AppColors.errorTextColor.themeColor),
            ],
          ),
        ),
    };
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            content,
            if (attachment.type == AttachmentType.video)
              PositionedDirectional(
                bottom: 4,
                end: 4,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: navy.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: AppText(LocaleKeys.common_video.tr(),
                      numeric: true,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            PositionedDirectional(
              top: 4,
              start: 4,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 24.r,
                  height: 24.r,
                  decoration: BoxDecoration(
                    color: navy.withValues(alpha: 0.72),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close_rounded,
                      size: 14.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
