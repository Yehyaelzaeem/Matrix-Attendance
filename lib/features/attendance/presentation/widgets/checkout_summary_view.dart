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
import '../../../auth/logic/auth_cubit.dart';
import '../../data/models/attendance_day.dart';
import 'pause_line.dart';
import 'success_mark.dart';
import 'summary_grid.dart';
import 'whatsapp_messages.dart';
import 'whatsapp_preview.dart';

class CheckoutSummaryView extends StatelessWidget {
  const CheckoutSummaryView({super.key, required this.day});

  final AttendanceDay day;

  @override
  Widget build(BuildContext context) {
    final name = context.read<AuthCubit>().currentUser?.name ?? '';
    final out = day.checkOut!;
    final worked = day.workedSeconds(out);
    final diff = worked - day.requiredSeconds;
    final paused = day.pausedSeconds(out);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(child: SuccessMark(emoji: AppEmojis.wave)),
        AppText(LocaleKeys.attendance_dayClosedTitle.tr(),
            fontSize: 18,
            fontWeight: FontWeight.w800,
            textAlign: TextAlign.center),
        SizedBox(height: 4.h),
        AppText(LocaleKeys.attendance_thanks.tr(),
            textAlign: TextAlign.center,
            color: AppColors.textSecondaryColor.themeColor),
        SummaryGrid(items: [
          SummaryItem(LocaleKeys.attendance_metaIn.tr(),
              DateHelper.time12(day.checkIn!)),
          SummaryItem(
              LocaleKeys.attendance_metaOut.tr(), DateHelper.time12(out)),
          SummaryItem(
              LocaleKeys.attendance_totalWork.tr(), DateHelper.hms(worked)),
          SummaryItem(
            diff >= 0
                ? LocaleKeys.attendance_extra.tr()
                : LocaleKeys.attendance_missing.tr(),
            DateHelper.hms(diff.abs()),
            color: diff >= 0
                ? AppColors.successColor.themeColor
                : AppColors.errorColor.themeColor,
          ),
          if (paused > 0)
            SummaryItem(
              LocaleKeys.attendance_pauseSummary.tr(
                  namedArgs: {'n': PauseLine.countLabel(day.pauses.length)}),
              DateHelper.hms(paused),
              wide: true,
              background: AppColors.orangeSoftColor.themeColor,
            ),
        ]),
        WhatsappPreview(message: WhatsappMessages.checkOut(name, day)),
        SizedBox(height: 16.h),
        CustomButton(
            title: LocaleKeys.common_ok.tr(), onTap: () => context.pop()),
      ],
    );
  }
}
