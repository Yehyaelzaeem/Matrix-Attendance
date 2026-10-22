import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import '../logic/auth_cubit.dart';
import 'widgets/otp_header.dart';
import 'widgets/otp_input.dart';
import 'widgets/otp_resend_timer.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _code = '';
  late final AuthCubit _cubit = context.read<AuthCubit>();
  late final String _phone =
      _cubit.state is AuthOtpSent ? (_cubit.state as AuthOtpSent).phone : '';

  void _verify(String code) {
    if (code.length != AppConstants.otpLength || _cubit.state is AuthLoading) {
      return;
    }
    _cubit.verifyOtp(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardColor.themeColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OtpHeader(onBack: () => context.pop()),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24.w, 6.h, 24.w, 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppText(LocaleKeys.auth_otpTitle.tr(),
                      fontSize: 28, fontWeight: FontWeight.w800),
                  SizedBox(height: 4.h),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6.w,
                    children: [
                      AppText(LocaleKeys.auth_otpSubtitle.tr(),
                          fontSize: 14.5,
                          height: 1.8,
                          color: AppColors.textSecondaryColor.themeColor),
                      AppText(Validators.maskedPhone(_phone),
                          numeric: true,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: AppText(LocaleKeys.auth_editNumber.tr(),
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryColor.themeColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 22.h),
                  Container(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.w, 22.h, 16.w, 18.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.r),
                      border: Border.all(
                          color: AppColors.dividerColor.themeColor, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OtpInput(
                          onChanged: (v) => setState(() => _code = v),
                          onCompleted: _verify,
                        ),
                        SizedBox(height: 22.h),
                        BlocConsumer<AuthCubit, AuthState>(
                          listenWhen: (_, s) => s is AuthSuccess,
                          listener: (context, _) =>
                              context.pushNamedAndRemoveUntil(
                            Routes.layoutScreen,
                            predicate: (_) => false,
                          ),
                          builder: (context, state) => CustomButton(
                            title: LocaleKeys.auth_verify.tr(),
                            enabled: _code.length == AppConstants.otpLength,
                            loading: state is AuthLoading,
                            onTap: () => _verify(_code),
                          ),
                        ),
                        OtpResendTimer(onResend: _cubit.resendOtp),
                      ],
                    ),
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
