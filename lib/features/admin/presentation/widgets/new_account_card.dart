import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/person_row.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../requests/presentation/widgets/reason_box.dart';
import '../../data/models/approval_models.dart';
import '../../logic/approvals_cubit.dart';
import 'activate_account_sheet.dart';
import 'approval_box.dart';
import 'decision_buttons.dart';

class NewAccountCard extends StatelessWidget {
  const NewAccountCard({super.key, required this.account, this.index = 0});

  final NewAccountModel account;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ApprovalBox(
      index: index,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PersonRow(
            name: account.name,
            subtitle: account.jobTitle,
            trailing: StatusChip(
                label: LocaleKeys.admin_newChip.tr(), tone: ChipTone.blue),
          ),
          ReasonBox(
            label: LocaleKeys.admin_mobile.tr(),
            text: '${Validators.internationalPhone(account.phone)}\n'
                '${LocaleKeys.admin_registered.tr()} ${account.when}',
          ),
          DecisionButtons(
            rejectLabel: LocaleKeys.admin_reject.tr(),
            acceptLabel: LocaleKeys.admin_activate.tr(),
            acceptType: ButtonStyleType.primary,
            onReject: () => getIt<ApprovalsCubit>().denyAccount(account),
            onAccept: () => AppSheet.show(context,
                child: ActivateAccountSheet(account: account)),
          ),
        ],
      ),
    );
  }
}
