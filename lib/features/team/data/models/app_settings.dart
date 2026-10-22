import '../../../../core/utils/json_reader.dart';

class AppSettings {
  const AppSettings({
    required this.officeHours,
    required this.homeHours,
    required this.dayStart,
    required this.graceUntil,
    required this.radius,
  });

  final int officeHours;
  final int homeHours;
  final String dayStart;
  final String graceUntil;
  final int radius;

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        officeHours: JsonReader.toInt(json['office_hours'], 8),
        homeHours: JsonReader.toInt(json['home_hours'], 10),
        dayStart: JsonReader.string(json['day_start'], '09:00'),
        graceUntil: JsonReader.string(json['grace_until'], '10:30'),
        radius: JsonReader.toInt(json['office_radius_m'], 150),
      );
}
