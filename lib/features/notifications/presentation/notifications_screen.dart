import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../../../core/widgets/pagination_widgets/pagination_list.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../auth/data/models/user_role.dart';
import '../../auth/logic/auth_cubit.dart';
import '../../tasks/presentation/widgets/task_details_sheet.dart';
import '../data/models/notification_model.dart';
import '../logic/notifications_cubit.dart';
import 'widgets/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsCubit _cubit = context.read<NotificationsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.refresh();
  }

  void _open(NotificationModel item) {
    _cubit.markRead(item);
    final id = item.contentId;
    final isAdmin =
        context.read<AuthCubit>().currentUser?.role == UserRole.admin;
    switch (item.screen) {
      case NotificationScreen.task when id != null:
        TaskDetailsSheet.open(context, id);
      case NotificationScreen.request when !isAdmin:
        context.pushNamed(Routes.myRequestsScreen);
      case NotificationScreen.announcement:
        context.pushNamed(Routes.decisionsScreen);
      case NotificationScreen.holiday when isAdmin:
        context.pushNamed(Routes.holidaysScreen);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageTopBar(
              title: LocaleKeys.notifications_title.tr(),
              subtitle: state is NotificationsSuccess
                  ? state.unread > 0
                      ? LocaleKeys.notifications_unreadSub
                          .tr(namedArgs: {'n': '${state.unread}'})
                      : LocaleKeys.notifications_allRead.tr()
                  : null,
              showBack: true,
            ),
            Expanded(
              child: CustomScreenStateLayout(
                isLoading: state is NotificationsInitial ||
                    state is NotificationsLoading,
                error: state is NotificationsError
                    ? ErrorModel(
                        code: ErrorEnum.otherError, errorMessage: state.message)
                    : null,
                onRetry: _cubit.refresh,
                builder: (_) {
                  final page = (state as NotificationsSuccess).page;
                  return CustomPaginationListView<NotificationModel>(
                    itemCount: page.items.length,
                    hasMorePages: page.hasMore,
                    isMoreLoading: page.loadingMore,
                    onLoadMore: _cubit.loadMore,
                    onRefresh: _cubit.refresh,
                    emptyMessage: LocaleKeys.notifications_empty.tr(),
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                    builder: (_, i) => NotificationCard(
                      item: page.items[i],
                      onTap: () => _open(page.items[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
