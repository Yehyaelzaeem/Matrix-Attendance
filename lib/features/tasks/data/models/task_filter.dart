import 'package:equatable/equatable.dart';

import '../../../../core/utils/date_helper.dart';
import 'task_enums.dart';
import 'task_model.dart';

class TaskFilter extends Equatable {
  const TaskFilter({
    this.status,
    this.projectId,
    this.assigneeId,
    this.due = DueFilter.all,
    this.query = '',
  });

  final TaskStatus? status;
  final int? projectId;
  final int? assigneeId;
  final DueFilter due;
  final String query;

  bool get hasExtraFilters =>
      projectId != null ||
      assigneeId != null ||
      due != DueFilter.all ||
      query.isNotEmpty;

  TaskFilter copyWith({
    TaskStatus? status,
    bool clearStatus = false,
    int? projectId,
    bool clearProject = false,
    int? assigneeId,
    bool clearAssignee = false,
    DueFilter? due,
    String? query,
  }) =>
      TaskFilter(
        status: clearStatus ? null : (status ?? this.status),
        projectId: clearProject ? null : (projectId ?? this.projectId),
        assigneeId: clearAssignee ? null : (assigneeId ?? this.assigneeId),
        due: due ?? this.due,
        query: query ?? this.query,
      );

  TaskFilter cleared() => TaskFilter(status: status);

  bool _dueMatches(TaskModel t) {
    final due = t.due;
    if (this.due == DueFilter.all) return true;
    if (this.due == DueFilter.late) return t.isLate;
    if (due == null) return false;
    final diff = DateHelper.dayDiff(due);
    final today = DateHelper.today();
    return switch (this.due) {
      DueFilter.today => diff == 0 && !t.isDone,
      DueFilter.week => diff >= 0 && diff <= 7,
      DueFilter.month => due.year == today.year && due.month == today.month,
      _ => true,
    };
  }

  bool matches(TaskModel t, {bool ignoreStatus = false}) {
    final q = query.trim().toLowerCase();
    return (ignoreStatus || status == null || t.status == status) &&
        (projectId == null || t.projectId == projectId) &&
        (assigneeId == null || t.assigneeId == assigneeId) &&
        _dueMatches(t) &&
        (q.isEmpty ||
            t.title.toLowerCase().contains(q) ||
            t.assignee.contains(q) ||
            t.projectName.toLowerCase().contains(q));
  }

  static int sort(TaskModel a, TaskModel b) {
    if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
    if (a.isDone) {
      return (b.doneAt ?? b.dueOrFar).compareTo(a.doneAt ?? a.dueOrFar);
    }
    return a.dueOrFar.compareTo(b.dueOrFar);
  }

  @override
  List<Object?> get props => [status, projectId, assigneeId, due, query];
}
