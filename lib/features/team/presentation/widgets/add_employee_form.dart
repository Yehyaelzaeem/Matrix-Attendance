import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/models/day_type.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/choice_chips.dart';
import '../../../../core/widgets/field_label.dart';
import '../../../../core/widgets/info_box.dart';
import '../../../../core/widgets/schedule_editor.dart';
import '../../../../core/widgets/segmented_toggle.dart';
import '../../../../core/widgets/select_field.dart';
import '../../../auth/data/models/job_name_model.dart';
import '../../../auth/data/models/user_role.dart';
import '../../../auth/presentation/widgets/job_picker_sheet.dart';
import '../../../auth/presentation/widgets/phone_input_field.dart';
import '../../../projects/data/models/project_model.dart';
import '../../../projects/logic/projects_cubit.dart';
import '../../data/models/employee_model.dart';
import '../../logic/add_employee_cubit.dart';

class AddEmployeeForm extends StatefulWidget {
  const AddEmployeeForm({super.key, this.onCreated});

  final ValueChanged<EmployeeModel>? onCreated;

  @override
  State<AddEmployeeForm> createState() => _AddEmployeeFormState();
}

class _AddEmployeeFormState extends State<AddEmployeeForm> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  JobNameModel? _job;
  UserRole _role = UserRole.employee;
  WeeklySchedule _schedule = Map.of(kDefaultSchedule);
  final Set<int> _projects = {};
  late final _formFields = Listenable.merge([_name, _phone]);
  late final List<ProjectModel> _openProjects = context
      .read<ProjectsCubit>()
      .projects
      .where((p) => p.status != ProjectStatus.delivered)
      .toList();

  bool get _isValid =>
      Validators.isFullName(_name.text) &&
      Validators.isValidPhone(_phone.text) &&
      _job != null;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _pickJob() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final job = await AppSheet.show<JobNameModel>(
      context,
      fullHeight: true,
      child: JobPickerSheet(selected: _job?.name),
    );
    if (job != null) setState(() => _job = job);
  }

  void _submit() => context.read<AddEmployeeCubit>().submit(
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
        role: _role,
        jobNameId: _job!.id,
        schedule: _schedule,
        projectIds: _projects,
      );

  void _onState(BuildContext context, AddEmployeeState state) {
    if (state is! AddEmployeeSuccess) return;
    widget.onCreated?.call(state.employee);
    AppOverlay.showSuccess(LocaleKeys.team_addedToast
        .tr(namedArgs: {'name': Validators.firstName(state.employee.name)}));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(LocaleKeys.team_newEmployee.tr(),
            fontSize: 18, fontWeight: FontWeight.w800),
        SizedBox(height: 14.h),
        LabeledField(
          label: LocaleKeys.auth_fullName.tr(),
          child: CustomTextField(
            controller: _name,
            hint: LocaleKeys.auth_fullNameHint.tr(),
          ),
        ),
        LabeledField(
          label: LocaleKeys.team_loginPhone.tr(),
          child: PhoneInputField(
            controller: _phone,
            hint: LocaleKeys.auth_phoneHint.tr(),
          ),
        ),
        LabeledField(
          label: LocaleKeys.admin_email.tr(),
          child: CustomTextField(
            controller: _email,
            hint: LocaleKeys.team_emailHint.tr(),
            keyboardType: TextInputType.emailAddress,
            textDirection: TextDirection.ltr,
          ),
        ),
        LabeledField(
          label: LocaleKeys.auth_jobTitle.tr(),
          child: SelectField(
            placeholder: LocaleKeys.auth_jobSheetTitle.tr(),
            value: _job?.name,
            valueDirection: TextDirection.ltr,
            onTap: _pickJob,
          ),
        ),
        LabeledField(
          label: LocaleKeys.admin_role.tr(),
          child: SegmentedToggle<UserRole>(
            options: [
              for (final r in UserRole.values) (r, '${r.emoji} ${r.label}')
            ],
            selected: _role,
            onChanged: (r) => setState(() => _role = r),
          ),
        ),
        LabeledField(
          label: LocaleKeys.admin_weeklySchedule.tr(),
          hint: LocaleKeys.admin_scheduleHint.tr(),
          child: ScheduleEditor(
            schedule: _schedule,
            onChanged: (s) => setState(() => _schedule = s),
          ),
        ),
        LabeledField(
          label: LocaleKeys.admin_projects.tr(),
          child: ChoiceChipsPicker<int>(
            items: [for (final p in _openProjects) ChoiceItem(p.id, p.name)],
            isSelected: _projects.contains,
            onTap: (id) => setState(() {
              if (!_projects.remove(id)) _projects.add(id);
            }),
          ),
        ),
        InfoBox(
          emoji: AppEmojis.info,
          text: LocaleKeys.team_addNote.tr(),
          margin: EdgeInsets.only(bottom: 14.h),
        ),
        ListenableBuilder(
          listenable: _formFields,
          builder: (context, _) =>
              BlocConsumer<AddEmployeeCubit, AddEmployeeState>(
            listenWhen: (_, state) => state is AddEmployeeSuccess,
            listener: _onState,
            builder: (context, state) => CustomButton(
              title: LocaleKeys.team_addEmployee.tr(),
              enabled: _isValid,
              loading: state is AddEmployeeLoading,
              onTap: _submit,
            ),
          ),
        ),
      ],
    );
  }
}
