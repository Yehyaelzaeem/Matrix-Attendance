import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/app_pickers.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/field_label.dart';
import '../../../../core/widgets/select_field.dart';
import '../../data/models/project_model.dart';
import '../../logic/projects_cubit.dart';

class AddPaymentSheet extends StatefulWidget {
  const AddPaymentSheet({super.key, required this.project});

  final ProjectModel project;

  @override
  State<AddPaymentSheet> createState() => _AddPaymentSheetState();
}

class _AddPaymentSheetState extends State<AddPaymentSheet> {
  final _label = TextEditingController();
  final _amount = TextEditingController();
  DateTime _due = DateHelper.fromToday(14);

  @override
  void dispose() {
    _label.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amount.text) ?? 0;
    if (_label.text.trim().isEmpty || amount <= 0) {
      AppOverlay.showError(LocaleKeys.projects_fillPayment.tr());
      return;
    }
    final ok = await context
        .read<ProjectsCubit>()
        .addPayment(widget.project.id, _label.text.trim(), amount, _due);
    if (ok && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          LocaleKeys.projects_newPaymentTitle
              .tr(namedArgs: {'name': widget.project.name}),
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        SizedBox(height: 14.h),
        LabeledField(
          label: LocaleKeys.projects_paymentLabel.tr(),
          child: CustomTextField(
              controller: _label,
              hint: LocaleKeys.projects_paymentLabelHint.tr()),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LabeledField(
                label: LocaleKeys.projects_amount
                    .tr(namedArgs: {'cur': widget.project.currency}),
                child: CustomTextField(
                  controller: _amount,
                  hint: '0',
                  numeric: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textDirection: TextDirection.ltr,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: LabeledField(
                label: LocaleKeys.projects_dueDate.tr(),
                child: SelectField(
                  placeholder: '',
                  value: DateHelper.dayMonth(_due),
                  icon: Icons.event_outlined,
                  onTap: () async {
                    final picked =
                        await AppPickers.pickDate(context, initial: _due);
                    if (picked != null) setState(() => _due = picked);
                  },
                ),
              ),
            ),
          ],
        ),
        CustomButton(title: LocaleKeys.common_add.tr(), onTap: _save),
      ],
    );
  }
}
