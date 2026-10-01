import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'grid_background.dart';

class DarkHeader extends StatelessWidget {
  const DarkHeader({
    super.key,
    required this.child,
    this.bottomPadding = 96,
    this.topPadding = 16,
    this.horizontalPadding = 20,
    this.radius = 34,
    this.gridOpacity = 0.5,
    this.includeSafeArea = true,
  });

  final Widget child;
  final double bottomPadding;
  final double topPadding;
  final double horizontalPadding;
  final double radius;
  final double gridOpacity;
  final bool includeSafeArea;

  @override
  Widget build(BuildContext context) {
    final safeTop = includeSafeArea ? MediaQuery.paddingOf(context).top : 0.0;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(radius.r)),
        child: DecoratedBox(
          decoration: const BoxDecoration(gradient: AppColors.darkGradient),
          child: Stack(
            children: [
              Positioned.fill(child: GridBackground(opacity: gridOpacity)),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  horizontalPadding.w,
                  safeTop + topPadding.h,
                  horizontalPadding.w,
                  bottomPadding.h,
                ),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
