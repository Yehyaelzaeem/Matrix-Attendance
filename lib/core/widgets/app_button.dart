import 'package:app_base/core/utils/app_colors.dart';
import 'package:app_base/core/widgets/app_text.dart';
import 'package:app_base/core/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_constants.dart';
import 'custom_tap_effect.dart';

enum ButtonStyleType {
  primary,
  ghost,
  white,
  success,
  danger,
  softDanger,
  warning,
  plain
}

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget? child;
  final String? title;
  final Widget? icon;
  final Color? color;
  final Gradient? gradient;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final bool isOutlined;
  final bool loading;
  final bool enabled;
  final bool withShadow;
  final double radius;
  final ButtonStyleType type;

  const CustomButton({
    super.key,
    required this.onTap,
    this.child,
    this.title,
    this.icon,
    this.color,
    this.gradient,
    this.borderColor,
    this.textColor,
    this.width,
    this.height,
    this.fontSize,
    this.isOutlined = false,
    this.loading = false,
    this.enabled = true,
    this.withShadow = true,
    this.radius = AppConstants.buttonBorderRadius,
    this.type = ButtonStyleType.primary,
  });

  Gradient? get _gradient {
    if (color != null || isOutlined) return gradient;
    return gradient ??
        switch (type) {
          ButtonStyleType.primary => AppColors.primaryGradient,
          ButtonStyleType.danger => AppColors.dangerGradient,
          ButtonStyleType.warning => AppColors.warningGradient,
          _ => null,
        };
  }

  Color get _background {
    if (isOutlined) return Colors.transparent;
    if (color != null) return color!;
    return switch (type) {
      ButtonStyleType.ghost => AppColors.primarySoftColor.themeColor,
      ButtonStyleType.white => AppColors.cardColor.themeColor,
      ButtonStyleType.success => AppColors.successColor.themeColor,
      ButtonStyleType.softDanger => AppColors.errorSoftColor.themeColor,
      ButtonStyleType.plain => Colors.transparent,
      _ => AppColors.primaryColor.themeColor,
    };
  }

  Color get _foreground {
    if (textColor != null) return textColor!;
    if (isOutlined) return borderColor ?? AppColors.primaryColor.themeColor;
    return switch (type) {
      ButtonStyleType.ghost ||
      ButtonStyleType.white =>
        AppColors.primaryColor.themeColor,
      ButtonStyleType.softDanger => AppColors.errorColor.themeColor,
      ButtonStyleType.plain => AppColors.textSecondaryColor.themeColor,
      _ => Colors.white,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isActive = enabled && !loading && onTap != null;
    final shadowColor = (_gradient?.colors.first ?? _background);
    final hasShadow = withShadow &&
        (_gradient != null || type == ButtonStyleType.success) &&
        !isOutlined;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled ? 1 : 0.45,
      child: SizedBox(
        width: width ?? double.infinity,
        height: (height ?? AppConstants.buttonHeight).h,
        child: CustomTapEffect(
          isClickable: isActive,
          onTap: isActive ? onTap : null,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _gradient == null ? _background : null,
              gradient: _gradient,
              borderRadius: BorderRadius.circular(radius.r),
              border: isOutlined || borderColor != null
                  ? Border.all(
                      color: borderColor ?? AppColors.primaryColor.themeColor,
                      width: 1.5)
                  : null,
              boxShadow: hasShadow
                  ? [
                      BoxShadow(
                        color: shadowColor.withValues(alpha: 0.45),
                        blurRadius: 24,
                        spreadRadius: -10,
                        offset: const Offset(0, 12),
                      )
                    ]
                  : null,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Center(
                child: loading
                    ? CustomLoadingWidget(size: 22.h, color: _foreground)
                    : child ??
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (icon != null) ...[
                              IconTheme(
                                data: IconThemeData(
                                    color: _foreground, size: 20.sp),
                                child: icon!,
                              ),
                              SizedBox(width: 8.w),
                            ],
                            Flexible(
                              child: AppText(
                                title ?? '',
                                fontSize: fontSize ?? 16,
                                fontWeight: FontWeight.w700,
                                color: _foreground,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
