import 'package:equatable/equatable.dart';

import '../../../../core/utils/date_helper.dart';
import 'task_enums.dart';
import 'task_model.dart';

class TaskFilter extends Equatable {
  const TaskFilter({
    this.status,
    this.projectId,
    this.assignee,
    this.due = DueFilter.all,
    this.query = '',
  });

  final TaskStatus? status;
  final String? projectId;
  final String? assignee;
  final DueFilter due;
  final String query;

  bool get hasExtraFilters =>
      projectId != null ||
      assignee != null ||
      due != DueFilter.all ||
      query.isNotEmpty;

  TaskFilter copyWith({
    TaskStatus? status,
    bool clearStatus = false,
    String? projectId,
    bool clearProject = false,
    String? assignee,
    bool clearAssignee = false,
    DueFilter? due,
    String? query,
  }) =>
      TaskFilter(
        status: clearStatus ? null : (status ?? this.status),
        projectId: clearProject ? null : (projectId ?? this.projectId),
        assignee: clearAssignee ? null : (assignee ?? this.assignee),
        due: due ?? this.due,
        query: query ?? this.query,
      );

  TaskFilter cleared() => TaskFilter(status: status);

  bool _dueMatches(TaskModel t) {
    final diff = DateHelper.dayDiff(t.due);
    final today = DateHelper.today();
    return switch (due) {
      DueFilter.all => true,
      DueFilter.late => t.isLate,
      DueFilter.today => diff == 0 && !t.isDone,
      DueFilter.week => diff >= 0 && diff <= 7,
      DueFilter.month => t.due.year == today.year && t.due.month == today.month,
    };
  }

  bool matches(TaskModel t,
      {required String Function(String id) projectName,
      bool ignoreStatus = false}) {
    final q = query.trim().toLowerCase();
    return (ignoreStatus || status == null || t.status == status) &&
        (projectId == null || t.projectId == projectId) &&
        (assignee == null || t.assignee == assignee) &&
        _dueMatches(t) &&
        (q.isEmpty ||
            t.title.toLowerCase().contains(q) ||
            t.assignee.contains(q) ||
            projectName(t.projectId).toLowerCase().contains(q));
  }

  static int sort(TaskModel a, TaskModel b) {
    if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
    if (a.isDone) return (b.doneAt ?? b.due).compareTo(a.doneAt ?? a.due);
    return a.due.compareTo(b.due);
  }

  @override
  List<Object?> get props => [status, projectId, assignee, due, query];
}
