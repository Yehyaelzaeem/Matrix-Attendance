import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

class PageTopBar extends StatelessWidget {
  const PageTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.showBack = false,
    this.onBack,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.paddingOf(context).top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(showBack ? 18.w : 20.w,
            safeTop + (showBack ? 10 : 14).h, 20.w, 12.h),
        child: Row(
          children: [
            if (showBack) ...[
              AppBackButton(
                  onTap: onBack ?? () => Navigator.of(context).maybePop()),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(title,
                      fontSize: showBack ? 19 : 20,
                      fontWeight: FontWeight.w800,
                      maxLines: 1),
                  if (subtitle != null)
                    AppText(subtitle!,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        color: AppColors.textSecondaryColor.themeColor),
                ],
              ),
            ),
            if (trailing != null) ...[SizedBox(width: 10.w), trailing!],
          ],
        ),
      ),
    );
  }
}

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(14.r),
          border:
              Border.all(color: AppColors.dividerColor.themeColor, width: 1.5),
        ),
        child: Icon(Icons.arrow_back_ios_new_rounded,
            size: 18.sp, color: AppColors.textPrimaryColor.themeColor),
      ),
    );
  }
}
