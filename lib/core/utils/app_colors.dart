import 'package:app_base/app/router/navigation_services.dart';
import 'package:flutter/material.dart';

class ColorModel {
  final Color lightColor;
  final Color darkColor;

  const ColorModel({required this.lightColor, required this.darkColor});

  const ColorModel.same(Color color)
      : lightColor = color,
        darkColor = color;

  Color get light => lightColor;
  Color get dark => darkColor;
}

extension ColorTheme on ColorModel {
  Color get themeColor {
    final context = NavigationService.navigationKey.currentContext;
    if (context != null && Theme.of(context).brightness == Brightness.dark) {
      return darkColor;
    } else {
      return lightColor;
    }
  }
}

class AppColors {
  AppColors._();

  static const ColorModel primaryColor = ColorModel.same(Color(0xff0f67f6));
  static const ColorModel primaryDarkColor = ColorModel.same(Color(0xff074dc0));
  static const ColorModel primarySoftColor = ColorModel(
    lightColor: Color(0xffe8f0ff),
    darkColor: Color(0xff14284d),
  );
  static const ColorModel secondaryColor = ColorModel.same(Color(0xff22a8ff));
  static const ColorModel cyanColor = ColorModel.same(Color(0xff22c3ff));
  static const ColorModel navyColor = ColorModel.same(Color(0xff071633));
  static const ColorModel navySecondColor = ColorModel.same(Color(0xff0b2a6b));

  static const ColorModel backgroundColor = ColorModel(
    lightColor: Color(0xfff4f7fd),
    darkColor: Color(0xff0b1220),
  );
  static const ColorModel surfaceColor = ColorModel(
    lightColor: Color(0xfff6f8fd),
    darkColor: Color(0xff1a2335),
  );
  static const ColorModel cardColor = ColorModel(
    lightColor: Color(0xffffffff),
    darkColor: Color(0xff141c2e),
  );
  static const ColorModel textPrimaryColor = ColorModel(
    lightColor: Color(0xff0b1220),
    darkColor: Color(0xffffffff),
  );
  static const ColorModel textSecondaryColor = ColorModel(
    lightColor: Color(0xff6b7690),
    darkColor: Color(0xffa3acc2),
  );
  static const ColorModel textBodyColor = ColorModel(
    lightColor: Color(0xff4b5670),
    darkColor: Color(0xffc2c9d8),
  );
  static const ColorModel dividerColor = ColorModel(
    lightColor: Color(0xffe6ebf5),
    darkColor: Color(0xff26304a),
  );
  static const ColorModel hintColor = ColorModel(
    lightColor: Color(0xffa3acc2),
    darkColor: Color(0xff6b7690),
  );
  static const ColorModel inactiveColor = ColorModel(
    lightColor: Color(0xff98a2b8),
    darkColor: Color(0xff6b7690),
  );
  static const ColorModel neutralSoftColor = ColorModel(
    lightColor: Color(0xffeef1f7),
    darkColor: Color(0xff1f2940),
  );
  static const ColorModel trackColor = ColorModel(
    lightColor: Color(0xffedf1f8),
    darkColor: Color(0xff1f2940),
  );
  static const ColorModel dashedBorderColor =
      ColorModel.same(Color(0xffc6d6f4));
  static const ColorModel idleStepColor = ColorModel.same(Color(0xffcfd6e4));
  static const ColorModel warningDashColor = ColorModel.same(Color(0xfff7d48b));
  static const ColorModel splashCaptionColor =
      ColorModel.same(Color(0xff8fb2f5));
  static const ColorModel headerDateColor = ColorModel.same(Color(0xffd9e6ff));
  static const ColorModel illustrationLineColor =
      ColorModel.same(Color(0xffe3ebfb));
  static const ColorModel illustrationTrackColor =
      ColorModel.same(Color(0xffedf2fb));
  static const ColorModel illustrationStrokeColor =
      ColorModel.same(Color(0xffcfdcf8));
  static const ColorModel radarInnerColor = ColorModel.same(Color(0xfff3f7ff));
  static const ColorModel radarOuterColor = ColorModel.same(Color(0xfff8faff));
  static const ColorModel passBorderColor = ColorModel.same(Color(0xffe1e9f7));
  static const ColorModel passSlotColor = ColorModel.same(Color(0xffeaf1ff));
  static const ColorModel passLineColor = ColorModel.same(Color(0xffe6edf9));
  static const ColorModel passLineSoftColor =
      ColorModel.same(Color(0xfff0f4fb));
  static const ColorModel ribbonEdgeColor = ColorModel.same(Color(0xff0b54d1));
  static const ColorModel clipLightColor = ColorModel.same(Color(0xffeef1f6));
  static const ColorModel clipDarkColor = ColorModel.same(Color(0xffa9b3c3));
  static const ColorModel clipSlotColor = ColorModel.same(Color(0xff7f8ba0));
  static const ColorModel authTopColor = ColorModel.same(Color(0xffeaf1ff));
  static const ColorModel authMiddleColor = ColorModel.same(Color(0xfff4f8ff));
  static const ColorModel meshDotColor = ColorModel.same(Color(0xffc7d7f5));
  static const ColorModel headerTextColor = ColorModel.same(Color(0xffbcd3ff));
  static const ColorModel infoTextColor = ColorModel.same(Color(0xff27447d));

