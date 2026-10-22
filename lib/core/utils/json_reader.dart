class JsonReader {
  JsonReader._();

  static Map<String, dynamic> map(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

  static Map<String, dynamic>? mapOrNull(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : null;

  static List<Map<String, dynamic>> list(dynamic value) => value is List
      ? value.whereType<Map>().map(Map<String, dynamic>.from).toList()
      : const [];

  static int toInt(dynamic value, [int fallback = 0]) =>
      intOrNull(value) ?? fallback;

  static int? intOrNull(dynamic value) => switch (value) {
        int v => v,
        num v => v.round(),
        String v => int.tryParse(v) ?? double.tryParse(v)?.round(),
        _ => null,
      };

  static double toDouble(dynamic value, [double fallback = 0]) =>
      doubleOrNull(value) ?? fallback;

  static double? doubleOrNull(dynamic value) => switch (value) {
        num v => v.toDouble(),
        String v => double.tryParse(v),
        _ => null,
      };

  static String string(dynamic value, [String fallback = '']) =>
      value == null ? fallback : value.toString();

  static String? stringOrNull(dynamic value) {
    if (value == null) return null;
    final s = value.toString();
    return s.isEmpty ? null : s;
  }

  static bool toBool(dynamic value) => switch (value) {
        bool v => v,
        num v => v != 0,
        String v => v == 'true' || v == '1',
        _ => false,
      };

  static DateTime? dateTime(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value)?.toLocal();
  }

  static DateTime? date(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    final parsed = DateTime.tryParse(value);
    return parsed == null
        ? null
        : DateTime(parsed.year, parsed.month, parsed.day);
  }

  static String formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  static String formatMonth(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}';

  static String formatTime(int hour, int minute) =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
