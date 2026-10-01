import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

class AvatarPickerRow extends StatelessWidget {
  const AvatarPickerRow({super.key, required this.path, required this.onTap});

  final String? path;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasImage = path != null;
    final primary = AppColors.primaryColor.themeColor;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor.themeColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
              color: AppColors.dashedBorderColor.themeColor, width: 1.5),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 78.r,
              height: 78.r,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 72.r,
                    height: 72.r,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoftColor.themeColor,
                      borderRadius: BorderRadius.circular(22.r),
                      border: hasImage
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      image: hasImage
                          ? DecorationImage(
                              image: FileImage(File(path!)), fit: BoxFit.cover)
                          : null,
                      boxShadow: hasImage
                          ? [
                              BoxShadow(
                                color: primary.withValues(alpha: 0.7),
                                blurRadius: 22,
                                spreadRadius: -10,
                                offset: const Offset(0, 10),
                              ),
                            ]
                          : null,
                    ),
                    child: hasImage
                        ? null
                        : Icon(Icons.person_outline_rounded,
                            size: 30.sp, color: primary),
                  ),
                  PositionedDirectional(
                    bottom: 0,
                    end: 0,
                    child: Container(
                      width: 30.r,
                      height: 30.r,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Icon(Icons.add_rounded,
                          size: 14.sp, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(LocaleKeys.auth_photoTitle.tr(),
                      fontSize: 15, fontWeight: FontWeight.w700),
                  AppText(LocaleKeys.auth_photoSubtitle.tr(),
                      fontSize: 12.5,
                      height: 1.7,
                      color: AppColors.textSecondaryColor.themeColor),
                ],
              ),
            ),
            AppText(
              hasImage
                  ? LocaleKeys.auth_photoChange.tr()
                  : LocaleKeys.auth_photoUpload.tr(),
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: primary,
            ),
          ],
        ),
      ),
    );
  }
}
