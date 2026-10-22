import 'package:equatable/equatable.dart';

import '../../../../core/utils/json_reader.dart';

class JobCategoryModel extends Equatable {
  const JobCategoryModel({required this.id, required this.name});

  final int id;
  final String name;

  factory JobCategoryModel.fromJson(Map<String, dynamic> json) =>
      JobCategoryModel(
        id: JsonReader.toInt(json['id']),
        name: JsonReader.string(json['name']),
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}

class JobNameModel extends Equatable {
  const JobNameModel({required this.id, required this.name, this.category});

  final int id;
  final String name;
  final JobCategoryModel? category;

  static JobNameModel? fromJson(dynamic json) {
    final map = JsonReader.mapOrNull(json);
    if (map == null) return null;
    final category = JsonReader.mapOrNull(map['category']);
    return JobNameModel(
      id: JsonReader.toInt(map['id']),
      name: JsonReader.string(map['name']),
      category: category == null ? null : JobCategoryModel.fromJson(category),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category?.toJson(),
      };

  @override
  List<Object?> get props => [id, name, category];
}
