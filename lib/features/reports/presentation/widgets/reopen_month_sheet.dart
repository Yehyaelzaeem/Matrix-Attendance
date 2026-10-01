import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/field_label.dart';
import '../../logic/reports_cubit.dart';

class ReopenMonthSheet extends StatefulWidget {
  const ReopenMonthSheet({super.key});

  @override
  State<ReopenMonthSheet> createState() => _ReopenMonthSheetState();
}

class _ReopenMonthSheetState extends State<ReopenMonthSheet> {
  final _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(LocaleKeys.reports_reopenTitle.tr(),
            fontSize: 18, fontWeight: FontWeight.w800),
        SizedBox(height: 14.h),
        LabeledField(
          label: LocaleKeys.reports_reopenReason.tr(),
          child: CustomTextField(
            controller: _reason,
            hint: LocaleKeys.reports_reopenHint.tr(),
            minLines: 3,
            maxLines: 5,
            onChanged: (_) => setState(() {}),
          ),
        ),
        CustomButton(
          title: LocaleKeys.reports_reopenButton.tr(),
          enabled: _reason.text.trim().length >= 5,
          onTap: () {
            getIt<ReportsCubit>().reopenMonth(_reason.text.trim());
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
