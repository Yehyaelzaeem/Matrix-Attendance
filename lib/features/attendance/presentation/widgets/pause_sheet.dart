import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/emoji_option_grid.dart';
import '../../../../core/widgets/field_label.dart';
import '../../../../core/widgets/info_box.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../data/models/attendance_day.dart';
import '../../data/models/attendance_enums.dart';
import '../../logic/attendance_cubit.dart';
import 'pause_result_view.dart';

class PauseSheet extends StatefulWidget {
  const PauseSheet({super.key});

  @override
  State<PauseSheet> createState() => _PauseSheetState();
}

class _PauseSheetState extends State<PauseSheet> {
  final _note = TextEditingController();
  PauseReason? _reason;
  bool _loading = false;
  AttendanceDay? _result;

  bool get _valid =>
      _reason != null &&
      (!_reason!.requiresNote || _note.text.trim().length >= 4);

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    final day = await context
        .read<AttendanceCubit>()
        .pause(_reason!, _note.text.trim());
    if (!mounted) return;
    setState(() {
      _loading = false;
      _result = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_result?.activePause != null) {
      return PauseResultView(pause: _result!.activePause!);
    }
    final required = _reason?.requiresNote ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(LocaleKeys.attendance_pauseTitle.tr(),
            fontSize: 18, fontWeight: FontWeight.w800),
        SizedBox(height: 14.h),
        EmojiOptionGrid<PauseReason>(
          options: [
            for (final r in PauseReason.values)
              EmojiOption(r, r.emoji, r.label),
          ],
          selected: _reason,
          onSelect: (r) => setState(() => _reason = r),
        ),
        SizedBox(height: 16.h),
        LabeledField(
          label: LocaleKeys.attendance_pauseDetails.tr(),
          badge: StatusChip(
            small: true,
            label: required
                ? LocaleKeys.common_required.tr()
                : LocaleKeys.common_optional.tr(),
            tone: required ? ChipTone.red : ChipTone.gray,
          ),
          child: CustomTextField(
            controller: _note,
            hint: LocaleKeys.attendance_pauseHint.tr(),
            maxLines: 3,
            minLines: 2,
            onChanged: (_) => setState(() {}),
          ),
        ),
        InfoBox(
          emoji: AppEmojis.info,
          text: LocaleKeys.attendance_pauseInfo.tr(),
          margin: EdgeInsets.only(bottom: 14.h),
        ),
        CustomButton(
          title: LocaleKeys.attendance_pauseButton.tr(),
          gradient: AppColors.warningGradient,
          enabled: _valid,
          loading: _loading,
          onTap: _submit,
        ),
      ],
    );
  }
}
