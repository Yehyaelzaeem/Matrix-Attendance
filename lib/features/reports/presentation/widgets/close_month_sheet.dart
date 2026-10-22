import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/info_box.dart';
import '../../../../core/widgets/custom_loading_widget.dart';
import '../../data/reports_repo.dart';
import '../../logic/reports_cubit.dart';

class CloseMonthSheet extends StatefulWidget {
  const CloseMonthSheet({super.key});

  @override
  State<CloseMonthSheet> createState() => _CloseMonthSheetState();
}

class _CloseMonthSheetState extends State<CloseMonthSheet> {
  late final ReportsCubit _cubit = context.read<ReportsCubit>();
  CloseCheck? _check;
  bool _loading = true;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _cubit.closeCheck().then((check) {
      if (mounted) {
        setState(() {
          _check = check;
          _loading = false;
        });
      }
    });
  }

  Future<void> _close() async {
    setState(() => _closing = true);
    final navigator = Navigator.of(context);
    final ok = await _cubit.closeMonth();
    if (ok) {
      navigator.pop();
    } else if (mounted) {
      setState(() => _closing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final check = _check;
    final month = _cubit.viewingPrevious
        ? DateTime(DateTime.now().year, DateTime.now().month - 1).month
        : DateTime.now().month;
    final items = check == null
        ? const <(String, bool)>[]
        : [
            (
              LocaleKeys.reports_closeAllReviewed
                  .tr(namedArgs: {'a': '${check.done}', 'b': '${check.total}'}),
              check.allReviewed
            ),
            (LocaleKeys.reports_closeNoFixes.tr(), check.noPendingFixes),
            (LocaleKeys.reports_closeOpenDays.tr(), check.noOpenDays),
          ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          LocaleKeys.reports_closeTitle
              .tr(namedArgs: {'month': DateHelper.monthName(month)}),
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        SizedBox(height: 8.h),
        if (_loading)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: const Center(child: CustomLoadingWidget()),
          ),
        for (var i = 0; i < items.length; i++)
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              border: i == items.length - 1
                  ? null
                  : Border(
                      bottom:
                          BorderSide(color: AppColors.dividerColor.themeColor)),
            ),
            child: Row(
              children: [
                Container(
                  width: 24.r,
                  height: 24.r,
                  decoration: BoxDecoration(
                    color: items[i].$2
                        ? AppColors.successColor.themeColor
                        : AppColors.idleStepColor.themeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                      items[i].$2 ? Icons.check_rounded : Icons.more_horiz,
                      size: 14.sp,
                      color: Colors.white),
                ),
                SizedBox(width: 10.w),
                Expanded(
                    child: AppText(items[i].$1, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        InfoBox(
          text: check != null && !check.canClose
              ? LocaleKeys.reports_closeBlocked.tr()
              : LocaleKeys.reports_closeWarning.tr(),
          tone: InfoTone.warning,
          margin: EdgeInsets.symmetric(vertical: 14.h),
        ),
        CustomButton(
          title: LocaleKeys.reports_closeConfirm.tr(),
          enabled: check?.canClose ?? false,
          loading: _closing,
          onTap: _close,
        ),
        SizedBox(height: 6.h),
        CustomButton(
          title: LocaleKeys.common_cancel.tr(),
          type: ButtonStyleType.plain,
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
