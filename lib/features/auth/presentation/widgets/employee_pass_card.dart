import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/brand_logo_tile.dart';
import '../../../../core/widgets/grid_background.dart';
import 'badge_barcode.dart';

class EmployeePassCard extends StatelessWidget {
  const EmployeePassCard({super.key});

  @override
  Widget build(BuildContext context) {
    final line = AppColors.primarySoftColor.themeColor;
    return Container(
      width: 204.w,
      padding: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.passBorderColor.themeColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.themeColor.withValues(alpha: 0.55),
            blurRadius: 50,
            spreadRadius: -26,
            offset: const Offset(0, 34),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 54.h,
            width: double.infinity,
            child: DecoratedBox(
              decoration: const BoxDecoration(gradient: AppColors.darkGradient),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: GridPainter(
                        cell: 12,
                        shift: 0,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 10.h),
                      width: 46.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: AppColors.passSlotColor.themeColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, -30.h),
            child: BrandLogoTile(
              size: 64,
              radius: 19,
              padding: 11,
              shadows: [
                BoxShadow(
                  color: AppColors.navyColor.themeColor.withValues(alpha: 0.45),
                  blurRadius: 20,
                  spreadRadius: -10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: Offset(0, -22.h),
            child: Column(
              children: [
                AppText(
                  LocaleKeys.app_company.tr(),
                  numeric: true,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryColor.light,
                ),
                SizedBox(height: 3.h),
                AppText(
                  LocaleKeys.auth_passLabel.tr(),
                  numeric: true,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.6,
                  color: AppColors.textSecondaryColor.light,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 13.h, 18.w, 11.h),
                  child: Row(
                    children: [
                      Container(
                        width: 38.r,
                        height: 38.r,
                        decoration: BoxDecoration(
                          color: line,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(Icons.person_outline_rounded,
                            size: 20.sp,
                            color: AppColors.primaryColor.themeColor),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 7.h,
                              decoration: BoxDecoration(
                                color: AppColors.passLineColor.themeColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            FractionallySizedBox(
                              widthFactor: 0.62,
                              child: Container(
                                height: 7.h,
                                decoration: BoxDecoration(
                                  color: AppColors.passLineSoftColor.themeColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: const BadgeBarcode(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
