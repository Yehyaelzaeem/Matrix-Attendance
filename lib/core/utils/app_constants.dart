class AppConstants {
  AppConstants._();

  static const String appName = 'Matrix Attendance';
  static const String companyName = 'Matrix Clouds';
  static const String countryCode = '+20';

  static const int pageSize = 15;
  static const int firstPage = 1;
  static const int otpLength = 6;
  static const int otpResendSeconds = 60;
  static const int maxAttachmentMb = 50;

  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  static const Duration mockLatency = Duration(milliseconds: 450);

  static const double defaultBorderRadius = 16.0;
  static const double cardBorderRadius = 20.0;
  static const double buttonBorderRadius = 16.0;
  static const double buttonHeight = 56.0;
  static const double defaultPadding = 16.0;
  static const double screenPadding = 20.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  static const int officeStartHour = 9;
  static const int latestArrivalHour = 10;
  static const int latestArrivalMinute = 30;
}

class AppFonts {
  static const String familyFont = 'Cairo';
  static const String numbersFont = 'FiraSans';
}
