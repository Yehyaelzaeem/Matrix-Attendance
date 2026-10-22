import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_emojis.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/menu_item_tile.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../../../core/widgets/section_title.dart';
import '../../profile/presentation/widgets/language_sheet.dart';
import '../../profile/presentation/widgets/logout_action.dart';
import '../../projects/data/models/project_model.dart';
import '../../projects/logic/projects_cubit.dart';
import '../../tasks/logic/tasks_cubit.dart';
import '../../team/data/models/holiday_model.dart';
import '../../team/logic/team_cubit.dart';
import 'widgets/admin_me_card.dart';
import 'widgets/more_tile.dart';
import 'widgets/more_tiles_grid.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectsCubit>();
    final tasks = context.watch<TasksCubit>();
    final team = context.watch<TeamCubit>();
    final teamState = team.state;
    return ColoredBox(
      color: AppColors.backgroundColor.themeColor,
      child: Builder(
        builder: (context) {
          final active = projects.projects
              .where((p) => p.status == ProjectStatus.active)
              .length;
          final open = tasks.tasks.where((t) => !t.isDone).length;
          final late = tasks.tasks.where((t) => t.isLate).length;
          final holidays = teamState is TeamSuccess
              ? teamState.holidays.items
              : const <HolidayModel>[];
          final today = DateHelper.today();
          final next =
              holidays.where((h) => !h.date.isBefore(today)).firstOrNull;
          return ListView(
            padding: EdgeInsets.only(bottom: 26.h),
            children: [
              PageTopBar(title: LocaleKeys.admin_more.tr()),
              const AdminMeCard(),
              SectionTitle(title: LocaleKeys.admin_workSection.tr()),
              MoreTilesGrid(tiles: [
                MoreTile(
                  emoji: AppEmojis.folder,
                  background: AppColors.primarySoftColor.themeColor,
                  title: LocaleKeys.projects_title.tr(),
                  subtitle: LocaleKeys.admin_projectsTileSub.tr(namedArgs: {
                    'a': '$active',
                    'b': '${projects.projects.length}',
                  }),
                  big: true,
                  onTap: () => context.pushNamed(Routes.projectsScreen),
                ),
                MoreTile(
                  emoji: AppEmojis.checkBox,
                  background: AppColors.successSoftColor.themeColor,
                  title: LocaleKeys.tasks_title.tr(),
                  subtitle: LocaleKeys.admin_tasksTileSub
                          .tr(namedArgs: {'n': '$open'}) +
                      (late > 0
                          ? LocaleKeys.admin_tasksTileLate
                              .tr(namedArgs: {'n': '$late'})
                          : ''),
                  big: true,
                  onTap: () => context.pushNamed(Routes.tasksScreen),
                ),
              ]),
              SectionTitle(title: LocaleKeys.admin_teamSection.tr()),
              MoreTilesGrid(tiles: [
                MoreTile(
                  emoji: AppEmojis.users,
                  background: AppColors.violetSoftColor.themeColor,
                  title: LocaleKeys.admin_employees.tr(),
                  subtitle: LocaleKeys.admin_employeesSub
                      .tr(namedArgs: {'n': '${team.employees.length}'}),
                  onTap: () => context.pushNamed(Routes.employeesScreen),
                ),
                MoreTile(
                  emoji: AppEmojis.calendarSpiral,
                  background: AppColors.warningSoftColor.themeColor,
                  title: LocaleKeys.admin_schedules.tr(),
                  subtitle: LocaleKeys.admin_schedulesSub.tr(),
                  onTap: () => context.pushNamed(Routes.schedulesScreen),
                ),
                MoreTile(
                  emoji: AppEmojis.holiday,
                  background: AppColors.errorSoftColor.themeColor,
                  title: LocaleKeys.admin_holidays.tr(),
                  subtitle: next != null
                      ? LocaleKeys.admin_holidaysNext.tr(
                          namedArgs: {'date': DateHelper.dayMonth(next.date)})
                      : LocaleKeys.admin_holidaysCount
                          .tr(namedArgs: {'n': '${holidays.length}'}),
                  onTap: () => context.pushNamed(Routes.holidaysScreen),
                ),
                MoreTile(
                  emoji: AppEmojis.chart,
                  background: AppColors.successSoftColor.themeColor,
                  title: LocaleKeys.admin_reports.tr(),
                  subtitle: LocaleKeys.admin_reportsSub.tr(),
                  onTap: () => context.pushNamed(Routes.reportsScreen),
                ),
              ]),
              SectionTitle(title: LocaleKeys.admin_settings.tr()),
              AppCard(
                margin: EdgeInsets.symmetric(horizontal: 18.w),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
                child: Column(
                  children: [
                    MenuItemTile(
                      emoji: AppEmojis.location,
                      background: AppColors.primarySoftColor.themeColor,
                      label: LocaleKeys.admin_geofence.tr(),
                      onTap: () async {
                        final s = await team.settings();
                        if (s == null) return;
                        AppOverlay.showSuccess(LocaleKeys.admin_geofenceInfoApi
                            .tr(namedArgs: {'r': '${s.radius}'}));
                      },
                    ),
                    MenuItemTile(
                      emoji: AppEmojis.alarm,
                      background: AppColors.warningSoftColor.themeColor,
                      label: LocaleKeys.admin_hours.tr(),
                      onTap: () async {
                        final s = await team.settings();
                        if (s == null) return;
                        AppOverlay.showSuccess(
                            LocaleKeys.admin_hoursInfoApi.tr(namedArgs: {
                          'o': '${s.officeHours}',
                          'h': '${s.homeHours}',
                          'start': s.dayStart,
                          'grace': s.graceUntil,
                        }));
                      },
                    ),
                    MenuItemTile(
                      emoji: AppEmojis.speech,
                      background: AppColors.successSoftColor.themeColor,
                      label: LocaleKeys.admin_whatsapp.tr(),
                      onTap: () => AppOverlay.showSuccess(
                          LocaleKeys.admin_whatsappInfo.tr()),
                    ),
                    MenuItemTile(
                      emoji: AppEmojis.globe,
                      background: AppColors.violetSoftColor.themeColor,
                      label: LocaleKeys.settings_language.tr(),
                      onTap: () =>
                          AppSheet.show(context, child: const LanguageSheet()),
                    ),
                    MenuItemTile(
                      emoji: AppEmojis.back,
                      background: AppColors.errorSoftColor.themeColor,
                      label: LocaleKeys.settings_logout.tr(),
                      danger: true,
                      showDivider: false,
                      onTap: () => LogoutAction.run(context),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
