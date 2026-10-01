import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_text.dart';

class MemberStack extends StatelessWidget {
  const MemberStack({super.key, required this.names, this.max = 4});

  final List<String> names;
  final int max;

  @override
  Widget build(BuildContext context) {
    final shown = names.take(max).toList();
    final size = 28.r;
    final step = size - 7.r;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size + step * (shown.length - 1),
          height: size,
          child: Stack(
            children: [
              for (var i = 0; i < shown.length; i++)
                PositionedDirectional(
                  start: i * step,
                  child: AppAvatar(
                    name: shown[i],
                    size: 28,
                    radius: 9,
                    borderColor: AppColors.cardColor.themeColor,
                  ),
                ),
            ],
          ),
        ),
        if (names.length > max) ...[
          SizedBox(width: 6.w),
          AppText('+${names.length - max}',
              numeric: true,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondaryColor.themeColor),
        ],
      ],
    );
  }
}
