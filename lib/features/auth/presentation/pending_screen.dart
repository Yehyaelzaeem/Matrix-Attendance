import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import '../logic/auth_cubit.dart';
import 'widgets/pending_hourglass.dart';
import 'widgets/pending_steps.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await context.read<AuthCubit>().logout();
    if (context.mounted) {
      context.pushNamedAndRemoveUntil(Routes.loginScreen,
          predicate: (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardColor.themeColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
            child: Column(
              children: [
                const PendingHourglass(),
                SizedBox(height: 16.h),
                AppText(LocaleKeys.auth_pendingTitle.tr(),
                    fontSize: 23, fontWeight: FontWeight.w800),
                SizedBox(height: 8.h),
                AppText(LocaleKeys.auth_pendingSubtitle.tr(),
                    fontSize: 14.5,
                    height: 1.9,
                    textAlign: TextAlign.center,
                    color: AppColors.textSecondaryColor.themeColor),
                SizedBox(height: 26.h),
                const PendingSteps(),
                SizedBox(height: 18.h),
                BlocConsumer<AuthCubit, AuthState>(
                  listenWhen: (_, s) => s is AuthSuccess && s.user.isActive,
                  listener: (context, _) => context.pushNamedAndRemoveUntil(
                      Routes.layoutScreen,
                      predicate: (_) => false),
                  builder: (context, state) => CustomButton(
                    title: LocaleKeys.auth_refreshStatus.tr(),
                    loading: state is AuthLoading,
                    onTap: () => context.read<AuthCubit>().refreshStatus(),
                  ),
                ),
                SizedBox(height: 8.h),
                CustomButton(
                  title: LocaleKeys.common_logout.tr(),
                  type: ButtonStyleType.plain,
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
