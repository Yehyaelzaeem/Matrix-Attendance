import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import 'report_score_color.dart';

class ScoreRing extends StatelessWidget {
  const ScoreRing({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final color = ReportScoreColor.of(score);
    return Container(
      width: 92.r,
      height: 92.r,
      margin: EdgeInsets.only(bottom: 10.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 8.r,
              color: color,
              backgroundColor: AppColors.trackColor.themeColor,
            ),
          ),
          AppText('$score%',
              numeric: true,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color),
        ],
      ),
    );
  }
}
