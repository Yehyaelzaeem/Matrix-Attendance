import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'auth_top_background.dart';
import 'employee_lanyard.dart';

class AuthBadgeHeader extends StatelessWidget {
  const AuthBadgeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.paddingOf(context).top;
    return AuthTopBackground(
      height: safeTop + 312.h,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(child: EmployeeLanyard(ribbonHeight: safeTop + 64.h)),
        ),
      ],
    );
  }
}
