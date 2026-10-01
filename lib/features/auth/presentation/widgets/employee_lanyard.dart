import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import 'employee_pass_card.dart';

class EmployeeLanyard extends StatefulWidget {
  const EmployeeLanyard({super.key, required this.ribbonHeight});

  final double ribbonHeight;

  @override
  State<EmployeeLanyard> createState() => _EmployeeLanyardState();
}

class _EmployeeLanyardState extends State<EmployeeLanyard>
    with TickerProviderStateMixin {
  late final AnimationController _drop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  late final AnimationController _swing = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _drop.forward();
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _swing.repeat();
    });
  }

  @override
  void dispose() {
    _drop.dispose();
    _swing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_drop, _swing]),
      builder: (_, child) {
        final drop = const Cubic(0.2, 1.35, 0.4, 1).transform(_drop.value);
        final angle = sin(_swing.value * 2 * pi) * 2.4 * pi / 180;
        return FractionalTranslation(
          translation: Offset(0, -1.2 * (1 - drop)),
          child: Transform.rotate(
            angle: angle,
            alignment: Alignment.topCenter,
            child: child,
          ),
        );
      },
      child: SizedBox(
        width: 210.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28.w,
              height: widget.ribbonHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.ribbonEdgeColor.themeColor,
                    AppColors.primaryColor.themeColor,
                    AppColors.ribbonEdgeColor.themeColor,
                  ],
                ),
              ),
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 6.h),
              clipBehavior: Clip.hardEdge,
              child: RotatedBox(
                quarterTurns: 1,
                child: AppText(
                  LocaleKeys.auth_ribbon.tr(),
                  numeric: true,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.2,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
            Container(
              width: 36.w,
              height: 18.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(5.r),
                  bottom: Radius.circular(10.r),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.clipLightColor.themeColor,
                    AppColors.clipDarkColor.themeColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        AppColors.navyColor.themeColor.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 14.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.clipSlotColor.themeColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -6.h),
              child: const EmployeePassCard(),
            ),
          ],
        ),
      ),
    );
  }
}
