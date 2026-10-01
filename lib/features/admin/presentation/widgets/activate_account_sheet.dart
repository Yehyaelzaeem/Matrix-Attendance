import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/models/day_type.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/choice_chips.dart';
import '../../../../core/widgets/field_label.dart';
import '../../../../core/widgets/person_row.dart';
import '../../../../core/widgets/schedule_editor.dart';
import '../../../../core/widgets/segmented_toggle.dart';
import '../../../auth/data/models/user_role.dart';
import '../../../projects/data/models/project_model.dart';
import '../../../projects/logic/projects_cubit.dart';
import '../../../team/data/models/employee_model.dart';
import '../../../team/logic/team_cubit.dart';
import '../../data/models/approval_models.dart';
import '../../logic/approvals_cubit.dart';

class ActivateAccountSheet extends StatefulWidget {
  const ActivateAccountSheet({super.key, required this.account});

  final NewAccountModel account;

  @override
  State<ActivateAccountSheet> createState() => _ActivateAccountSheetState();
}

class _ActivateAccountSheetState extends State<ActivateAccountSheet> {
  UserRole _role = UserRole.employee;
  WeeklySchedule _schedule = Map.of(kDefaultSchedule);
  final Set<String> _projects = {};

  Future<void> _activate() async {
    final navigator = Navigator.of(context);
    final employee = EmployeeModel(
      name: widget.account.name,
      jobTitle: widget.account.jobTitle,
      role: _role,
      schedule: _schedule,
    );
    await getIt<ApprovalsCubit>().activateAccount(widget.account, _role);
    await getIt<TeamCubit>().addEmployee(employee);
    for (final id in _projects) {
      await getIt<ProjectsCubit>()
          .addMember(id, TeamMember(employee.name, employee.shortRole));
    }
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final projects = getIt<ProjectsCubit>()
        .projects
        .where((p) => p.status != ProjectStatus.delivered)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PersonRow(
          name: LocaleKeys.admin_activateTitle
              .tr(namedArgs: {'name': widget.account.name}),
          subtitle: widget.account.jobTitle,
          avatarName: widget.account.name,
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
        LabeledField(
          label: LocaleKeys.admin_projects.tr(),
          child: ChoiceChipsPicker<String>(
            items: [for (final p in projects) ChoiceItem(p.id, p.name)],
            isSelected: _projects.contains,
            onTap: (id) => setState(() {
              if (!_projects.remove(id)) _projects.add(id);
            }),
          ),
        ),
        CustomButton(
            title: LocaleKeys.admin_activateNotify.tr(), onTap: _activate),
      ],
    );
  }
}
