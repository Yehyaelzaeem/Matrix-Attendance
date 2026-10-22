import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../data/models/task_model.dart';

class TaskDueLabel {
  TaskDueLabel._();

  static String text(TaskModel task) {
    if (task.isDone) {
      return '${AppEmojis.check} ${DateHelper.dayMonthOrNotYet(task.doneAt ?? task.due)}';
    }
    final due = task.due;
    if (due == null) return LocaleKeys.common_notYet.tr();
    final diff = DateHelper.dayDiff(due);
    if (task.isLate) {
      return LocaleKeys.tasks_lateDays.tr(namedArgs: {'n': '${diff.abs()}'});
    }
    if (diff == 0) return LocaleKeys.common_today.tr();
    if (diff == 1) return LocaleKeys.common_tomorrow.tr();
    return DateHelper.dayMonth(due);
  }

  static ChipTone tone(TaskModel task) {
    if (task.isDone) return ChipTone.gray;
    if (task.isLate) return ChipTone.red;
    final due = task.due;
    if (due == null) return ChipTone.gray;
    return DateHelper.dayDiff(due) <= 1 ? ChipTone.orange : ChipTone.gray;
  }

  static String hours(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}
