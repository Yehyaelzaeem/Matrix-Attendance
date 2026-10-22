import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/info_block.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../tasks/logic/tasks_cubit.dart';
import '../../data/models/project_model.dart';
import '../../logic/projects_cubit.dart';
import 'add_member_sheet.dart';
import 'square_icon_action.dart';

class ProjectTeamTab extends StatelessWidget {
  const ProjectTeamTab(
      {super.key, required this.project, required this.isAdmin});

  final ProjectModel project;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TasksCubit>().tasks;
    final cubit = context.read<ProjectsCubit>();
    int openOf(int userId) => tasks
        .where((t) =>
            t.projectId == project.id && t.assigneeId == userId && !t.isDone)
        .length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoBlock(
          title: LocaleKeys.projects_teamTitle.tr(),
          trailing: StatusChip(
              small: true, label: '${project.team.length}', numeric: true),
          child: Column(
            children: [
              for (var i = 0; i < project.team.length; i++)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 11.h),
                  decoration: BoxDecoration(
                    border: i == project.team.length - 1
                        ? null
                        : Border(
                            bottom: BorderSide(
                                color: AppColors.dividerColor.themeColor)),
                  ),
                  child: Row(
                    children: [
                      AppAvatar(
                          name: project.team[i].name,
                          imagePath: project.team[i].image),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 6.w,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                AppText(project.team[i].name,
                                    fontWeight: FontWeight.w700),
                                if (project.managerId == project.team[i].userId)
                                  StatusChip(
                                    small: true,
                                    label:
                                        LocaleKeys.projects_managerBadge.tr(),
                                    tone: ChipTone.orange,
                                  ),
                              ],
                            ),
                            AppText(
                              LocaleKeys.projects_memberOpen.tr(namedArgs: {
                                'role': project.team[i].role,
                                'n': '${openOf(project.team[i].userId)}',
                              }),
                              fontSize: 11.5,
                              color: AppColors.textSecondaryColor.themeColor,
                            ),
                          ],
                        ),
                      ),
                      if (isAdmin &&
                          project.managerId != project.team[i].userId) ...[
                        SquareIconAction(
                          emoji: AppEmojis.star,
                          tooltip: LocaleKeys.projects_makeManager.tr(),
                          onTap: () =>
                              cubit.setManager(project.id, project.team[i]),
                        ),
                        SizedBox(width: 6.w),
                        SquareIconAction(
                          emoji: AppEmojis.close,
                          danger: true,
                          tooltip: LocaleKeys.projects_removeMember.tr(),
                          onTap: () => cubit.removeMember(
                            project.id,
                            project.team[i],
                            openTasks: openOf(project.team[i].userId),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (isAdmin)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: CustomButton(
              title: LocaleKeys.projects_addMembers.tr(),
              onTap: () => AppSheet.show(context,
                  child: AddMemberSheet(projectId: project.id)),
            ),
          ),
      ],
    );
  }
}
