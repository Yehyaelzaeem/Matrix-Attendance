import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'date_helper.dart';

class AppPickers {
  AppPickers._();

  static Widget _theme(BuildContext context, Widget? child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryColor.themeColor,
            onPrimary: Colors.white,
            onSurface: AppColors.textPrimaryColor.themeColor,
          ),
        ),
        child: child!,
      );

  static Future<DateTime?> pickDate(BuildContext context, {DateTime? initial}) {
    final now = DateHelper.today();
    return showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 730)),
      builder: _theme,
    );
  }

  static Future<TimeOfDay?> pickTime(BuildContext context,
      {TimeOfDay? initial}) {
    return showTimePicker(
      context: context,
      initialTime: initial ?? TimeOfDay.now(),
      builder: _theme,
    );
  }
}
