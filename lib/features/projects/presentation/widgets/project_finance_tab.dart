import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/utils/number_helper.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/info_block.dart';
import '../../../../core/widgets/meter_bar.dart';
import '../../../../core/widgets/stat_tiles.dart';
import '../../data/models/project_model.dart';
import 'add_payment_sheet.dart';
import 'payment_row.dart';

class ProjectFinanceTab extends StatelessWidget {
  const ProjectFinanceTab({super.key, required this.project});

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    final paid = project.paidAmount;
    final remaining = project.value - paid;
    final pct = project.value == 0 ? 0 : (paid / project.value * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoBlock(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StatTilesRow(
                background: AppColors.surfaceColor.themeColor,
                valueSize: 15,
                radius: 14,
                verticalPadding: 11,
                tiles: [
                  StatTileData(
                      value: NumberHelper.money(project.value),
                      label: LocaleKeys.projects_projectValue.tr()),
                  StatTileData(
                      value: NumberHelper.money(paid),
                      label: LocaleKeys.projects_paid.tr(),
                      color: AppColors.successColor.themeColor),
                  StatTileData(
                    value: NumberHelper.money(remaining),
                    label: LocaleKeys.projects_remaining.tr(),
                    color: remaining > 0
                        ? AppColors.warningDeepColor.themeColor
                        : AppColors.successColor.themeColor,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: AppText(LocaleKeys.projects_collectionRate.tr(),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondaryColor.themeColor),
                  ),
                  AppText(
                    LocaleKeys.projects_inCurrency
                        .tr(namedArgs: {'n': '$pct', 'cur': project.currency}),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              MeterBar(
                  value: pct / 100, color: AppColors.successColor.themeColor),
            ],
          ),
        ),
        InfoBlock(
          title: LocaleKeys.projects_payments.tr(),
          trailing: GestureDetector(
            onTap: () => AppSheet.show(context,
                child: AddPaymentSheet(project: project)),
            child: AppText(LocaleKeys.projects_addPayment.tr(),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor.themeColor),
          ),
          child: Column(
            children: [
              for (var i = 0; i < project.payments.length; i++)
                PaymentRow(
                  project: project,
                  index: i,
                  isLast: i == project.payments.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
