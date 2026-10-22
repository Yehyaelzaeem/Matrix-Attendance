part of 'notifications_cubit.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

final class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

final class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

final class NotificationsSuccess extends NotificationsState {
  final Paginated<NotificationModel> page;
  final int unread;

  const NotificationsSuccess({required this.page, required this.unread});

  NotificationsSuccess copyWith({
    Paginated<NotificationModel>? page,
    int? unread,
  }) =>
      NotificationsSuccess(
        page: page ?? this.page,
        unread: unread ?? this.unread,
      );

  @override
  List<Object?> get props => [page, unread];
}

final class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}
