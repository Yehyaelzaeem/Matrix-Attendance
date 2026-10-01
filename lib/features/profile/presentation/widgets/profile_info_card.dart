import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/key_value_row.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../projects/logic/projects_cubit.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final projects = getIt<ProjectsCubit>()
        .projects
        .where((p) => p.hasMember(user.name))
        .map((p) => p.name)
        .join(' · ');
    return AppCard(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.h),
      child: Column(
        children: [
          KeyValueRow(
            label: LocaleKeys.profile_phone.tr(),
            value: Validators.internationalPhone(user.phone),
            numeric: true,
          ),
          KeyValueRow(
            label: LocaleKeys.profile_role.tr(),
            valueWidget:
                StatusChip(label: user.role.label, tone: user.role.tone),
            showDivider: projects.isNotEmpty,
          ),
          if (projects.isNotEmpty)
            KeyValueRow(
              label: LocaleKeys.profile_projects.tr(),
              value: projects,
              showDivider: false,
            ),
        ],
      ),
    );
  }
}
