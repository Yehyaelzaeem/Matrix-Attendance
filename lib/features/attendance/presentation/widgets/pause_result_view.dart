import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../auth/logic/auth_cubit.dart';
import '../../data/models/attendance_day.dart';
import 'success_mark.dart';
import 'whatsapp_messages.dart';
import 'whatsapp_preview.dart';

class PauseResultView extends StatelessWidget {
  const PauseResultView({super.key, required this.pause});

  final PauseEntry pause;

  @override
  Widget build(BuildContext context) {
    final name = context.read<AuthCubit>().currentUser?.name ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: SuccessMark(
            emoji: AppEmojis.pause,
            background: AppColors.warningSoftColor.themeColor,
          ),
        ),
        AppText(LocaleKeys.attendance_pausedTitle.tr(),
            fontSize: 18,
            fontWeight: FontWeight.w800,
            textAlign: TextAlign.center),
        SizedBox(height: 4.h),
        AppText(LocaleKeys.attendance_pausedDesc.tr(),
            textAlign: TextAlign.center,
            color: AppColors.textSecondaryColor.themeColor),
        SizedBox(height: 14.h),
        WhatsappPreview(message: WhatsappMessages.pause(name, pause)),
        SizedBox(height: 16.h),
        CustomButton(
            title: LocaleKeys.common_ok.tr(), onTap: () => context.pop()),
      ],
    );
  }
}
