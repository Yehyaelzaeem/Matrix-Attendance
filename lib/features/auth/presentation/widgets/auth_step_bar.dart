import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/page_top_bar.dart';

class AuthStepBar extends StatelessWidget {
  const AuthStepBar({
    super.key,
    required this.label,
    required this.step,
    required this.total,
    required this.onBack,
    this.showStepper = true,
    this.progress,
  });

  final String label;
  final int step;
  final int total;
  final VoidCallback onBack;
  final bool showStepper;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.w, safeTop + 14.h, 24.w, 6.h),
      child: Row(
        children: [
          AppBackButton(onTap: onBack),
          SizedBox(width: 14.w),
          if (showStepper)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText(label,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondaryColor.themeColor),
                      ),
                      AppText('$step / $total',
                          numeric: true,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor.themeColor),
                    ],
                  ),
                  SizedBox(height: 7.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 6.h,
                      color: AppColors.trackColor.themeColor,
                      alignment: AlignmentDirectional.centerStart,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(
                            begin: (step - 1) / total,
                            end: progress ?? step / total),
                        duration: const Duration(milliseconds: 700),
                        curve: const Cubic(0.2, 0.8, 0.2, 1),
                        builder: (_, v, __) => FractionallySizedBox(
                          widthFactor: v,
                          heightFactor: 1,
                          child: const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
