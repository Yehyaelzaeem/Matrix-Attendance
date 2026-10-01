import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/stat_tiles.dart';
import '../../data/models/attendance_day.dart';

class AttendanceMetaRow extends StatelessWidget {
  const AttendanceMetaRow({
    super.key,
    required this.day,
    required this.now,
    required this.lastCheckIn,
  });

  final AttendanceDay day;
  final DateTime now;
  final String lastCheckIn;

  @override
  Widget build(BuildContext context) {
    final expected = day.expectedCheckout(now);
    return StatTilesRow(
      background: AppColors.surfaceColor.themeColor,
      radius: 14,
      verticalPadding: 10,
      valueSize: 15,
      labelFirst: true,
      tiles: [
        StatTileData(
          value: day.checkIn == null
              ? '--:--'
              : DateHelper.timeShort(day.checkIn!),
          label: LocaleKeys.attendance_metaIn.tr(),
        ),
        StatTileData(
          value: expected == null ? '--:--' : DateHelper.timeShort(expected),
          label: LocaleKeys.attendance_metaOut.tr(),
        ),
        StatTileData(
            value: lastCheckIn, label: LocaleKeys.attendance_metaLast.tr()),
      ],
    );
  }
}
