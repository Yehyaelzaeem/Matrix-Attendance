import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/models/day_type.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/header_overlap_layout.dart';
import '../../../core/widgets/schedule_editor.dart';
import '../../../core/widgets/section_title.dart';
import '../../../core/widgets/status_chip.dart';
import '../../attendance/logic/attendance_cubit.dart';
import '../../auth/logic/auth_cubit.dart';
import 'widgets/monthly_report_card.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().currentUser;
    final muted = AppColors.textSecondaryColor.themeColor;
    return ColoredBox(
      color: AppColors.backgroundColor.themeColor,
      child: BlocBuilder<AttendanceCubit, AttendanceState>(
        bloc: getIt<AttendanceCubit>(),
        builder: (context, state) {
          final overview = getIt<AttendanceCubit>().overview;
          return SingleChildScrollView(
            child: HeaderOverlapLayout(
              overlap: 44,
              header: ProfileHeader(user: user),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (user != null) ProfileInfoCard(user: user),
                  SectionTitle(
                    title: LocaleKeys.profile_weeklySchedule.tr(),
                    trailing:
                        StatusChip(label: LocaleKeys.profile_setByAdmin.tr()),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: ScheduleEditor(
                      schedule: overview?.schedule ?? kDefaultSchedule,
                      dimOff: true,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(18.w, 10.h, 18.w, 0),
                    child: Wrap(
                      spacing: 14.w,
                      children: [
                        AppText(LocaleKeys.profile_legendOffice.tr(),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: muted),
                        AppText(LocaleKeys.profile_legendHome.tr(),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: muted),
                        AppText(LocaleKeys.profile_legendOff.tr(),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: muted),
                      ],
                    ),
                  ),
                  SectionTitle(
                    title: LocaleKeys.profile_monthReport.tr(namedArgs: {
                      'month': DateHelper.monthName(DateTime.now().month),
                    }),
                  ),
                  if (overview != null)
                    MonthlyReportCard(month: overview.month),
                  AppCard(
                    margin:
                        EdgeInsetsDirectional.fromSTEB(18.w, 14.h, 18.w, 26.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
                    child: const ProfileMenu(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
