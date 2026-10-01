import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/info_box.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../auth/logic/auth_cubit.dart';
import '../../data/models/attendance_day.dart';
import 'success_mark.dart';
import 'summary_grid.dart';
import 'whatsapp_messages.dart';
import 'whatsapp_preview.dart';

class CheckInResultView extends StatelessWidget {
  const CheckInResultView(
      {super.key, required this.day, required this.onSubmitRequest});

  final AttendanceDay day;
  final VoidCallback onSubmitRequest;

  @override
  Widget build(BuildContext context) {
    final name = context.read<AuthCubit>().currentUser?.name ?? '';
    final checkIn = day.checkIn!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(child: SuccessMark()),
        AppText(LocaleKeys.attendance_checkedIn.tr(),
            fontSize: 18,
            fontWeight: FontWeight.w800,
            textAlign: TextAlign.center),
        SizedBox(height: 4.h),
        AppText(
          LocaleKeys.attendance_checkedInFrom.tr(namedArgs: {
            'place': WhatsappMessages.place(day.location),
            'time': DateHelper.time12(checkIn),
          }),
          textAlign: TextAlign.center,
          color: AppColors.textSecondaryColor.themeColor,
        ),
        SizedBox(height: 10.h),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6.w,
          runSpacing: 6.h,
          children: [
            StatusChip(
                label: day.arrival.label(day.lateMinutes),
                tone: day.arrival.tone),
            if (day.mismatch)
              StatusChip(
                  label: LocaleKeys.attendance_scheduleOfficeToday.tr(),
                  tone: ChipTone.orange),
          ],
        ),
        SummaryGrid(items: [
          SummaryItem(LocaleKeys.attendance_requiredLabel.tr(),
              '${day.requiredHours}:00:00'),
          SummaryItem(LocaleKeys.attendance_expectedOut.tr(),
              DateHelper.time12(day.expectedCheckout(checkIn)!)),
        ]),
        if (day.mismatch)
          InfoBox(
            text: LocaleKeys.attendance_mismatchNote.tr(),
            tone: InfoTone.orange,
            margin: EdgeInsets.only(bottom: 12.h),
          ),
        WhatsappPreview(message: WhatsappMessages.checkIn(name, day)),
        SizedBox(height: 16.h),
        Row(
          children: [
            if (day.mismatch) ...[
              Expanded(
                child: CustomButton(
                  title: LocaleKeys.attendance_submitRequest.tr(),
                  type: ButtonStyleType.ghost,
                  onTap: onSubmitRequest,
                ),
              ),
              SizedBox(width: 8.w),
            ],
            Expanded(
              child: CustomButton(
                title: LocaleKeys.common_ok.tr(),
                onTap: () => context.pop(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
