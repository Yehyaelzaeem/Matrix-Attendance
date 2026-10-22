import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/paginated.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../data/models/notification_model.dart';
import '../data/notifications_repo.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repo) : super(const NotificationsInitial());

  final NotificationsRepo _repo;

  int get unread => state is NotificationsSuccess
      ? (state as NotificationsSuccess).unread
      : 0;

  Future<void> load() async {
    if (state is NotificationsSuccess || state is NotificationsLoading) return;
    emit(const NotificationsLoading());
    await refresh();
  }

  Future<void> refresh() async {
    try {
      final (page, unread) = await _repo.list();
      emit(NotificationsSuccess(page: page, unread: unread));
    } catch (e) {
      final message = NetworkException.from(e).message;
      if (state is NotificationsSuccess) return AppOverlay.showError(message);
      emit(NotificationsError(message));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! NotificationsSuccess ||
        !current.page.hasMore ||
        current.page.loadingMore) {
      return;
    }
    emit(current.copyWith(page: current.page.copyWith(loadingMore: true)));
    try {
      final (next, unread) = await _repo.list(page: current.page.nextPage);
      emit(current.copyWith(page: current.page.append(next), unread: unread));
    } catch (e) {
      emit(current);
      AppOverlay.showError(NetworkException.from(e).message);
    }
  }

  Future<void> markRead(NotificationModel item) async {
    final current = state;
    if (item.isRead || current is! NotificationsSuccess) return;
    emit(current.copyWith(
      page: current.page.replace((n) => n.id == item.id, item.markRead()),
      unread: (current.unread - 1).clamp(0, current.unread),
    ));
    try {
      await _repo.markRead(item.id);
    } catch (_) {}
  }
}
