import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/section_title.dart';
import '../../../layout/logic/app_tab.dart';
import '../../../layout/logic/layout_cubit.dart';
import '../../../tasks/data/models/task_model.dart';
import '../../../tasks/logic/tasks_cubit.dart';
import '../../../tasks/presentation/widgets/task_card.dart';

class HomeTasksSection extends StatelessWidget {
  const HomeTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<TasksCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          title: LocaleKeys.attendance_myTasks.tr(),
          actionLabel: LocaleKeys.nav_myWork.tr(),
          onAction: () => getIt<LayoutCubit>().select(AppTab.myWork),
        ),
        BlocBuilder<TasksCubit, TasksState>(
          bloc: cubit,
          builder: (_, state) {
            final mine = cubit.tasks
                .where((t) => t.assignee == cubit.me && !t.isDone)
                .toList()
              ..sort(_compare);
            final top = mine.take(2).toList();
            if (top.isEmpty) {
              return AppEmpty(
                  message: LocaleKeys.attendance_noOpenTasks.tr(), padding: 10);
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  for (var i = 0; i < top.length; i++)
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: TaskCard(task: top[i], index: i),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  static int _compare(TaskModel a, TaskModel b) {
    if (a.returned != b.returned) return a.returned ? -1 : 1;
    return a.due.compareTo(b.due);
  }
}
