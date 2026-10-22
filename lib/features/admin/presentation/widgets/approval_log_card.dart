import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/person_row.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../requests/data/models/request_model.dart';
import '../../../requests/presentation/widgets/reason_box.dart';
import 'approval_box.dart';
import 'requester_role_chip.dart';

class ApprovalLogCard extends StatelessWidget {
  const ApprovalLogCard({super.key, required this.request, this.index = 0});

  final RequestModel request;
  final int index;

  @override
  Widget build(BuildContext context) {
    final approved = request.status == RequestStatus.approved;
    return ApprovalBox(
      index: index,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PersonRow(
            name: request.employee ?? '',
            subtitle: '${request.type.label} – ${request.title}',
            titleBadge: RequesterRoleChip(request.requesterRole),
            trailing: StatusChip(
              label: approved
                  ? LocaleKeys.admin_outcomeApproved.tr()
                  : LocaleKeys.admin_outcomeRejected.tr(),
              tone: approved ? ChipTone.green : ChipTone.red,
            ),
          ),
          if (!approved && request.rejectReason != null)
            ReasonBox(
              label: LocaleKeys.requests_rejectLabel.tr(),
              text: request.rejectReason!,
              danger: true,
            ),
          SizedBox(height: 8.h),
          AppText(request.decidedWhen,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryColor.themeColor),
        ],
      ),
    );
  }
}
