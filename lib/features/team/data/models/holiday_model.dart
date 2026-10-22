import 'package:equatable/equatable.dart';

import '../../../../core/utils/json_reader.dart';

class HolidayModel extends Equatable {
  const HolidayModel({required this.date, required this.name, this.id = 0});

  final int id;
  final DateTime date;
  final String name;

  factory HolidayModel.fromJson(Map<String, dynamic> json) => HolidayModel(
        id: JsonReader.toInt(json['id']),
        date: JsonReader.date(json['date']) ?? DateTime.now(),
        name: JsonReader.string(json['name']),
      );

  @override
  List<Object?> get props => [id, date, name];
}
