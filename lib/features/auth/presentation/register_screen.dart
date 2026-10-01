import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/utils/media_picker.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/field_label.dart';
import '../../../core/widgets/select_field.dart';
import '../data/models/register_payload.dart';
import '../logic/auth_cubit.dart';
import 'widgets/auth_step_bar.dart';
import 'widgets/avatar_picker_row.dart';
import 'widgets/job_picker_sheet.dart';
import 'widgets/phone_input_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  String? _avatar;
  String? _job;

  bool get _isValid =>
      _avatar != null &&
      _job != null &&
      Validators.isFullName(_name.text) &&
      Validators.isValidPhone(_phone.text);

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final path = await MediaPicker.pickAvatar();
    if (path != null) setState(() => _avatar = path);
  }

  Future<void> _pickJob() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final job = await AppSheet.show<String>(
      context,
      fullHeight: true,
      child: JobPickerSheet(selected: _job),
    );
    if (job != null) setState(() => _job = job);
  }

  void _submit() {
    context.read<AuthCubit>().sendRegisterOtp(RegisterPayload(
          name: _name.text.trim(),
          phone: _phone.text.trim(),
          jobTitle: _job!,
          avatarPath: _avatar!,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardColor.themeColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthStepBar(
              label: LocaleKeys.auth_registerStep.tr(),
              step: 1,
              total: 2,
              onBack: () => context.pop(),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24.w, 18.h, 24.w, 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppText(LocaleKeys.auth_registerTitle.tr(),
                      fontSize: 28, fontWeight: FontWeight.w800, height: 1.35),
                  SizedBox(height: 4.h),
                  AppText(LocaleKeys.auth_registerSubtitle.tr(),
                      fontSize: 14.5,
                      height: 1.8,
                      color: AppColors.textSecondaryColor.themeColor),
                  SizedBox(height: 22.h),
                  AvatarPickerRow(path: _avatar, onTap: _pickAvatar),
                  LabeledField(
                    label: LocaleKeys.auth_fullName.tr(),
                    child: CustomTextField(
                      controller: _name,
                      hint: LocaleKeys.auth_fullNameHint.tr(),
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  LabeledField(
                    label: LocaleKeys.auth_phone.tr(),
                    hint: LocaleKeys.auth_phoneOtpHint.tr(),
                    child: PhoneInputField(
                      controller: _phone,
                      hint: LocaleKeys.auth_phoneHint.tr(),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  LabeledField(
                    label: LocaleKeys.auth_jobTitle.tr(),
                    child: SelectField(
                      placeholder: LocaleKeys.auth_jobPlaceholder.tr(),
                      value: _job,
                      valueDirection: TextDirection.ltr,
                      icon: Icons.work_outline_rounded,
                      onTap: _pickJob,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  BlocConsumer<AuthCubit, AuthState>(
                    listenWhen: (_, s) => s is AuthOtpSent && s.isRegister,
                    listener: (context, _) =>
                        context.pushNamed(Routes.otpScreen),
                    builder: (context, state) => CustomButton(
                      title: LocaleKeys.auth_continue.tr(),
                      enabled: _isValid,
                      loading: state is AuthLoading,
                      onTap: _submit,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(LocaleKeys.auth_haveAccount.tr(),
                          color: AppColors.textSecondaryColor.themeColor),
                      SizedBox(width: 4.w),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: AppText(LocaleKeys.auth_loginLink.tr(),
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor.themeColor),
                      ),
                    ],
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
