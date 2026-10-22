import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/emoji_box.dart';
import '../../../../core/widgets/meter_bar.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../dashboard/data/models/dashboard_models.dart';

class ReviewProgressCard extends StatelessWidget {
  const ReviewProgressCard(
      {super.key, required this.review, required this.onOpenReports});

  final MonthReview review;
  final VoidCallback onOpenReports;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final total = review.total;
    final reviewed = review.reviewed;
    final pct = review.pct;
    final closed = review.closed;
    final daysLeft = review.isLastDay
        ? 0
        : DateTime(now.year, now.month + 1, 0).day - now.day;
    final checks = [
      (LocaleKeys.reviewer_checkReports.tr(), review.allReviewed),
      (LocaleKeys.reviewer_checkFixes.tr(), review.noPendingFixes),
    ];
    return AppCard(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              EmojiBox(
                emoji: AppEmojis.folders,
                background: AppColors.violetSoftColor.themeColor,
                fontSize: 21,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      LocaleKeys.reviewer_monthReview.tr(namedArgs: {
                        'month': DateHelper.monthName(review.month.month)
                      }),
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                    ),
                    AppText(
                      closed
                          ? LocaleKeys.reviewer_monthClosedSub.tr()
                          : daysLeft == 0
                              ? LocaleKeys.reviewer_lastDay.tr()
                              : LocaleKeys.reviewer_daysLeft
                                  .tr(namedArgs: {'n': '$daysLeft'}),
                      fontSize: 12.5,
                      color: AppColors.textSecondaryColor.themeColor,
                    ),
                  ],
                ),
              ),
              StatusChip(
                label: closed
                    ? LocaleKeys.reviewer_closedChip.tr()
                    : LocaleKeys.reviewer_openChip.tr(),
                tone: closed ? ChipTone.gray : ChipTone.yellow,
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: AppText(
                  LocaleKeys.reviewer_reviewedOf
                      .tr(namedArgs: {'a': '$reviewed', 'b': '$total'}),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppText('$pct%',
                  numeric: true,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor.themeColor),
            ],
          ),
          SizedBox(height: 8.h),
          MeterBar(value: pct / 100, gradient: AppColors.primaryGradient),
          SizedBox(height: 12.h),
          for (var i = 0; i < checks.length; i++)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                border: i == checks.length - 1
                    ? null
                    : Border(
                        bottom: BorderSide(
                            color: AppColors.dividerColor.themeColor)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24.r,
                    height: 24.r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: checks[i].$2 || closed
                          ? AppColors.successColor.themeColor
                          : AppColors.idleStepColor.themeColor,
                    ),
                    child: AppText(
                        checks[i].$2 || closed ? AppEmojis.check : '…',
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                      child:
                          AppText(checks[i].$1, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          SizedBox(height: 14.h),
          CustomButton(
            title: closed
                ? LocaleKeys.reviewer_viewReports.tr()
                : LocaleKeys.reviewer_continueReview.tr(),
            onTap: onOpenReports,
          ),
        ],
      ),
    );
  }
}
