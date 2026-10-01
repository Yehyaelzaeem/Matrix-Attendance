import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/menu_item_tile.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../decisions/logic/decisions_cubit.dart';
import 'language_sheet.dart';
import 'logout_action.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<DecisionsCubit, DecisionsState>(
          bloc: getIt<DecisionsCubit>(),
          builder: (_, state) {
            final unread = state is DecisionsSuccess ? state.unreadCount : 0;
            return MenuItemTile(
              emoji: AppEmojis.megaphone,
              background: AppColors.orangeSoftColor.themeColor,
              label: LocaleKeys.profile_menuDecisions.tr(),
              badge: unread > 0
                  ? StatusChip(
                      small: true,
                      tone: ChipTone.red,
                      label: LocaleKeys.decisions_newBadge
                          .tr(namedArgs: {'n': '$unread'}),
                    )
                  : null,
              onTap: () => context.pushNamed(Routes.decisionsScreen),
            );
          },
        ),
        MenuItemTile(
          emoji: AppEmojis.bell,
          background: AppColors.primarySoftColor.themeColor,
          label: LocaleKeys.profile_menuNotifications.tr(),
          onTap: () =>
              AppOverlay.showSuccess(LocaleKeys.profile_notificationsInfo.tr()),
        ),
        MenuItemTile(
          emoji: AppEmojis.phone,
          background: AppColors.violetSoftColor.themeColor,
          label: LocaleKeys.profile_menuDevice.tr(),
          onTap: () =>
              AppOverlay.showSuccess(LocaleKeys.profile_deviceInfo.tr()),
        ),
        MenuItemTile(
          emoji: AppEmojis.globe,
          background: AppColors.successSoftColor.themeColor,
          label: LocaleKeys.settings_language.tr(),
          onTap: () => AppSheet.show(context, child: const LanguageSheet()),
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
    );
  }
}
