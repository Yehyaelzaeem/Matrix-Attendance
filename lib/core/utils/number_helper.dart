import 'package:intl/intl.dart';

class NumberHelper {
  NumberHelper._();

  static final NumberFormat _grouped = NumberFormat('#,###', 'en');

  static String money(double value, [String currency = '']) {
    final formatted = _grouped.format(value.round());
    return currency.isEmpty ? formatted : '$formatted $currency';
  }
}
