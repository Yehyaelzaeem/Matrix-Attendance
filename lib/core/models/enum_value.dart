import 'package:equatable/equatable.dart';

import '../utils/json_reader.dart';

class EnumValue extends Equatable {
  const EnumValue({required this.key, required this.value, this.icon});

  final String key;
  final String value;
  final String? icon;

  static EnumValue? fromJson(dynamic json) {
    final map = JsonReader.mapOrNull(json);
    if (map == null) return null;
    return EnumValue(
      key: JsonReader.string(map['key']),
      value: JsonReader.string(map['value']),
      icon: JsonReader.stringOrNull(map['icon']),
    );
  }

  static String keyOf(dynamic json) =>
      json is Map ? JsonReader.string(json['key']) : JsonReader.string(json);

  @override
  List<Object?> get props => [key, value, icon];
}
