import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/utils/app_colors.dart';
import '../../core/utils/app_constants.dart';

class AppTheme {
  AppTheme._();

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    Color pick(ColorModel c) => isDark ? c.dark : c.light;
    return ThemeData(
      brightness: brightness,
      fontFamily: AppFonts.familyFont,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: pick(AppColors.primaryColor),
        primary: pick(AppColors.primaryColor),
        surface: pick(AppColors.cardColor),
        error: pick(AppColors.errorColor),
        brightness: brightness,
      ),
      scaffoldBackgroundColor: pick(AppColors.backgroundColor),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      dividerColor: pick(AppColors.dividerColor),
      appBarTheme: AppBarTheme(
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  static ThemeData get lightTheme => _build(Brightness.light);

  static ThemeData get darkTheme => _build(Brightness.dark);
}
