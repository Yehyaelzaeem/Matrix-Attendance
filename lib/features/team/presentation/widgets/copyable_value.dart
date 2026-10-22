import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class CopyableValue extends StatelessWidget {
  const CopyableValue(this.text,
      {super.key, this.numeric = false, this.fontSize = 14});

  final String text;
  final bool numeric;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: AppColors.dashedBorderColor.themeColor, width: 1),
        ),
      ),
      child: AppText(text,
          numeric: numeric,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          textDirection: TextDirection.ltr,
          maxLines: 1),
    );
  }
}
