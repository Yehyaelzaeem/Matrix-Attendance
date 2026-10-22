import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/dark_header.dart';
import '../../../../core/widgets/icon_square_button.dart';
import '../../../auth/logic/auth_cubit.dart';
import '../../../decisions/logic/decisions_cubit.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, this.subtitle, this.title, this.trailing});

  final String? subtitle;
  final String? title;
  final Widget? trailing;

  static String greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return LocaleKeys.attendance_greetingMorning.tr();
    if (h < 17) return LocaleKeys.attendance_greetingAfternoon.tr();
    return LocaleKeys.attendance_greetingEvening.tr();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().currentUser;
    final name = user?.name ?? '';
    return DarkHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(
                name: name,
                size: 50,
                radius: 16,
                imagePath: user?.avatarPath,
                gradient: AppColors.primaryGradient,
                borderColor: Colors.white.withValues(alpha: 0.3),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(subtitle ?? greeting(),
                        fontSize: 13,
                        color: AppColors.headerTextColor.themeColor),
                    AppText(title ?? name,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        maxLines: 1),
                  ],
                ),
              ),
              trailing ??
                  BlocBuilder<DecisionsCubit, DecisionsState>(
                    builder: (_, state) => IconSquareButton(
                      icon: Icons.notifications_none_rounded,
                      background: Colors.white.withValues(alpha: 0.14),
                      color: Colors.white,
                      showDot:
                          state is DecisionsSuccess && state.unreadCount > 0,
                      dotBorderColor: AppColors.navySecondColor.themeColor,
                      onTap: () => context.pushNamed(Routes.decisionsScreen),
                    ),
                  ),
            ],
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 16.sp, color: AppColors.headerDateColor.themeColor),
              SizedBox(width: 8.w),
              AppText(DateHelper.fullDate(DateTime.now()),
                  fontSize: 13.5, color: AppColors.headerDateColor.themeColor),
            ],
          ),
        ],
      ),
    );
  }
}
