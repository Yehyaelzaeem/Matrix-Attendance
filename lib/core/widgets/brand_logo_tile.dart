import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_images.dart';

class BrandLogoTile extends StatelessWidget {
  const BrandLogoTile({
    super.key,
    this.size = 124,
    this.radius,
    this.padding,
    this.shadows,
  });

  final double size;
  final double? radius;
  final double? padding;
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      padding: EdgeInsets.all((padding ?? size * 0.13).r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular((radius ?? size * 0.29).r),
        boxShadow: shadows,
      ),
      child: Image.asset(AppImages.logoMark, fit: BoxFit.contain),
    );
  }
}
