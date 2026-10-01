import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../data/models/decision_model.dart';

class DecisionCardFrame extends StatelessWidget {
  const DecisionCardFrame({
    super.key,
    required this.decision,
    required this.footerStart,
    required this.children,
    this.showAudience = false,
  });

  final DecisionModel decision;
  final String footerStart;
  final List<Widget> children;
  final bool showAudience;

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.textSecondaryColor.themeColor;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              StatusChip(label: decision.kind.label, tone: decision.kind.tone),
              const Spacer(),
              if (decision.deadline != null)
                AppText('${AppEmojis.hourglass} ${decision.deadline}',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warningTextColor.themeColor)
              else if (showAudience)
                StatusChip(
                    label: '${AppEmojis.users} ${decision.audience.label}'),
            ],
          ),
          SizedBox(height: 8.h),
          AppText(decision.title, fontSize: 16, fontWeight: FontWeight.w700),
          SizedBox(height: 6.h),
          AppText(decision.body,
              fontSize: 13.5,
              height: 1.9,
              color: AppColors.textBodyColor.themeColor),
          ...children,
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(child: AppText(footerStart, fontSize: 12, color: muted)),
              AppText(decision.when, fontSize: 12, color: muted),
            ],
          ),
        ],
      ),
    );
  }
}
