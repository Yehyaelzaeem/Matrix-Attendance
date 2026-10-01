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
import 'success_mark.dart';
import 'summary_grid.dart';
import 'whatsapp_messages.dart';
import 'whatsapp_preview.dart';

class ResumeResultView extends StatelessWidget {
  const ResumeResultView({super.key, required this.day});

  final AttendanceDay day;

  @override
  Widget build(BuildContext context) {
    final name = context.read<AuthCubit>().currentUser?.name ?? '';
    final pause = day.pauses.last;
    final now = pause.end ?? DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(child: SuccessMark(emoji: AppEmojis.play)),
        AppText(LocaleKeys.attendance_welcomeBack.tr(),
            fontSize: 18,
            fontWeight: FontWeight.w800,
            textAlign: TextAlign.center),
        SizedBox(height: 4.h),
        AppText(LocaleKeys.attendance_resumedDesc.tr(),
            textAlign: TextAlign.center,
            color: AppColors.textSecondaryColor.themeColor),
        SummaryGrid(items: [
          SummaryItem(LocaleKeys.attendance_pauseDuration.tr(),
              DateHelper.hms(pause.seconds(now))),
          SummaryItem(LocaleKeys.attendance_expectedOut.tr(),
              DateHelper.time12(day.expectedCheckout(now)!)),
        ]),
        WhatsappPreview(message: WhatsappMessages.resume(name, pause)),
        SizedBox(height: 16.h),
        CustomButton(
            title: LocaleKeys.common_ok.tr(), onTap: () => context.pop()),
      ],
    );
  }
}
