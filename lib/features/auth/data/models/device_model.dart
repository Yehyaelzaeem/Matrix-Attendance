import 'package:equatable/equatable.dart';

import '../../../../core/utils/json_reader.dart';

class DeviceModel extends Equatable {
  const DeviceModel({
    required this.id,
    required this.uuid,
    required this.platform,
    this.model,
    this.registeredAt,
    this.isActive = true,
  });

  final int id;
  final String uuid;
  final String platform;
  final String? model;
  final DateTime? registeredAt;
  final bool isActive;

  factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
        id: JsonReader.toInt(json['id']),
        uuid: JsonReader.string(json['device_uuid']),
        platform: JsonReader.string(json['platform']),
        model: JsonReader.stringOrNull(json['model']),
        registeredAt: JsonReader.dateTime(json['registered_at']),
        isActive: JsonReader.toBool(json['is_active']),
      );

  @override
  List<Object?> get props =>
      [id, uuid, platform, model, registeredAt, isActive];
}
