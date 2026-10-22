import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/field_label.dart';
import '../logic/auth_cubit.dart';
import 'widgets/auth_badge_header.dart';
import 'widgets/auth_eyebrow.dart';
import 'widgets/auth_note.dart';
import 'widgets/phone_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isValid = Validators.isValidPhone(_phone.text);
    return Scaffold(
      backgroundColor: AppColors.cardColor.themeColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthBadgeHeader(),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24.w, 6.h, 24.w, 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthEyebrow(LocaleKeys.auth_eyebrow.tr()),
                  SizedBox(height: 12.h),
                  AppText(LocaleKeys.auth_loginTitle.tr(),
                      fontSize: 28, fontWeight: FontWeight.w800, height: 1.35),
                  SizedBox(height: 4.h),
                  AppText(LocaleKeys.auth_loginSubtitle.tr(),
                      fontSize: 14.5,
                      height: 1.8,
                      color: AppColors.textSecondaryColor.themeColor),
                  SizedBox(height: 22.h),
                  LabeledField(
                    label: LocaleKeys.auth_phone.tr(),
                    child: PhoneInputField(
                      controller: _phone,
                      hint: LocaleKeys.auth_phoneHint.tr(),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  BlocConsumer<AuthCubit, AuthState>(
                    listenWhen: (_, s) => s is AuthOtpSent,
                    listener: (context, _) =>
                        context.pushNamed(Routes.otpScreen),
                    builder: (context, state) => CustomButton(
                      title: LocaleKeys.auth_sendOtp.tr(),
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                      enabled: isValid,
                      loading: state is AuthLoading,
                      onTap: () => context
                          .read<AuthCubit>()
                          .sendLoginOtp(_phone.text.trim()),
                    ),
                  ),
                  AuthNote(LocaleKeys.auth_adminOnlyNote.tr()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
