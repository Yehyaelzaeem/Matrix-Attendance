import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/choice_chips.dart';
import '../../../../core/widgets/field_label.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../requests/data/models/request_model.dart';
import '../../logic/approvals_cubit.dart';
import 'requester_role_chip.dart';

class RejectRequestSheet extends StatefulWidget {
  const RejectRequestSheet({super.key, required this.request});

  final RequestModel request;

  @override
  State<RejectRequestSheet> createState() => _RejectRequestSheetState();
}

class _RejectRequestSheetState extends State<RejectRequestSheet> {
  final _reason = TextEditingController();
  String? _quick;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final navigator = Navigator.of(context);
    final ok = await context
        .read<ApprovalsCubit>()
        .reject(widget.request, _reason.text.trim());
    if (ok) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final quick = [
      LocaleKeys.admin_qrDelivery.tr(),
      LocaleKeys.admin_qrManyOff.tr(),
      LocaleKeys.admin_qrPm.tr(),
      LocaleKeys.admin_qrLate.tr(),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Flexible(
              child: AppText(
                LocaleKeys.admin_rejectTitle.tr(namedArgs: {
                  'name': Validators.firstName(widget.request.employee ?? '')
                }),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(width: 6.w),
            RequesterRoleChip(widget.request.requesterRole),
          ],
        ),
        SizedBox(height: 4.h),
        AppText('${widget.request.type.label} · ${widget.request.title}',
            fontSize: 13, color: AppColors.textSecondaryColor.themeColor),
        SizedBox(height: 14.h),
        LabeledField(
          label: LocaleKeys.admin_quickReasons.tr(),
          child: ChoiceChipsPicker<String>(
            items: [for (final q in quick) ChoiceItem(q, q)],
            isSelected: (q) => q == _quick,
            onTap: (q) => setState(() {
              _quick = q;
              _reason.text = q;
            }),
          ),
        ),
        LabeledField(
          label: LocaleKeys.admin_rejectReason.tr(),
          badge: StatusChip(
              small: true,
              label: LocaleKeys.common_required.tr(),
              tone: ChipTone.red),
          child: CustomTextField(
            controller: _reason,
            hint: LocaleKeys.admin_rejectHint.tr(),
            minLines: 3,
            maxLines: 5,
            onChanged: (_) => setState(() {}),
          ),
        ),
        CustomButton(
          title: LocaleKeys.admin_rejectConfirm.tr(),
          gradient: AppColors.dangerGradient,
          enabled: _reason.text.trim().length >= 4,
          onTap: _confirm,
        ),
      ],
    );
  }
}
