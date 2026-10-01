import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/grid_background.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../auth/logic/auth_cubit.dart';

class AdminMeCard extends StatelessWidget {
  const AdminMeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().currentUser;
    return GestureDetector(
      onTap: () => context.pushNamed(Routes.adminProfileScreen),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 18.w),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: AppColors.darkGradient,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: GridBackground(opacity: 0.45)),
            Padding(
              padding: EdgeInsets.all(18.r),
              child: Row(
                children: [
                  AppAvatar(
                    name: user?.name ?? '',
                    size: 58,
                    radius: 18,
                    gradient: AppColors.primaryGradient,
                    borderColor: Colors.white.withValues(alpha: 0.3),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(user?.name ?? '',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                        AppText(user?.jobTitle ?? '',
                            fontSize: 12.5,
                            textDirection: TextDirection.ltr,
                            color: AppColors.headerTextColor.themeColor),
                        SizedBox(height: 8.h),
                        StatusChip(
                            label: LocaleKeys.admin_fullAccess.tr(),
                            tone: ChipTone.glass),
                      ],
                    ),
                  ),
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.white, size: 16.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
