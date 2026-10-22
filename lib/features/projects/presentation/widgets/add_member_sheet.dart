import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/option_tile.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../team/logic/team_cubit.dart';
import '../../logic/projects_cubit.dart';

class AddMemberSheet extends StatelessWidget {
  const AddMemberSheet({super.key, required this.projectId});

  final int projectId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ProjectsCubit>();
    final project = cubit.byId(projectId);
    if (project == null) return const SizedBox.shrink();
    final out = context
        .read<TeamCubit>()
        .employees
        .where((e) => !project.hasMember(e.id))
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(LocaleKeys.projects_addToProject.tr(),
            fontSize: 18, fontWeight: FontWeight.w800),
        SizedBox(height: 10.h),
        if (out.isEmpty)
          AppEmpty(message: LocaleKeys.projects_allInProject.tr())
        else
          for (final e in out)
            OptionTile(
              title: e.name,
              subtitle: e.jobTitle,
              leadingWidget: AppAvatar(
                  name: e.name, imagePath: e.image, size: 38, radius: 12),
              trailing: StatusChip(
                  label: LocaleKeys.projects_addBadge.tr(),
                  tone: ChipTone.blue),
              onTap: () => cubit.addMember(projectId,
                  userId: e.id, name: e.name, role: e.jobTitle),
            ),
        SizedBox(height: 12.h),
        CustomButton(
          title: LocaleKeys.common_ok.tr(),
          type: ButtonStyleType.ghost,
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
