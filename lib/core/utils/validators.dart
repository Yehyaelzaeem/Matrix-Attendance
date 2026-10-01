class Validators {
  Validators._();

  static final RegExp _egyptianMobile = RegExp(r'^01[0125]\d{8}$');

  static bool isValidPhone(String value) =>
      _egyptianMobile.hasMatch(value.trim());

  static bool isFullName(String value) =>
      value.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length >= 2;

  static String initials(String name) {
    final words = name
        .replaceAll('م. ', '')
        .replaceAll('د. ', '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2);
    return words.map((w) => String.fromCharCode(w.runes.first)).join();
  }

  static String firstName(String name) =>
      name.replaceAll('م. ', '').trim().split(RegExp(r'\s+')).first;

  static String maskedPhone(String phone) {
    if (phone.length < 8) return phone;
    return '+20 ${phone.substring(1, 4)} ••• ${phone.substring(phone.length - 4)}';
  }

  static String internationalPhone(String phone) =>
      phone.startsWith('0') ? '+20 ${phone.substring(1)}' : phone;
}
