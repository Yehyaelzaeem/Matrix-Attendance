import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/menu_item_tile.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../requests/logic/requests_cubit.dart';

class MyRequestsMenuItem extends StatelessWidget {
  const MyRequestsMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<RequestsCubit>().load();
    return BlocBuilder<RequestsCubit, RequestsState>(
      builder: (context, state) {
        final pending = state is RequestsSuccess ? state.summary.pending : 0;
        return MenuItemTile(
          emoji: AppEmojis.inbox,
          background: AppColors.primarySoftColor.themeColor,
          label: LocaleKeys.requests_title.tr(),
          badge: pending > 0
              ? StatusChip(
                  small: true,
                  tone: ChipTone.yellow,
                  label: LocaleKeys.requests_pendingBadge
                      .tr(namedArgs: {'n': '$pending'}),
                )
              : null,
          onTap: () => context.pushNamed(Routes.myRequestsScreen),
        );
      },
    );
  }
}
