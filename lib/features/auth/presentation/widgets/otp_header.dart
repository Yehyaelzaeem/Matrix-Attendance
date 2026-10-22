import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/page_top_bar.dart';
import 'auth_top_background.dart';
import 'otp_art.dart';

class OtpHeader extends StatelessWidget {
  const OtpHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.paddingOf(context).top;
    return AuthTopBackground(
      height: safeTop + 274.h,
      children: [
        Positioned(
          top: safeTop + 34.h,
          left: 0,
          right: 0,
          child: const Center(child: OtpArt()),
        ),
        PositionedDirectional(
          top: safeTop + 10.h,
          start: 22.w,
          child: AppBackButton(onTap: onBack),
        ),
      ],
    );
  }
}
