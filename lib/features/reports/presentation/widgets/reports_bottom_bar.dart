import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';

class ReportsBottomBar extends StatelessWidget {
  const ReportsBottomBar({
    super.key,
    required this.reviewed,
    required this.total,
    required this.onMarkAll,
    required this.onClose,
  });

  final int reviewed;
  final int total;
  final VoidCallback onMarkAll;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 10.h, 20.w, 14.h),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: CustomButton(
              title: LocaleKeys.reports_markAll.tr(),
              type: ButtonStyleType.ghost,
              onTap: onMarkAll,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            flex: 16,
            child: CustomButton(
              title: LocaleKeys.reports_closeMonth
                  .tr(namedArgs: {'a': '$reviewed', 'b': '$total'}),
              enabled: reviewed >= total,
              onTap: onClose,
            ),
          ),
        ],
      ),
    );
  }
}
