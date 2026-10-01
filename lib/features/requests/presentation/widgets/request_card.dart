import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/emoji_box.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../data/models/request_model.dart';
import 'reason_box.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({super.key, required this.request, this.index = 0});

  final RequestModel request;
  final int index;

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.textSecondaryColor.themeColor;
    final footer = request.decidedBy != null
        ? LocaleKeys.common_by.tr(namedArgs: {'name': request.decidedBy!})
        : request.status == RequestStatus.pending
            ? LocaleKeys.requests_waitingAdmin.tr()
            : '';
    return FadeSlideIn(
      delay: Duration(milliseconds: index * 50),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                EmojiBox(
                  emoji: request.type.emoji,
                  background: request.type.softColor,
                  size: 42,
                  fontSize: 20,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(request.title,
                          fontSize: 14.5, fontWeight: FontWeight.w700),
                      AppText('${request.type.label} · ${request.subtitle}',
                          fontSize: 12, color: muted),
                    ],
                  ),
                ),
              ],
            ),
            ReasonBox(
                label: LocaleKeys.requests_reasonLabel.tr(),
                text: request.reason),
            if (request.status == RequestStatus.rejected &&
                request.rejectReason != null)
              ReasonBox(
                label: LocaleKeys.requests_rejectLabel.tr(),
                text: request.rejectReason!,
                danger: true,
              ),
            SizedBox(height: 10.h),
            Row(
              children: [
                StatusChip(
                    label: request.status.label, tone: request.status.tone),
                const Spacer(),
                AppText(request.when,
                    fontSize: 11.5, fontWeight: FontWeight.w600, color: muted),
                const Spacer(),
                AppText(footer,
                    fontSize: 11.5, fontWeight: FontWeight.w600, color: muted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
