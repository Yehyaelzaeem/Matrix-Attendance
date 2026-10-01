import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_text.dart';

class ProjectLogo extends StatelessWidget {
  const ProjectLogo({
    super.key,
    required this.label,
    required this.color,
    this.size = 46,
    this.glass = false,
  });

  final String label;
  final Color color;
  final double size;
  final bool glass;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: glass ? Colors.white.withValues(alpha: 0.18) : color,
        borderRadius: BorderRadius.circular((size * 0.33).r),
        border: glass
            ? Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5)
            : null,
      ),
      child: AppText(label,
          numeric: true,
          fontSize: size * 0.35,
          fontWeight: FontWeight.w700,
          color: Colors.white),
    );
  }
}
