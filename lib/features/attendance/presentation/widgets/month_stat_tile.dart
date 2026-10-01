import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/emoji_box.dart';

class MonthStatTile extends StatelessWidget {
  const MonthStatTile({
    super.key,
    required this.emoji,
    required this.background,
    required this.value,
    required this.label,
    this.unit,
  });

  final String emoji;
  final Color background;
  final String value;
  final String label;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmojiBox(
              emoji: emoji,
              background: background,
              size: 36,
              radius: 12,
              fontSize: 17),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(value,
                  numeric: true, fontSize: 22, fontWeight: FontWeight.w700),
              if (unit != null)
                AppText(' $unit',
                    fontSize: 13,
                    color: AppColors.textSecondaryColor.themeColor),
            ],
          ),
          AppText(label,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              maxLines: 1,
              color: AppColors.textSecondaryColor.themeColor),
        ],
      ),
    );
  }
}
