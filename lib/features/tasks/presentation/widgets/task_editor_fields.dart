import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_pickers.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/choice_chips.dart';
import '../../../../core/widgets/field_label.dart';
import '../../../../core/widgets/select_field.dart';
import '../../../projects/data/models/project_model.dart';
import '../../data/models/task_enums.dart';
import '../../data/models/task_model.dart';
import 'task_due_label.dart';

class TaskEditValues {
  const TaskEditValues({
    required this.status,
    required this.assigneeId,
    required this.assigneeName,
    required this.priority,
    required this.due,
    required this.estimate,
  });

  final TaskStatus status;
  final int assigneeId;
  final String assigneeName;
  final TaskPriority priority;
  final DateTime due;
  final double estimate;
}

class TaskEditorFields extends StatefulWidget {
  const TaskEditorFields({super.key, required this.task, required this.team});

  final TaskModel task;
  final List<TeamMember> team;

  @override
  State<TaskEditorFields> createState() => TaskEditorFieldsState();
}

class TaskEditorFieldsState extends State<TaskEditorFields> {
  late TaskStatus _status = widget.task.status;
  late int _assigneeId = widget.task.assigneeId;
  late TaskPriority _priority = widget.task.priority;
  late DateTime _due = widget.task.due ?? DateHelper.today();

  List<TeamMember> get _team => [
        if (!widget.team.any((m) => m.userId == widget.task.assigneeId))
          TeamMember(
              userId: widget.task.assigneeId,
              name: widget.task.assignee,
              role: ''),
        ...widget.team,
      ];
  late final _estimate =
      TextEditingController(text: TaskDueLabel.hours(widget.task.estimate));

  TaskEditValues get values => TaskEditValues(
        status: _status,
        assigneeId: _assigneeId,
        assigneeName: _team
            .firstWhere((m) => m.userId == _assigneeId,
                orElse: () => _team.first)
            .name,
        priority: _priority,
        due: _due,
        estimate: double.tryParse(_estimate.text) ?? widget.task.estimate,
      );

  @override
  void didUpdateWidget(covariant TaskEditorFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task.status != widget.task.status) {
      _status = widget.task.status;
    }
  }

  @override
  void dispose() {
    _estimate.dispose();
    super.dispose();
  }

  Future<void> _pickDue() async {
    final picked = await AppPickers.pickDate(context, initial: _due);
    if (picked != null) setState(() => _due = picked);
  }

  @override
  Widget build(BuildContext context) {
    final team = _team;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledField(
          label: LocaleKeys.tasks_status.tr(),
          child: ChoiceChipsPicker<TaskStatus>(
            items: [for (final s in TaskStatus.values) ChoiceItem(s, s.label)],
            isSelected: (s) => s == _status,
            onTap: (s) => setState(() => _status = s),
          ),
        ),
        LabeledField(
          label: LocaleKeys.tasks_assignee.tr(),
          child: ChoiceChipsPicker<int>(
            items: [
              for (final m in team)
                ChoiceItem(m.userId, Validators.firstName(m.name))
            ],
            isSelected: (id) => id == _assigneeId,
            onTap: (id) => setState(() => _assigneeId = id),
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
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  textDirection: TextDirection.ltr,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
