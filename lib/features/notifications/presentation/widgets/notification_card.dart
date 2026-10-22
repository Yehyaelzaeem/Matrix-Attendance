import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/emoji_box.dart';
import '../../data/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.item, required this.onTap});

  final NotificationModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.textSecondaryColor.themeColor;
    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(14.r),
      color: item.isRead
          ? AppColors.cardColor.themeColor
          : AppColors.primarySoftColor.themeColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmojiBox(
            emoji: item.screen.emoji,
            background: AppColors.surfaceColor.themeColor,
            size: 40,
            radius: 13,
            fontSize: 17,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(item.title,
                    fontWeight:
                        item.isRead ? FontWeight.w600 : FontWeight.w800),
                if (item.body.isNotEmpty) ...[
                  SizedBox(height: 3.h),
                  AppText(item.body, fontSize: 12.5, height: 1.6, color: muted),
                ],
                if (item.createdAt != null) ...[
                  SizedBox(height: 4.h),
                  AppText(DateHelper.relative(item.createdAt!),
                      fontSize: 11, color: muted),
                ],
              ],
            ),
          ),
          if (!item.isRead)
            Container(
              width: 8.r,
              height: 8.r,
              margin: EdgeInsetsDirectional.only(start: 8.w, top: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.themeColor,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
