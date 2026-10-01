import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_pickers.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/field_label.dart';
import '../../../../core/widgets/select_field.dart';
import '../../logic/team_cubit.dart';

class AddHolidaySheet extends StatefulWidget {
  const AddHolidaySheet({super.key});

  @override
  State<AddHolidaySheet> createState() => _AddHolidaySheetState();
}

class _AddHolidaySheetState extends State<AddHolidaySheet> {
  final _name = TextEditingController();
  DateTime _date = DateHelper.fromToday(10);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final navigator = Navigator.of(context);
    await getIt<TeamCubit>().addHoliday(_date, _name.text.trim());
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(LocaleKeys.team_newHolidayTitle.tr(),
            fontSize: 18, fontWeight: FontWeight.w800),
        SizedBox(height: 14.h),
        LabeledField(
          label: LocaleKeys.common_date.tr(),
          child: SelectField(
            placeholder: '',
            value: DateHelper.fullDate(_date),
            icon: Icons.event_outlined,
            onTap: () async {
              final picked = await AppPickers.pickDate(context, initial: _date);
              if (picked != null) setState(() => _date = picked);
            },
          ),
        ),
        LabeledField(
          label: LocaleKeys.team_occasion.tr(),
          child: CustomTextField(
            controller: _name,
            hint: LocaleKeys.team_occasionHint.tr(),
            onChanged: (_) => setState(() {}),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: AppText(LocaleKeys.team_holidayNote.tr(),
              fontSize: 11.5, color: AppColors.textSecondaryColor.themeColor),
        ),
        CustomButton(
          title: LocaleKeys.common_add.tr(),
          enabled: _name.text.trim().length >= 3,
          onTap: _add,
        ),
      ],
    );
  }
}
