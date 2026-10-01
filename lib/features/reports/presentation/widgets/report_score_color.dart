import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class ReportScoreColor {
  ReportScoreColor._();

  static Color of(int score) {
    if (score >= 90) return AppColors.successColor.themeColor;
    if (score >= 75) return AppColors.primaryColor.themeColor;
    if (score >= 60) return AppColors.warningDeepColor.themeColor;
    return AppColors.errorColor.themeColor;
  }
}
