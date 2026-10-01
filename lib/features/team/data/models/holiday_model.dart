import 'package:equatable/equatable.dart';

class HolidayModel extends Equatable {
  const HolidayModel({required this.date, required this.name});

  final DateTime date;
  final String name;

  @override
  List<Object?> get props => [date, name];
}
