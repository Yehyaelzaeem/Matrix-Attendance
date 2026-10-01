import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

class AppSheet extends StatelessWidget {
  const AppSheet({
    super.key,
    required this.child,
    this.title,
    this.scrollable = true,
    this.fullHeight = false,
  });

  final Widget child;
  final String? title;
  final bool scrollable;
  final bool fullHeight;

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    bool scrollable = true,
    bool fullHeight = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.navyColor.themeColor.withValues(alpha: 0.45),
      builder: (_) => AppSheet(
        title: title,
        scrollable: scrollable,
        fullHeight: fullHeight,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          AppText(title!, fontSize: 18, fontWeight: FontWeight.w800),
          SizedBox(height: 14.h),
        ],
        if (fullHeight) Expanded(child: child) else child,
      ],
    );
    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: media.size.height * 0.88),
        height: fullHeight ? media.size.height * 0.78 : null,
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        padding: EdgeInsetsDirectional.fromSTEB(
            20.w, 10.h, 20.w, 20.h + media.padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44.w,
                height: 5.h,
                margin: EdgeInsets.only(bottom: 14.h),
                decoration: BoxDecoration(
                  color: AppColors.dividerColor.themeColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            if (fullHeight)
              Expanded(child: content)
            else
              Flexible(
                child: scrollable
                    ? SingleChildScrollView(child: content)
                    : content,
              ),
          ],
        ),
      ),
    );
  }
}
