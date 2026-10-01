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
      return '${AppEmojis.check} ${DateHelper.dayMonth(task.doneAt ?? task.due)}';
    }
    final diff = DateHelper.dayDiff(task.due);
    if (task.isLate) {
      return LocaleKeys.tasks_lateDays.tr(namedArgs: {'n': '${diff.abs()}'});
    }
    if (diff == 0) return LocaleKeys.common_today.tr();
    if (diff == 1) return LocaleKeys.common_tomorrow.tr();
    return DateHelper.dayMonth(task.due);
  }

  static ChipTone tone(TaskModel task) {
    if (task.isDone) return ChipTone.gray;
    if (task.isLate) return ChipTone.red;
    return DateHelper.dayDiff(task.due) <= 1 ? ChipTone.orange : ChipTone.gray;
  }

  static String hours(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}