  static const ColorModel successColor = ColorModel.same(Color(0xff16a34a));
  static const ColorModel successSoftColor = ColorModel(
    lightColor: Color(0xffe7f7ec),
    darkColor: Color(0xff123322),
  );
  static const ColorModel successTextColor = ColorModel.same(Color(0xff15803d));

  static const ColorModel warningColor = ColorModel.same(Color(0xfff59e0b));
  static const ColorModel warningSoftColor = ColorModel(
    lightColor: Color(0xfffff4dc),
    darkColor: Color(0xff3a2c10),
  );
  static const ColorModel warningTextColor = ColorModel.same(Color(0xffb45309));
  static const ColorModel warningDeepColor = ColorModel.same(Color(0xffd97706));
  static const ColorModel warningBorderColor =
      ColorModel.same(Color(0xfffde3a7));

  static const ColorModel errorColor = ColorModel.same(Color(0xffef4444));
  static const ColorModel errorSoftColor = ColorModel(
    lightColor: Color(0xfffdeaea),
    darkColor: Color(0xff3a1616),
  );
  static const ColorModel errorTextColor = ColorModel.same(Color(0xff991b1b));

  static const ColorModel orangeColor = ColorModel.same(Color(0xfff97316));
  static const ColorModel orangeSoftColor = ColorModel(
    lightColor: Color(0xffffeede),
    darkColor: Color(0xff3a2412),
  );
  static const ColorModel orangeTextColor = ColorModel.same(Color(0xffc2410c));
  static const ColorModel orangeDeepColor = ColorModel.same(Color(0xff9a3412));

  static const ColorModel violetColor = ColorModel.same(Color(0xff7c3aed));
  static const ColorModel violetSoftColor = ColorModel(
    lightColor: Color(0xfff1eafe),
    darkColor: Color(0xff261a40),
  );

  static const ColorModel whatsappSoftColor =
      ColorModel.same(Color(0xffe7fbe6));
  static const ColorModel whatsappTextColor =
      ColorModel.same(Color(0xff14532d));

  static const List<Color> avatarPalette = [
    Color(0xff0f67f6),
    Color(0xff7c3aed),
    Color(0xff0891b2),
    Color(0xffdb2777),
    Color(0xff16a34a),
    Color(0xffea580c),
    Color(0xff4f46e5),
    Color(0xff0d9488),
  ];

  static const LinearGradient primaryGradient = LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [Color(0xff0f67f6), Color(0xff22a8ff)],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment(-0.6, -1),
    end: Alignment(0.6, 1.4),
    colors: [Color(0xff071633), Color(0xff0b2a6b), Color(0xff0f67f6)],
    stops: [0, 0.55, 1.1],
  );

  static const LinearGradient dangerGradient = LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [Color(0xfff97316), Color(0xffef4444)],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [Color(0xfff59e0b), Color(0xfff97316)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [Color(0xff16a34a), Color(0xff22c55e)],
  );

  static const LinearGradient pinnedGradient = LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [Color(0xfffff7e6), Color(0xffffffff)],
  );
}
