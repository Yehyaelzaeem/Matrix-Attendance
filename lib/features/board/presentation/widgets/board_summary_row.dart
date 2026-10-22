import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/stat_tiles.dart';
import '../../data/models/board_entry.dart';

class BoardSummaryRow extends StatelessWidget {
  const BoardSummaryRow({super.key, required this.summary});

  final BoardSummary summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: StatTilesRow(
        valueSize: 20,
        verticalPadding: 10,
        tiles: [
          StatTileData(
            value: '${summary.office}',
            label: LocaleKeys.board_office.tr(),
            color: AppColors.primaryColor.themeColor,
          ),
          StatTileData(
            value: '${summary.home}',
            label: LocaleKeys.board_home.tr(),
            color: AppColors.violetColor.themeColor,
          ),
          StatTileData(
            value: '${summary.late}',
            label: LocaleKeys.board_late.tr(),
            color: AppColors.warningDeepColor.themeColor,
          ),
          StatTileData(
            value: '${summary.absent}',
            label: LocaleKeys.board_notArrived.tr(),
            color: AppColors.errorColor.themeColor,
          ),
        ],
      ),
    );
  }
}
