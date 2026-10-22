import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../auth/logic/auth_cubit.dart';
import '../../data/models/attendance_day.dart';
import '../../logic/attendance_cubit.dart';
import 'check_in_result_view.dart';
import 'check_steps_list.dart';
import 'locating_radar.dart';
import 'whatsapp_messages.dart';

class CheckInSheet extends StatefulWidget {
  const CheckInSheet({super.key, required this.onSubmitRequest});

  final VoidCallback onSubmitRequest;

  @override
  State<CheckInSheet> createState() => _CheckInSheetState();
}

class _CheckInSheetState extends State<CheckInSheet> {
  late final AttendanceCubit _cubit = context.read<AttendanceCubit>();
  int _done = 0;
  AttendanceDay? _result;

  static const _stepDelay = Duration(milliseconds: 450);

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _tick(int done) async {
    if (!mounted) return;
    setState(() => _done = done);
    await Future.delayed(_stepDelay);
  }

  Future<void> _run() async {
    final navigator = Navigator.of(context);
    await Future.delayed(_stepDelay);
    final fix = await _cubit.locate();
    if (fix == null) {
      if (mounted) navigator.pop();
      return;
    }
    await _tick(1);
    await _tick(2);
    final day = await _cubit.checkIn(fix);
    if (!mounted) return;
    if (day == null) {
      navigator.pop();
      return;
    }
    await _tick(3);
    await _tick(4);
    if (!mounted) return;
    setState(() => _result = day);
    await _postToGroup(day);
  }

  Future<void> _postToGroup(AttendanceDay day) async {
    final name = context.read<AuthCubit>().currentUser?.name ?? '';
    await Future.delayed(const Duration(milliseconds: 900));
    await _cubit.postToGroup(WhatsappMessages.checkIn(name, day));
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
