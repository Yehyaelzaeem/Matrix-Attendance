import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/utils/number_helper.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/emoji_box.dart';
import '../../data/models/project_model.dart';
import '../../logic/projects_cubit.dart';

class PaymentRow extends StatelessWidget {
  const PaymentRow({
    super.key,
    required this.project,
    required this.index,
    required this.isLast,
  });

  final ProjectModel project;
  final int index;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final payment = project.payments[index];
    final due = payment.due ?? DateHelper.today();
    final diff = DateHelper.dayDiff(due);
    final overdue = !payment.paid && diff < 0;
    final muted = AppColors.textSecondaryColor.themeColor;
    final subtitle = payment.paid
        ? LocaleKeys.projects_paidOn
            .tr(namedArgs: {'date': DateHelper.dayMonth(payment.paidAt ?? due)})
        : overdue
            ? LocaleKeys.projects_overduePayment.tr(namedArgs: {
                'n': '${diff.abs()}',
                'date': DateHelper.dayMonth(due),
              })
            : LocaleKeys.projects_duePayment
                    .tr(namedArgs: {'date': DateHelper.dayMonth(due)}) +
                (diff <= 14
                    ? LocaleKeys.projects_dueSoon.tr(namedArgs: {'n': '$diff'})
                    : '');
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: AppColors.dividerColor.themeColor)),
      ),
      child: Row(
        children: [
          EmojiBox(
            emoji: payment.paid
                ? AppEmojis.check
                : overdue
                    ? AppEmojis.exclamation
                    : AppEmojis.hourglass,
            size: 40,
            radius: 13,
            fontSize: 16,
            color: payment.paid
                ? AppColors.successColor.themeColor
                : AppColors.errorColor.themeColor,
            background: payment.paid
                ? AppColors.successSoftColor.themeColor
                : overdue
                    ? AppColors.errorSoftColor.themeColor
                    : AppColors.warningSoftColor.themeColor,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(payment.label, fontWeight: FontWeight.w700),
                AppText(subtitle,
                    fontSize: 12,
                    color: overdue ? AppColors.errorColor.themeColor : muted),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(NumberHelper.money(payment.amount, project.currency),
                  numeric: true, fontWeight: FontWeight.w700),
              if (!payment.paid) ...[
                SizedBox(height: 4.h),
                CustomButton(
                  width: 96.w,
                  height: 32,
                  radius: 10,
                  fontSize: 12,
                  withShadow: false,
                  type: overdue
                      ? ButtonStyleType.softDanger
                      : ButtonStyleType.ghost,
                  title: LocaleKeys.projects_recordPayment.tr(),
                  onTap: () => context
                      .read<ProjectsCubit>()
                      .markPaid(project.id, payment.id),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
