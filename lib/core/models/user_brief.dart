import 'package:equatable/equatable.dart';

import '../utils/json_reader.dart';

class UserBrief extends Equatable {
  const UserBrief({required this.id, required this.name, this.image, this.job});

  final int id;
  final String name;
  final String? image;
  final String? job;

  static UserBrief? fromJson(dynamic json) {
    final map = JsonReader.mapOrNull(json);
    if (map == null) return null;
    final jobName = map['job_name'] ?? map['job'];
    return UserBrief(
      id: JsonReader.toInt(map['id'] ?? map['user_id']),
      name: JsonReader.string(map['name']),
      image: JsonReader.stringOrNull(map['image']),
      job: jobName is Map
          ? JsonReader.stringOrNull(jobName['name'])
          : JsonReader.stringOrNull(jobName),
    );
  }

  @override
  List<Object?> get props => [id, name, image, job];
}
