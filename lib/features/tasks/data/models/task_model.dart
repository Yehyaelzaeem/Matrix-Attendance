import 'package:equatable/equatable.dart';

import '../../../../core/models/enum_value.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/json_reader.dart';
import 'task_enums.dart';

class TaskComment extends Equatable {
  const TaskComment({
    required this.text,
    required this.createdAt,
    this.id = 0,
    this.by = '',
    this.byId,
    this.byImage,
    this.kind = CommentKind.comment,
  });

  final int id;
  final String by;
  final int? byId;
  final String? byImage;
  final String text;
  final DateTime createdAt;
  final CommentKind kind;

  String get at => DateHelper.relative(createdAt);

  bool get isSystem => kind == CommentKind.system;

  factory TaskComment.fromJson(Map<String, dynamic> json) {
    final user = JsonReader.mapOrNull(json['user']);
    return TaskComment(
      id: JsonReader.toInt(json['id']),
      text: JsonReader.string(json['text']),
      createdAt: JsonReader.dateTime(json['created_at']) ?? DateTime.now(),
      by: JsonReader.string(user?['name']),
      byId: JsonReader.intOrNull(user?['id']),
      byImage: JsonReader.stringOrNull(user?['image']),
      kind: CommentKind.fromKey(EnumValue.keyOf(json['kind'])),
    );
  }

  @override
  List<Object?> get props => [id, by, text, createdAt, kind];
}

class TaskAttachment extends Equatable {
  const TaskAttachment({
    required this.name,
    required this.type,
    this.id = 0,
    this.path,
    this.size = 0,
  });

  final int id;
  final String name;
  final AttachmentType type;
  final String? path;
  final int size;

  bool get isRemote => path?.startsWith('http') ?? false;

  factory TaskAttachment.fromJson(Map<String, dynamic> json) => TaskAttachment(
        id: JsonReader.toInt(json['id']),
        name: JsonReader.string(json['name']),
        type: AttachmentType.fromKey(EnumValue.keyOf(json['type'])),
        path: JsonReader.stringOrNull(json['url']),
        size: JsonReader.toInt(json['size']),
      );

  @override
  List<Object?> get props => [id, name, type, path, size];
}

class TaskModel extends Equatable {
  const TaskModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.assigneeId,
    required this.assignee,
    required this.status,
    required this.priority,
    this.due,
    this.projectName = '',
    this.assigneeImage,
    this.estimate = 0,
    this.spent = 0,
    this.doneAt,
    this.description = '',
    this.attachments = const [],
    this.comments = const [],
    this.returns = 0,
    this.returned = false,
    this.hasDetail = false,
  });

  final int id;
  final int projectId;
  final String projectName;
  final String title;
  final int assigneeId;
  final String assignee;
  final String? assigneeImage;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? due;
  final double estimate;
  final double spent;
  final DateTime? doneAt;
  final String description;
  final List<TaskAttachment> attachments;
  final List<TaskComment> comments;
  final int returns;
  final bool returned;
  final bool hasDetail;

  bool get isDone => status == TaskStatus.done;

  bool get isLate =>
      !isDone && due != null && due!.isBefore(DateHelper.today());

  int get userCommentsCount => comments.where((c) => !c.isSystem).length;

  DateTime get dueOrFar => due ?? DateTime(9999);

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final project = JsonReader.map(json['project']);
    final assignee = JsonReader.map(json['assignee']);
    final hasDetail =
        json.containsKey('comments') || json.containsKey('attachments');
    return TaskModel(
      id: JsonReader.toInt(json['id']),
      projectId: JsonReader.toInt(project['id']),
      projectName: JsonReader.string(project['name']),
      title: JsonReader.string(json['title']),
      description: JsonReader.string(json['description']),
      assigneeId: JsonReader.toInt(assignee['id']),
      assignee: JsonReader.string(assignee['name']),
      assigneeImage: JsonReader.stringOrNull(assignee['image']),
      status: TaskStatus.fromKey(EnumValue.keyOf(json['status'])),
      priority: TaskPriority.fromKey(EnumValue.keyOf(json['priority'])),
      due: JsonReader.date(json['due_date']),
      estimate: JsonReader.toDouble(json['estimate_hours']),
      spent: JsonReader.toDouble(json['spent_hours']),
      doneAt: JsonReader.dateTime(json['done_at']),
      returns: JsonReader.toInt(json['returns_count']),
      returned: JsonReader.toBool(json['is_returned']),
      comments:
          JsonReader.list(json['comments']).map(TaskComment.fromJson).toList(),
      attachments: JsonReader.list(json['attachments'])
          .map(TaskAttachment.fromJson)
          .toList(),
      hasDetail: hasDetail,
    );
  }

  TaskModel mergeSummary(TaskModel summary) => hasDetail && !summary.hasDetail
      ? summary.copyWith(
          comments: comments, attachments: attachments, hasDetail: true)
      : summary;

  TaskModel copyWith({
    List<TaskAttachment>? attachments,
    List<TaskComment>? comments,
    bool? hasDetail,
  }) =>
      TaskModel(
        id: id,
        projectId: projectId,
        projectName: projectName,
        title: title,
        assigneeId: assigneeId,
        assignee: assignee,
        assigneeImage: assigneeImage,
        status: status,
        priority: priority,
        due: due,
        estimate: estimate,
        spent: spent,
        doneAt: doneAt,
        description: description,
        attachments: attachments ?? this.attachments,
        comments: comments ?? this.comments,
        returns: returns,
        returned: returned,
        hasDetail: hasDetail ?? this.hasDetail,
      );

  @override
  List<Object?> get props => [
        id,
        projectId,
        projectName,
        title,
        assigneeId,
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
        hasDetail,
      ];
}
