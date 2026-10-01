import 'package:equatable/equatable.dart';

import '../../../../core/utils/date_helper.dart';
import 'task_enums.dart';

class TaskComment extends Equatable {
  const TaskComment({
    required this.text,
    required this.at,
    this.by = '',
    this.kind = CommentKind.comment,
  });

  final String by;
  final String text;
  final String at;
  final CommentKind kind;

  bool get isSystem => kind == CommentKind.system;

  @override
  List<Object?> get props => [by, text, at, kind];
}

class TaskAttachment extends Equatable {
  const TaskAttachment({required this.name, required this.type, this.path});

  final String name;
  final AttachmentType type;
  final String? path;

  @override
  List<Object?> get props => [name, type, path];
}

class TaskModel extends Equatable {
  const TaskModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.assignee,
    required this.status,
    required this.priority,
    required this.due,
    required this.estimate,
    this.spent = 0,
    this.doneAt,
    this.description = '',
    this.attachments = const [],
    this.comments = const [],
    this.returns = 0,
    this.returned = false,
  });

  final String id;
  final String projectId;
  final String title;
  final String assignee;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime due;
  final double estimate;
  final double spent;
  final DateTime? doneAt;
  final String description;
  final List<TaskAttachment> attachments;
  final List<TaskComment> comments;
  final int returns;
  final bool returned;

  bool get isDone => status == TaskStatus.done;

  bool get isLate => !isDone && due.isBefore(DateHelper.today());

  int get userCommentsCount => comments.where((c) => !c.isSystem).length;

  TaskModel copyWith({
    String? projectId,
    String? title,
    String? assignee,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? due,
    double? estimate,
    double? spent,
    DateTime? doneAt,
    bool clearDoneAt = false,
    String? description,
    List<TaskAttachment>? attachments,
    List<TaskComment>? comments,
    int? returns,
    bool? returned,
  }) =>
      TaskModel(
        id: id,
        projectId: projectId ?? this.projectId,
        title: title ?? this.title,
        assignee: assignee ?? this.assignee,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        due: due ?? this.due,
        estimate: estimate ?? this.estimate,
        spent: spent ?? this.spent,
        doneAt: clearDoneAt ? null : (doneAt ?? this.doneAt),
        description: description ?? this.description,
        attachments: attachments ?? this.attachments,
        comments: comments ?? this.comments,
        returns: returns ?? this.returns,
        returned: returned ?? this.returned,
      );

  @override
  List<Object?> get props => [
        id,
        projectId,
        title,
        assignee,
        status,
        priority,
        due,
        estimate,
        spent,
        doneAt,
        description,
        attachments,
        comments,
        returns,
        returned,
      ];
}
