import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_pickers.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/choice_chips.dart';
import '../../../../core/widgets/field_label.dart';
import '../../../../core/widgets/select_field.dart';
import '../../../team/data/models/employee_model.dart';
import '../../../team/logic/team_cubit.dart';
import '../../logic/projects_cubit.dart';

class NewProjectSheet extends StatefulWidget {
  const NewProjectSheet({super.key});

  @override
  State<NewProjectSheet> createState() => _NewProjectSheetState();
}

class _NewProjectSheetState extends State<NewProjectSheet> {
  final _name = TextEditingController();
  final _kind = TextEditingController();
  final _desc = TextEditingController();
  final _client = TextEditingController();
  final _company = TextEditingController();
  final _phone = TextEditingController();
  final _value = TextEditingController();
  late final List<EmployeeModel> _managers = _pickManagers();
  late int? _managerId = _managers.firstOrNull?.id;

  List<EmployeeModel> _pickManagers() {
    final employees = context.read<TeamCubit>().employees;
    final titled = employees.where((e) => e.isManagerTitle).toList();
    return titled.isEmpty ? employees : titled;
  }

  String _currency = 'ج.م';
  DateTime _start = DateHelper.today();
  DateTime _due = DateHelper.fromToday(60);
  bool _loading = false;

  static const _currencies = ['ج.م', 'ر.س', r'$'];

  @override
  void dispose() {
    for (final c in [_name, _kind, _desc, _client, _company, _phone, _value]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _create() async {
    setState(() => _loading = true);
    final id = await context.read<ProjectsCubit>().create(
          name: _name.text.trim(),
          kind: _kind.text.trim(),
          description: _desc.text.trim(),
          clientName: _client.text.trim(),
          company: _company.text.trim(),
          phone: _phone.text.trim(),
          managerId: _managerId,
          value: double.tryParse(_value.text) ?? 0,
          currency: _currency,
          start: _start,
          due: _due,
        );
    if (!mounted) return;
    if (id == null) return setState(() => _loading = false);
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.pushNamed(Routes.projectDetailsScreen,
        arguments: {'projectId': id, 'initialTab': 1});
  }

  Widget _section(String text) => Padding(
        padding: EdgeInsets.only(top: 6.h, bottom: 10.h),
        child: AppText(text,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondaryColor.themeColor),
      );

  Widget _dateField(
          String label, DateTime value, ValueChanged<DateTime> onPick) =>
      LabeledField(
        label: label,
        child: SelectField(
          placeholder: '',
          value: DateHelper.dayMonth(value),
          icon: Icons.event_outlined,
          onTap: () async {
            final picked = await AppPickers.pickDate(context, initial: value);
            if (picked != null) setState(() => onPick(picked));
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(LocaleKeys.projects_newProjectTitle.tr(),
            fontSize: 18, fontWeight: FontWeight.w800),
        SizedBox(height: 14.h),
        LabeledField(
          label: LocaleKeys.projects_name.tr(),
          child: CustomTextField(
            controller: _name,
            hint: LocaleKeys.projects_nameHint.tr(),
            onChanged: (_) => setState(() {}),
          ),
        ),
        LabeledField(
          label: LocaleKeys.projects_kind.tr(),
          child: CustomTextField(
              controller: _kind, hint: LocaleKeys.projects_kindHint.tr()),
        ),
        LabeledField(
          label: LocaleKeys.projects_description.tr(),
          child: CustomTextField(
            controller: _desc,
            hint: LocaleKeys.projects_descriptionHint.tr(),
            minLines: 2,
            maxLines: 4,
          ),
        ),
        _section(LocaleKeys.projects_clientSection.tr()),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LabeledField(
                label: LocaleKeys.projects_clientName.tr(),
                child: CustomTextField(
                    controller: _client,
                    hint: LocaleKeys.projects_clientName.tr()),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: LabeledField(
                label: LocaleKeys.projects_clientCompany.tr(),
                child: CustomTextField(
                    controller: _company,
                    hint: LocaleKeys.projects_clientCompany.tr()),
              ),
            ),
          ],
        ),
        LabeledField(
          label: LocaleKeys.projects_clientPhone.tr(),
          child: CustomTextField(
            controller: _phone,
            hint: LocaleKeys.projects_clientPhoneHint.tr(),
            numeric: true,
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.ltr,
          ),
        ),
        _section(LocaleKeys.projects_teamSection.tr()),
        LabeledField(
          label: LocaleKeys.projects_manager.tr(),
          child: ChoiceChipsPicker<int>(
            items: [for (final m in _managers) ChoiceItem(m.id, m.name)],
            isSelected: (m) => m == _managerId,
            onTap: (m) => setState(() => _managerId = m),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LabeledField(
                label: LocaleKeys.projects_projectValue.tr(),
                child: CustomTextField(
                  controller: _value,
                  hint: '0',
                  numeric: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textDirection: TextDirection.ltr,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: LabeledField(
                label: LocaleKeys.projects_currency.tr(),
                child: ChoiceChipsPicker<String>(
                  items: [for (final c in _currencies) ChoiceItem(c, c)],
                  isSelected: (c) => c == _currency,
                  onTap: (c) => setState(() => _currency = c),
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: _dateField(LocaleKeys.projects_startDate.tr(), _start,
                    (d) => _start = d)),
            SizedBox(width: 10.w),
            Expanded(
                child: _dateField(
                    LocaleKeys.tasks_dueDate.tr(), _due, (d) => _due = d)),
          ],
        ),
        CustomButton(
          title: LocaleKeys.projects_create.tr(),
          enabled: _name.text.trim().length >= 2 && _managerId != null,
          loading: _loading,
          onTap: _create,
        ),
      ],
    );
  }
}
