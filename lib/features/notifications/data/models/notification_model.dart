import 'package:equatable/equatable.dart';

import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/json_reader.dart';

enum NotificationScreen {
  account,
  schedule,
  request,
  announcement,
  holiday,
  task,
  none;

  static NotificationScreen ofType(String type) => switch (type) {
        'account_activated' || 'account_suspended' => account,
        'schedule_changed' => schedule,
        'request_created' ||
        'request_approved' ||
        'request_rejected' =>
          request,
        'announcement_published' || 'announcement_reminder' => announcement,
        'holiday_added' => holiday,
        _ when type.startsWith('task_') => task,
        _ => none,
      };

  String get emoji => switch (this) {
        account => AppEmojis.user,
        schedule => AppEmojis.calendarSpiral,
        request => AppEmojis.inbox,
        announcement => AppEmojis.megaphone,
        holiday => AppEmojis.holiday,
        task => AppEmojis.checkBox,
        none => AppEmojis.bell,
      };
}

class NotificationModel extends Equatable {
  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.contentId,
    required this.isRead,
    required this.createdAt,
  });

  final int id;
  final String type;
  final String title;
  final String body;
  final int? contentId;
  final bool isRead;
  final DateTime? createdAt;

  NotificationScreen get screen => NotificationScreen.ofType(type);

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final data = JsonReader.map(json['data']);
    return NotificationModel(
      id: JsonReader.toInt(json['id']),
      type: JsonReader.string(json['type'] ?? data['type']),
      title: JsonReader.string(json['title']),
      body: JsonReader.string(json['body']),
      contentId: JsonReader.intOrNull(data['content_id']),
      isRead: JsonReader.toBool(json['is_read']),
      createdAt: JsonReader.dateTime(json['created_at']),
    );
  }

  NotificationModel markRead() => NotificationModel(
        id: id,
        type: type,
        title: title,
        body: body,
        contentId: contentId,
        isRead: true,
        createdAt: createdAt,
      );

  @override
  List<Object?> get props =>
      [id, type, title, body, contentId, isRead, createdAt];
}
