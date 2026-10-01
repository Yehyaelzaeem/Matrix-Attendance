import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/models/day_type.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/emoji_option_grid.dart';
import '../../../../core/widgets/field_label.dart';
import '../../../attendance/logic/attendance_cubit.dart';
import '../../data/models/request_model.dart';
import '../../logic/requests_cubit.dart';
import 'request_fields.dart';

class NewRequestSheet extends StatefulWidget {
  const NewRequestSheet({super.key, this.initialType});

  final RequestType? initialType;

  @override
  State<NewRequestSheet> createState() => _NewRequestSheetState();
}

class _NewRequestSheetState extends State<NewRequestSheet> {
  final _reason = TextEditingController();
  late RequestType? _type = widget.initialType;
  late RequestFormValues _values = RequestFormValues(
    from: DateHelper.today(),
    to: DateHelper.today(),
    schedule: getIt<AttendanceCubit>().overview?.schedule ?? kDefaultSchedule,
  );
  bool _loading = false;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  String _subtitle(RequestType type) {
    final v = _values;
    String time(TimeOfDay t) =>
        DateHelper.time24(DateTime(0, 1, 1, t.hour, t.minute));
    return switch (type) {
      RequestType.leave => LocaleKeys.requests_subUntil
          .tr(namedArgs: {'date': DateHelper.dayMonth(v.to)}),
      RequestType.absence => LocaleKeys.common_dash.tr(),
      RequestType.swap => v.swapToHome
          ? LocaleKeys.requests_subSwapHome.tr()
          : LocaleKeys.requests_subSwapOffice.tr(),
      RequestType.late =>
        LocaleKeys.requests_subTime.tr(namedArgs: {'time': time(v.arrive)}),
      RequestType.early =>
        LocaleKeys.requests_subTime.tr(namedArgs: {'time': time(v.leave)}),
      RequestType.fix => LocaleKeys.requests_subFix
          .tr(namedArgs: {'in': time(v.actualIn), 'out': time(v.actualOut)}),
      RequestType.schedule => LocaleKeys.requests_subSchedule.tr(),
    };
  }

  Future<void> _send() async {
    final type = _type!;
    setState(() => _loading = true);
    final ok = await getIt<RequestsCubit>().submit(
      type: type,
      title: LocaleKeys.requests_titleFormat.tr(namedArgs: {
        'type': type.label,
        'day': DateHelper.dayName(DateHelper.weekIndex(_values.from)),
        'date': DateHelper.dayMonth(_values.from),
      }),
      subtitle: _subtitle(type),
      reason: _reason.text.trim(),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(LocaleKeys.requests_new.tr(),
            fontSize: 18, fontWeight: FontWeight.w800),
        SizedBox(height: 14.h),
        EmojiOptionGrid<RequestType>(
          options: [
            for (final t in RequestType.values) EmojiOption(t, t.emoji, t.label)
          ],
          selected: _type,
          onSelect: (t) => setState(() => _type = t),
        ),
        SizedBox(height: 16.h),
        if (_type == null)
          Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: AppText(LocaleKeys.requests_chooseType.tr(),
                fontSize: 13, color: AppColors.textSecondaryColor.themeColor),
          )
        else
          RequestFields(
            type: _type!,
            values: _values,
            onChanged: (v) => setState(() => _values = v),
          ),
        LabeledField(
          label: LocaleKeys.common_reason.tr(),
          child: CustomTextField(
            controller: _reason,
            hint: LocaleKeys.requests_reasonHint.tr(),
            minLines: 3,
            maxLines: 5,
            onChanged: (_) => setState(() {}),
          ),
        ),
        CustomButton(
          title: LocaleKeys.requests_send.tr(),
          enabled: _type != null && _reason.text.trim().length >= 5,
          loading: _loading,
          onTap: _send,
        ),
      ],
    );
  }
}
