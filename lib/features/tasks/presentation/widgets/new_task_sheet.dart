import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/app_pickers.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/choice_chips.dart';
import '../../../../core/widgets/field_label.dart';
import '../../../../core/widgets/select_field.dart';
import '../../../projects/data/models/project_model.dart';
import '../../../projects/logic/projects_cubit.dart';
import '../../data/models/task_enums.dart';
import '../../data/models/task_model.dart';
import '../../logic/tasks_cubit.dart';
import 'attachments_field.dart';

class NewTaskSheet extends StatefulWidget {
  const NewTaskSheet({super.key, this.projectId});

  final int? projectId;

  @override
  State<NewTaskSheet> createState() => _NewTaskSheetState();
}

class _NewTaskSheetState extends State<NewTaskSheet> {
  final _title = TextEditingController();
  final _details = TextEditingController();
  final _estimate = TextEditingController(text: '4');
  late int? _projectId = widget.projectId;
  TeamMember? _assignee;
  TaskPriority _priority = TaskPriority.med;
  DateTime _due = DateHelper.fromToday(3);
  final List<TaskAttachment> _files = [];
  bool _loading = false;

  List<ProjectModel> get _projects => context
      .read<ProjectsCubit>()
      .projects
      .where((p) => p.status != ProjectStatus.delivered)
      .toList();

  ProjectModel? get _project => _projectId == null
      ? null
      : context.read<ProjectsCubit>().byId(_projectId!);

  @override
  void initState() {
    super.initState();
    _syncAssignee();
  }

  @override
  void dispose() {
    _title.dispose();
    _details.dispose();
    _estimate.dispose();
    super.dispose();
  }

  void _syncAssignee() {
    final team = _project?.people ?? const <TeamMember>[];
    if (team.isEmpty) {
      _assignee = null;
    } else if (!team.any((m) => m.userId == _assignee?.userId)) {
      _assignee = team.length > 1 ? team[1] : team.first;
    }
  }

  Future<void> _pickDue() async {
    final picked = await AppPickers.pickDate(context, initial: _due);
    if (picked != null) setState(() => _due = picked);
  }

  Future<void> _create() async {
    if (_projectId == null || _assignee == null) {
      AppOverlay.showError(LocaleKeys.tasks_chooseProjectFirst.tr());
      return;
    }
    setState(() => _loading = true);
    final ok = await context.read<TasksCubit>().create(
          projectId: _projectId!,
          title: _title.text.trim(),
          description: _details.text.trim(),
          assigneeId: _assignee!.userId,
          assigneeName: _assignee!.name,
          priority: _priority,
          due: _due,
          estimate: double.tryParse(_estimate.text) ?? 4,
          attachments: List.of(_files),
        );
    if (!mounted) return;
    if (ok) return Navigator.of(context).pop();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final team = _project?.people ?? const <TeamMember>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(LocaleKeys.tasks_newTask.tr(),
            fontSize: 18, fontWeight: FontWeight.w800),
        SizedBox(height: 14.h),
        LabeledField(
          label: LocaleKeys.tasks_taskTitle.tr(),
          child: CustomTextField(
            controller: _title,
            hint: LocaleKeys.tasks_taskTitleHint.tr(),
            onChanged: (_) => setState(() {}),
          ),
        ),
        LabeledField(
          label: LocaleKeys.tasks_taskDetails.tr(),
          child: CustomTextField(
            controller: _details,
            hint: LocaleKeys.tasks_taskDetailsHint.tr(),
            minLines: 2,
            maxLines: 4,
          ),
        ),
        LabeledField(
          label: LocaleKeys.tasks_project.tr(),
          child: ChoiceChipsPicker<int>(
            items: [for (final p in _projects) ChoiceItem(p.id, p.name)],
            isSelected: (id) => id == _projectId,
            onTap: (id) => setState(() {
              _projectId = id;
              _syncAssignee();
            }),
          ),
        ),
        LabeledField(
          label: LocaleKeys.tasks_assignee.tr(),
          child: team.isEmpty
              ? AppText(LocaleKeys.tasks_chooseProjectFirst.tr(),
                  fontSize: 11.5,
                  color: AppColors.textSecondaryColor.themeColor)
              : ChoiceChipsPicker<int>(
                  items: [
                    for (final m in team)
                      ChoiceItem(m.userId, Validators.firstName(m.name)),
                  ],
                  isSelected: (id) => id == _assignee?.userId,
                  onTap: (id) => setState(
                      () => _assignee = team.firstWhere((m) => m.userId == id)),
                ),
        ),
        LabeledField(
          label: LocaleKeys.tasks_priority.tr(),
          child: ChoiceChipsPicker<TaskPriority>(
            items: [
              for (final p in TaskPriority.values) ChoiceItem(p, p.label)
            ],
            isSelected: (p) => p == _priority,
            onTap: (p) => setState(() => _priority = p),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LabeledField(
                label: LocaleKeys.tasks_dueDate.tr(),
                child: SelectField(
                  placeholder: '',
                  value: DateHelper.dayMonth(_due),
                  icon: Icons.event_outlined,
                  onTap: _pickDue,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: LabeledField(
                label: LocaleKeys.tasks_estimate.tr(),
                child: CustomTextField(
                  controller: _estimate,
                  hint: '4',
                  numeric: true,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                  ],
                  textDirection: TextDirection.ltr,
                ),
              ),
            ),
          ],
        ),
        AttachmentsField(
          attachments: _files,
          optional: true,
          hint: LocaleKeys.tasks_attachmentsHint.tr(),
          onAdd: (files) => setState(() => _files.addAll(files)),
          onRemove: (i) => setState(() => _files.removeAt(i)),
        ),
        CustomButton(
          title: LocaleKeys.tasks_createNotify.tr(),
          enabled: _title.text.trim().length >= 3,
          loading: _loading,
          onTap: _create,
        ),
      ],
    );
  }
}
