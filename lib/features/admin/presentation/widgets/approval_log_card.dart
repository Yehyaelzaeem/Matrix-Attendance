import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/person_row.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../requests/presentation/widgets/reason_box.dart';
import '../../data/models/approval_models.dart';
import 'approval_box.dart';

class ApprovalLogCard extends StatelessWidget {
  const ApprovalLogCard({super.key, required this.entry, this.index = 0});

  final ApprovalLogEntry entry;
  final int index;

  @override
  Widget build(BuildContext context) {
    final (label, tone) = switch (entry.outcome) {
      LogOutcome.approved => (
          LocaleKeys.admin_outcomeApproved.tr(),
          ChipTone.green
        ),
      LogOutcome.activated => (
          LocaleKeys.admin_outcomeActivated.tr(),
          ChipTone.blue
        ),
      LogOutcome.rejected => (
          LocaleKeys.admin_outcomeRejected.tr(),
          ChipTone.red
        ),
    };
    return ApprovalBox(
      index: index,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PersonRow(
            name: entry.name,
            subtitle: entry.what,
            trailing: StatusChip(label: label, tone: tone),
          ),
          if (entry.reason != null)
            ReasonBox(
              label: LocaleKeys.requests_rejectLabel.tr(),
              text: entry.reason!,
              danger: true,
            ),
          SizedBox(height: 8.h),
          AppText(entry.when,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryColor.themeColor),
        ],
      ),
    );
  }
}
