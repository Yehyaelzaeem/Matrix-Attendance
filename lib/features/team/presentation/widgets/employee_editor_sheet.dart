import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/models/day_type.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/field_label.dart';
import '../../../../core/widgets/person_row.dart';
import '../../../../core/widgets/schedule_editor.dart';
import '../../../../core/widgets/segmented_toggle.dart';
import '../../../auth/data/models/user_role.dart';
import '../../data/models/employee_model.dart';
import '../../logic/team_cubit.dart';

class EmployeeEditorSheet extends StatefulWidget {
  const EmployeeEditorSheet({super.key, required this.employee});

  final EmployeeModel employee;

  @override
  State<EmployeeEditorSheet> createState() => _EmployeeEditorSheetState();
}

class _EmployeeEditorSheetState extends State<EmployeeEditorSheet> {
  late final TeamCubit _cubit = context.read<TeamCubit>();
  late final EmployeeModel _employee =
      _cubit.byId(widget.employee.id) ?? widget.employee;
  late UserRole _role = _employee.role;
  late WeeklySchedule _schedule = Map.of(_employee.schedule);
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    final ok = await _cubit.updateEmployee(_employee,
        role: _role, schedule: _schedule);
    if (ok) {
      navigator.pop();
    } else if (mounted) {
      setState(() => _saving = false);
    }
  }

  Future<void> _toggleSuspend() async {
    final navigator = Navigator.of(context);
    if (await _cubit.setSuspended(_employee, !_employee.suspended)) {
      navigator.pop();
    }
  }

  Future<void> _resetDevice() async {
    final navigator = Navigator.of(context);
    if (await _cubit.resetDevice(_employee)) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PersonRow(
          name: _employee.name,
          subtitle: _employee.jobTitle,
          avatarImage: _employee.image,
          avatarSize: 52,
          titleSize: 16,
        ),
        SizedBox(height: 16.h),
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
        CustomButton(
          title: LocaleKeys.common_saveChanges.tr(),
          loading: _saving,
          onTap: _save,
        ),
        SizedBox(height: 6.h),
        CustomButton(
          title: _employee.suspended
              ? LocaleKeys.team_activate.tr()
              : LocaleKeys.team_suspend.tr(),
          type: ButtonStyleType.plain,
          textColor: _employee.suspended
              ? AppColors.successColor.themeColor
              : AppColors.errorColor.themeColor,
          onTap: _toggleSuspend,
        ),
        CustomButton(
          title: LocaleKeys.team_resetDevice.tr(),
          type: ButtonStyleType.plain,
          textColor: AppColors.textSecondaryColor.themeColor,
          onTap: _resetDevice,
        ),
      ],
    );
  }
}
