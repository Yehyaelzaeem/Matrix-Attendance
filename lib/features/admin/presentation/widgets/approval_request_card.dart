import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/person_row.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../requests/data/models/request_model.dart';
import '../../../requests/presentation/widgets/reason_box.dart';
import '../../logic/approvals_cubit.dart';
import 'approval_box.dart';
import 'decision_buttons.dart';
import 'reject_request_sheet.dart';
import 'requester_role_chip.dart';

class ApprovalRequestCard extends StatelessWidget {
  const ApprovalRequestCard({super.key, required this.request, this.index = 0});

  final RequestModel request;
  final int index;

  @override
  Widget build(BuildContext context) {
    final name = request.employee ?? '';
    final job = request.employeeJob ?? '';
    return ApprovalBox(
      index: index,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PersonRow(
              name: name,
              avatarImage: request.employeeImage,
              subtitle: job,
              titleBadge: RequesterRoleChip(request.requesterRole),
              trailing: StatusChip(label: request.when)),
          ReasonBox(
            label: request.title,
            text: '· ${request.subtitle}\n${request.reason}',
            header: StatusChip(
              small: true,
              label: '${request.type.emoji} ${request.type.label}',
              background: request.type.softColor,
            ),
          ),
          DecisionButtons(
            rejectLabel: LocaleKeys.admin_reject.tr(),
            acceptLabel: LocaleKeys.admin_approve.tr(),
            onReject: () => AppSheet.show(context,
                child: RejectRequestSheet(request: request)),
            onAccept: () => context.read<ApprovalsCubit>().approve(request),
          ),
        ],
      ),
    );
  }
}
