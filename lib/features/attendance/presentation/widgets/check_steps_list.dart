import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class CheckStepsList extends StatelessWidget {
  const CheckStepsList({super.key, required this.steps, required this.done});

  final List<String> steps;
  final int done;

  @override
  Widget build(BuildContext context) {
    final success = AppColors.successColor.themeColor;
    return Padding(
      padding: EdgeInsets.only(top: 18.h, bottom: 6.h),
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 9.h),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 24.r,
                    height: 24.r,
                    decoration: BoxDecoration(
                      color: i < done ? success : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: i < done
                            ? success
                            : AppColors.dividerColor.themeColor,
                        width: 2,
                      ),
                    ),
                    child: i < done
                        ? Icon(Icons.check_rounded,
                            size: 14.sp, color: Colors.white)
                        : null,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: AppText(
                      steps[i],
                      fontWeight: FontWeight.w600,
                      color: i < done
                          ? AppColors.textPrimaryColor.themeColor
                          : AppColors.textSecondaryColor.themeColor,
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
