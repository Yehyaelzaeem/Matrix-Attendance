import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/field_label.dart';
import '../../data/models/project_model.dart';
import '../../logic/projects_cubit.dart';

class EditClientSheet extends StatefulWidget {
  const EditClientSheet({super.key, required this.project});

  final ProjectModel project;

  @override
  State<EditClientSheet> createState() => _EditClientSheetState();
}

class _EditClientSheetState extends State<EditClientSheet> {
  late final ClientInfo _c = widget.project.client;
  late final _name = TextEditingController(text: _c.name);
  late final _company = TextEditingController(text: _c.company);
  late final _phone = TextEditingController(text: _c.phone);
  late final _email = TextEditingController(text: _c.email);
  late final _city = TextEditingController(text: _c.city);

  @override
  void dispose() {
    for (final c in [_name, _company, _phone, _email, _city]) {
      c.dispose();
    }
    super.dispose();
  }

  String _or(TextEditingController c, String fallback) =>
      c.text.trim().isEmpty ? fallback : c.text.trim();

  Future<void> _save() async {
    await getIt<ProjectsCubit>().updateClient(
      widget.project.id,
      ClientInfo(
        name: _or(_name, _c.name),
        company: _or(_company, _c.company),
        phone: _or(_phone, _c.phone),
        email: _or(_email, _c.email),
        city: _or(_city, _c.city),
      ),
    );
    if (mounted) Navigator.of(context).pop();
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
        AppText(LocaleKeys.projects_clientInfo.tr(),
            fontSize: 18, fontWeight: FontWeight.w800),
        SizedBox(height: 14.h),
        _field(LocaleKeys.projects_clientName.tr(), _name),
        _field(LocaleKeys.projects_clientCompany.tr(), _company),
        _field(LocaleKeys.projects_clientPhone.tr(), _phone, ltr: true),
        _field(LocaleKeys.projects_clientEmail.tr(), _email, ltr: true),
        _field(LocaleKeys.projects_clientCity.tr(), _city),
        CustomButton(title: LocaleKeys.common_save.tr(), onTap: _save),
      ],
    );
  }
}
