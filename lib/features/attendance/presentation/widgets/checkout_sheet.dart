import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/attendance_day.dart';
import '../../logic/attendance_cubit.dart';
import 'checkout_summary_view.dart';
import 'success_mark.dart';
import 'summary_grid.dart';

class CheckoutSheet extends StatefulWidget {
  const CheckoutSheet({super.key, required this.day});

  final AttendanceDay day;

  @override
  State<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<CheckoutSheet> {
  final DateTime _now = DateTime.now();
  bool _loading = false;
  AttendanceDay? _result;

  Future<void> _confirm() async {
    setState(() => _loading = true);
    final day = await context.read<AttendanceCubit>().checkOut();
    if (!mounted) return;
    setState(() {
      _loading = false;
      _result = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_result != null) return CheckoutSummaryView(day: _result!);
    final worked = widget.day.workedSeconds(_now);
    final diff = worked - widget.day.requiredSeconds;
    final complete = diff >= 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: complete
              ? const SuccessMark()
              : SuccessMark(
                  emoji: AppEmojis.hourglass,
                  background: AppColors.warningSoftColor.themeColor,
                ),
        ),
        AppText(
          complete
              ? LocaleKeys.attendance_hoursDone.tr()
              : LocaleKeys.attendance_hoursNotDone.tr(),
          fontSize: 18,
          fontWeight: FontWeight.w800,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        AppText(
          complete
              ? LocaleKeys.attendance_confirmOut.tr()
              : LocaleKeys.attendance_deficitWarning.tr(),
          textAlign: TextAlign.center,
          color: AppColors.textSecondaryColor.themeColor,
        ),
        SummaryGrid(items: [
          SummaryItem(
              LocaleKeys.attendance_workedShort.tr(), DateHelper.hms(worked)),
          SummaryItem(
            complete
                ? LocaleKeys.attendance_extra.tr()
                : LocaleKeys.attendance_missing.tr(),
            DateHelper.hms(diff.abs()),
            color: complete
                ? AppColors.successColor.themeColor
                : AppColors.errorColor.themeColor,
          ),
        ]),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                title: LocaleKeys.common_back.tr(),
                type: ButtonStyleType.ghost,
                onTap: () => context.pop(),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: CustomButton(
                title: LocaleKeys.attendance_checkOut.tr(),
                gradient: AppColors.dangerGradient,
                loading: _loading,
                onTap: _confirm,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
