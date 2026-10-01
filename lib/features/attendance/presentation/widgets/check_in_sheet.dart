import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/models/day_type.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/segmented_toggle.dart';
import '../../data/models/attendance_day.dart';
import '../../logic/attendance_cubit.dart';
import 'check_in_result_view.dart';
import 'check_steps_list.dart';
import 'locating_radar.dart';

class CheckInSheet extends StatefulWidget {
  const CheckInSheet(
      {super.key, required this.expected, required this.onSubmitRequest});

  final DayType expected;
  final VoidCallback onSubmitRequest;

  @override
  State<CheckInSheet> createState() => _CheckInSheetState();
}

class _CheckInSheetState extends State<CheckInSheet> {
  late DayType _pick =
      widget.expected == DayType.home ? DayType.home : DayType.office;
  int _done = 0;
  AttendanceDay? _result;

  static const _stepCount = 4;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    await Future.delayed(const Duration(milliseconds: 700));
    for (var i = 0; i < _stepCount; i++) {
      if (!mounted) return;
      setState(() => _done = i + 1);
      await Future.delayed(const Duration(milliseconds: 650));
    }
    final day = await getIt<AttendanceCubit>().checkIn(_pick);
    if (mounted && day != null) setState(() => _result = day);
  }

  @override
  Widget build(BuildContext context) {
    if (_result != null) {
      return CheckInResultView(
          day: _result!, onSubmitRequest: widget.onSubmitRequest);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(LocaleKeys.attendance_simLabel.tr(),
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondaryColor.themeColor),
        SizedBox(height: 6.h),
        SegmentedToggle<DayType>(
          options: [
            (DayType.office, LocaleKeys.attendance_simInside.tr()),
            (DayType.home, LocaleKeys.attendance_simOutside.tr()),
          ],
          selected: _pick,
          onChanged: (v) => setState(() => _pick = v),
        ),
        SizedBox(height: 14.h),
        const Center(child: LocatingRadar()),
        SizedBox(height: 16.h),
        AppText(LocaleKeys.attendance_locating.tr(),
            fontSize: 18,
            fontWeight: FontWeight.w800,
            textAlign: TextAlign.center),
        CheckStepsList(
          done: _done,
          steps: [
            LocaleKeys.attendance_checkLocation.tr(),
            LocaleKeys.attendance_checkMock.tr(),
            LocaleKeys.attendance_checkDevice.tr(),
            LocaleKeys.attendance_checkSchedule.tr(),
          ],
        ),
      ],
    );
  }
}
