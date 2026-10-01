import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../logic/app_tab.dart';

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.tab,
    required this.selected,
    required this.onTap,
    this.badge = 0,
  });

  final AppTab tab;
  final bool selected;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? AppColors.primaryColor.themeColor
        : AppColors.inactiveColor.themeColor;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: selected ? 1 : 0,
            child: Container(
              width: 26.w,
              height: 4.h,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(tab.icon, size: 24.sp, color: color),
                    if (badge > 0)
                      PositionedDirectional(
                        top: -5.h,
                        end: -10.w,
                        child: Container(
                          constraints: BoxConstraints(minWidth: 17.r),
                          height: 17.r,
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.errorColor.themeColor,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(
                                color: AppColors.cardColor.themeColor,
                                width: 2),
                          ),
                          child: AppText('$badge',
                              numeric: true,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                AppText(tab.label,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: color,
                    maxLines: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
