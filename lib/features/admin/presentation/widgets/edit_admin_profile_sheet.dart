import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/field_label.dart';
import '../../../auth/logic/auth_cubit.dart';

class EditAdminProfileSheet extends StatefulWidget {
  const EditAdminProfileSheet({super.key});

  @override
  State<EditAdminProfileSheet> createState() => _EditAdminProfileSheetState();
}

class _EditAdminProfileSheetState extends State<EditAdminProfileSheet> {
  late final _user = context.read<AuthCubit>().currentUser;
  late final _name = TextEditingController(text: _user?.name);
  late final _title = TextEditingController(text: _user?.orgTitle);
  late final _phone = TextEditingController(text: _user?.localPhone);
  late final _email = TextEditingController(text: _user?.email);

  @override
  void dispose() {
    for (final c in [_name, _title, _phone, _email]) {
      c.dispose();
    }
    super.dispose();
  }

  String _or(TextEditingController c, String? fallback) =>
      c.text.trim().isEmpty ? (fallback ?? '') : c.text.trim();

  Future<void> _save() async {
    final navigator = Navigator.of(context);
    final saved = await context.read<AuthCubit>().updateProfile(
          name: _or(_name, _user?.name),
          orgTitle: _or(_title, _user?.orgTitle),
          phone: _or(_phone, _user?.localPhone),
          email: _email.text.trim(),
        );
    if (saved) navigator.pop();
  }

  Widget _field(String label, TextEditingController c, {bool ltr = false}) =>
      LabeledField(
        label: label,
        child: CustomTextField(
          controller: c,
          hint: label,
          numeric: ltr,
          textDirection: ltr ? TextDirection.ltr : null,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(LocaleKeys.admin_editProfile.tr(),
            fontSize: 18, fontWeight: FontWeight.w800),
        SizedBox(height: 14.h),
        _field(LocaleKeys.admin_name.tr(), _name),
        _field(LocaleKeys.admin_title.tr(), _title, ltr: true),
        _field(LocaleKeys.admin_phone.tr(), _phone, ltr: true),
        _field(LocaleKeys.admin_email.tr(), _email, ltr: true),
        CustomButton(title: LocaleKeys.common_save.tr(), onTap: _save),
      ],
    );
  }
}
