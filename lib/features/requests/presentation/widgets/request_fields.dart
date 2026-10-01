import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/models/day_type.dart';
import '../../../../core/utils/app_pickers.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/field_label.dart';
import '../../../../core/widgets/schedule_editor.dart';
import '../../../../core/widgets/segmented_toggle.dart';
import '../../../../core/widgets/select_field.dart';
import '../../data/models/request_model.dart';

class RequestFormValues {
  const RequestFormValues({
    required this.from,
    required this.to,
    required this.schedule,
    this.swapToHome = true,
    this.arrive = const TimeOfDay(hour: 11, minute: 30),
    this.leave = const TimeOfDay(hour: 15, minute: 0),
    this.actualIn = const TimeOfDay(hour: 9, minute: 0),
    this.actualOut = const TimeOfDay(hour: 17, minute: 10),
  });

  final DateTime from;
  final DateTime to;
  final WeeklySchedule schedule;
  final bool swapToHome;
  final TimeOfDay arrive;
  final TimeOfDay leave;
  final TimeOfDay actualIn;
  final TimeOfDay actualOut;

  RequestFormValues copyWith({
    DateTime? from,
    DateTime? to,
    WeeklySchedule? schedule,
    bool? swapToHome,
    TimeOfDay? arrive,
    TimeOfDay? leave,
    TimeOfDay? actualIn,
    TimeOfDay? actualOut,
  }) =>
      RequestFormValues(
        from: from ?? this.from,
        to: to ?? this.to,
        schedule: schedule ?? this.schedule,
        swapToHome: swapToHome ?? this.swapToHome,
        arrive: arrive ?? this.arrive,
        leave: leave ?? this.leave,
        actualIn: actualIn ?? this.actualIn,
        actualOut: actualOut ?? this.actualOut,
      );
}

class RequestFields extends StatelessWidget {
  const RequestFields({
    super.key,
    required this.type,
    required this.values,
    required this.onChanged,
  });

  final RequestType type;
  final RequestFormValues values;
  final ValueChanged<RequestFormValues> onChanged;

  Widget _date(BuildContext context, String label, DateTime value,
          RequestFormValues Function(DateTime d) apply) =>
      LabeledField(
        label: label,
        child: SelectField(
          placeholder: '',
          value: DateHelper.dayMonth(value),
          icon: Icons.event_outlined,
          onTap: () async {
            final picked = await AppPickers.pickDate(context, initial: value);
            if (picked != null) onChanged(apply(picked));
          },
        ),
      );

  Widget _time(BuildContext context, String label, TimeOfDay value,
          RequestFormValues Function(TimeOfDay t) apply) =>
      LabeledField(
        label: label,
        child: SelectField(
          placeholder: '',
          value: DateHelper.time12(DateTime(0, 1, 1, value.hour, value.minute)),
          icon: Icons.schedule_rounded,
          onTap: () async {
            final picked = await AppPickers.pickTime(context, initial: value);
            if (picked != null) onChanged(apply(picked));
          },
        ),
      );

  Widget _row(List<Widget> children) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: children[0]),
          SizedBox(width: 10.w),
          Expanded(child: children[1]),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final day = LocaleKeys.requests_day.tr();
    final fromField =
        _date(context, day, values.from, (d) => values.copyWith(from: d));
    return switch (type) {
      RequestType.leave => _row([
          _date(context, LocaleKeys.requests_from.tr(), values.from,
              (d) => values.copyWith(from: d)),
          _date(context, LocaleKeys.requests_to.tr(), values.to,
              (d) => values.copyWith(to: d)),
        ]),
      RequestType.absence => fromField,
      RequestType.swap => Column(
          children: [
            fromField,
            LabeledField(
              label: LocaleKeys.requests_swap.tr(),
              child: SegmentedToggle<bool>(
                options: [
                  (true, LocaleKeys.requests_swapToHome.tr()),
                  (false, LocaleKeys.requests_swapToOffice.tr()),
                ],
                selected: values.swapToHome,
                onChanged: (v) => onChanged(values.copyWith(swapToHome: v)),
              ),
            ),
          ],
        ),
      RequestType.late => _row([
          fromField,
          _time(context, LocaleKeys.requests_arriveAt.tr(), values.arrive,
              (t) => values.copyWith(arrive: t)),
        ]),
      RequestType.early => _row([
          fromField,
          _time(context, LocaleKeys.requests_leaveAt.tr(), values.leave,
              (t) => values.copyWith(leave: t)),
        ]),
      RequestType.fix => Column(
          children: [
            fromField,
            _row([
              _time(context, LocaleKeys.requests_actualIn.tr(), values.actualIn,
                  (t) => values.copyWith(actualIn: t)),
              _time(context, LocaleKeys.requests_actualOut.tr(),
                  values.actualOut, (t) => values.copyWith(actualOut: t)),
            ]),
          ],
        ),
      RequestType.schedule => LabeledField(
          label: LocaleKeys.requests_newSchedule.tr(),
          hint: LocaleKeys.requests_tapDay.tr(),
          child: ScheduleEditor(
            schedule: values.schedule,
            onChanged: (s) => onChanged(values.copyWith(schedule: s)),
          ),
        ),
    };
  }
}
