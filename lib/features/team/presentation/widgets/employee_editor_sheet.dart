import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/models/day_type.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/field_label.dart';
import '../../../../core/widgets/person_row.dart';
import '../../../../core/widgets/schedule_editor.dart';
import '../../../../core/widgets/segmented_toggle.dart';
import '../../../auth/data/models/user_role.dart';
import '../../logic/team_cubit.dart';

class EmployeeEditorSheet extends StatefulWidget {
  const EmployeeEditorSheet({super.key, required this.name});

  final String name;

  @override
  State<EmployeeEditorSheet> createState() => _EmployeeEditorSheetState();
}

class _EmployeeEditorSheetState extends State<EmployeeEditorSheet> {
  final _cubit = getIt<TeamCubit>();
  late final _employee =
      _cubit.employees.firstWhere((e) => e.name == widget.name);
  late UserRole _role = _employee.role;
  late WeeklySchedule _schedule = Map.of(_employee.schedule);

  Future<void> _save() async {
    final navigator = Navigator.of(context);
    await _cubit.updateEmployee(widget.name, role: _role, schedule: _schedule);
    AppOverlay.showSuccess(LocaleKeys.team_savedToast
        .tr(namedArgs: {'name': Validators.firstName(widget.name)}));
    navigator.pop();
  }

  Future<void> _suspend() async {
    final navigator = Navigator.of(context);
    await _cubit.updateEmployee(widget.name, suspended: true);
    AppOverlay.showError(LocaleKeys.team_suspendedToast.tr());
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PersonRow(
          name: _employee.name,
          subtitle: _employee.jobTitle,
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
        CustomButton(title: LocaleKeys.common_saveChanges.tr(), onTap: _save),
        SizedBox(height: 6.h),
        CustomButton(
          title: LocaleKeys.team_suspend.tr(),
          type: ButtonStyleType.plain,
          textColor: AppColors.errorColor.themeColor,
          onTap: _suspend,
        ),
      ],
    );
  }
}
