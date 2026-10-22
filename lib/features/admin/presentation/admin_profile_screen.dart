import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/dark_header.dart';
import '../../../core/widgets/info_block.dart';
import '../../../core/widgets/key_value_row.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../../../core/widgets/status_chip.dart';
import '../../auth/logic/auth_cubit.dart';
import '../../projects/logic/projects_cubit.dart';
import 'widgets/edit_admin_profile_sheet.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().currentUser;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: ListView(
        padding: EdgeInsets.only(bottom: 30.h),
        children: [
          PageTopBar(title: LocaleKeys.admin_myAccount.tr(), showBack: true),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: DarkHeader(
              includeSafeArea: false,
              radius: 24,
              topPadding: 26,
              bottomPadding: 24,
              child: Center(
                child: Column(
                  children: [
                    AppAvatar(
                      name: user?.name ?? '',
                      size: 92,
                      radius: 30,
                      gradient: AppColors.primaryGradient,
                      borderColor: Colors.white.withValues(alpha: 0.35),
                      borderWidth: 3,
                    ),
                    SizedBox(height: 12.h),
                    AppText(user?.name ?? '',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                    AppText(user?.jobTitle ?? '',
                        fontSize: 13,
                        textDirection: TextDirection.ltr,
                        color: AppColors.headerTextColor.themeColor),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          if (user != null)
            InfoBlock(
              child: Column(
                children: [
                  KeyValueRow(
                    label: LocaleKeys.admin_role.tr(),
                    valueWidget: StatusChip(
                        label: '${user.role.emoji} ${user.role.label}',
                        tone: user.role.tone),
                  ),
                  KeyValueRow(
                    label: LocaleKeys.admin_phone.tr(),
                    value: Validators.internationalPhone(user.phone),
                    numeric: true,
                  ),
                  KeyValueRow(
                    label: LocaleKeys.admin_email.tr(),
                    value: user.email ?? LocaleKeys.common_dash.tr(),
                    numeric: true,
                  ),
                  KeyValueRow(
                    label: LocaleKeys.admin_followedProjects.tr(),
                    value: '${context.watch<ProjectsCubit>().projects.length}',
                    numeric: true,
                  ),
                  KeyValueRow(
                    label: LocaleKeys.admin_lastLogin.tr(),
                    value: LocaleKeys.common_today.tr(),
                    showDivider: false,
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: CustomButton(
              title: LocaleKeys.admin_editProfile.tr(),
              onTap: () =>
                  AppSheet.show(context, child: const EditAdminProfileSheet()),
            ),
          ),
        ],
      ),
    );
  }
}
