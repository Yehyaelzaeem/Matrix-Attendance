import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/dark_header.dart';
import '../../../auth/data/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final name = user?.name ?? '';
    return DarkHeader(
      topPadding: 18,
      bottomPadding: 70,
      child: Center(
        child: Column(
          children: [
            AppAvatar(
              name: name,
              size: 92,
              radius: 30,
              imagePath: user?.avatarPath,
              gradient: AppColors.primaryGradient,
              borderColor: Colors.white.withValues(alpha: 0.35),
              borderWidth: 3,
            ),
            SizedBox(height: 12.h),
            AppText(name,
                fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
            AppText(user?.jobTitle ?? '',
                fontSize: 13,
                textDirection: TextDirection.ltr,
                color: AppColors.headerTextColor.themeColor),
          ],
        ),
      ),
    );
  }
}
