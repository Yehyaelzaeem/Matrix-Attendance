import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/helper_methods.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/key_value_row.dart';
import '../../data/models/employee_model.dart';
import 'contact_button.dart';
import 'copyable_value.dart';

class EmployeeContactSection extends StatelessWidget {
  const EmployeeContactSection({super.key, required this.employee});

  final EmployeeModel employee;

  Future<void> _copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    AppOverlay.showSuccess(
        LocaleKeys.team_copied.tr(namedArgs: {'text': text}));
  }

  Future<void> _open(Uri uri) async {
    if (!await HelperMethods.launch(uri)) {
      AppOverlay.showError(LocaleKeys.team_cantOpen.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final phone = Validators.e164Phone(employee.phone);
    final email = employee.email;
    final hasEmail = email.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KeyValueRow(
          label: LocaleKeys.team_mobile.tr(),
          valueWidget: GestureDetector(
            onTap: () => _copy(phone),
            child: CopyableValue(Validators.spacedPhone(employee.phone),
                numeric: true),
          ),
        ),
        KeyValueRow(
          label: LocaleKeys.admin_email.tr(),
          showDivider: false,
          valueWidget: hasEmail
              ? GestureDetector(
                  onTap: () => _copy(email),
                  child: CopyableValue(email, fontSize: 13),
                )
              : AppText(LocaleKeys.team_noEmail.tr(),
                  color: AppColors.textSecondaryColor.themeColor),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            for (final (i, button) in [
              ContactButton(
                emoji: AppEmojis.call,
                label: LocaleKeys.team_call.tr(),
                background: AppColors.successSoftColor.themeColor,
                foreground: AppColors.successTextColor.themeColor,
                onTap: () => _open(Uri(scheme: 'tel', path: phone)),
              ),
              ContactButton(
                emoji: AppEmojis.speech,
                label: LocaleKeys.team_whatsapp.tr(),
                background: AppColors.whatsappSoftColor.themeColor,
                foreground: AppColors.successTextColor.themeColor,
                onTap: () =>
                    _open(Uri.parse('https://wa.me/${phone.substring(1)}')),
              ),
              ContactButton(
                emoji: AppEmojis.envelope,
                label: LocaleKeys.team_sms.tr(),
                background: AppColors.primarySoftColor.themeColor,
                foreground: AppColors.primaryColor.themeColor,
                onTap: () => _open(Uri(scheme: 'sms', path: phone)),
              ),
              ContactButton(
                emoji: AppEmojis.email,
                label: LocaleKeys.team_emailAction.tr(),
                background: AppColors.violetSoftColor.themeColor,
                foreground: AppColors.violetColor.themeColor,
                onTap: hasEmail
                    ? () => _open(Uri(scheme: 'mailto', path: email))
                    : () => AppOverlay.showError(LocaleKeys.team_noEmail.tr()),
              ),
            ].indexed) ...[
              if (i > 0) SizedBox(width: 8.w),
              Expanded(child: button),
            ],
          ],
        ),
      ],
    );
  }
}
