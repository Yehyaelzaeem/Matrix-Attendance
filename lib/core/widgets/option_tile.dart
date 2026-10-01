import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.title,
    required this.onTap,
    this.leading,
    this.leadingWidget,
    this.subtitle,
    this.selected = false,
    this.titleDirection,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final String? leading;
  final Widget? leadingWidget;
  final bool selected;
  final VoidCallback onTap;
  final TextDirection? titleDirection;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primarySoftColor.themeColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            leadingWidget ??
                Container(
                  width: 38.r,
                  height: 38.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor.themeColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(leading ?? '', style: TextStyle(fontSize: 18.sp)),
                ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: AppText(
                      title,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      textDirection: titleDirection,
                      color: selected ? primary : null,
                    ),
                  ),
                  if (subtitle != null)
                    AppText(subtitle!,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryColor.themeColor),
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else
              AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: selected ? 1 : 0,
                child: Icon(Icons.check_rounded, color: primary, size: 20.sp),
              ),
          ],
        ),
      ),
    );
  }
}
