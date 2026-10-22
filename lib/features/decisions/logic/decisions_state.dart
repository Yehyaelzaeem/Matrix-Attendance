part of 'decisions_cubit.dart';

sealed class DecisionsState extends Equatable {
  const DecisionsState();

  @override
  List<Object?> get props => [];
}

final class DecisionsInitial extends DecisionsState {
  const DecisionsInitial();
}

final class DecisionsLoading extends DecisionsState {
  const DecisionsLoading();
}

final class DecisionsSuccess extends DecisionsState {
  final Paginated<DecisionModel> page;
  final int unread;

  const DecisionsSuccess(this.page, {this.unread = 0});

  List<DecisionModel> get decisions => page.items;

  int get unreadCount => unread;

  DecisionModel? get pinned {
    for (final d in decisions) {
      if (d.kind == DecisionKind.decision && !d.acked) return d;
    }
    return null;
  }

  DecisionsSuccess copyWith({Paginated<DecisionModel>? page, int? unread}) =>
      DecisionsSuccess(page ?? this.page, unread: unread ?? this.unread);

  @override
  List<Object?> get props => [page, unread];
}

final class DecisionsError extends DecisionsState {
  final String message;
  const DecisionsError(this.message);

  @override
  List<Object?> get props => [message];
}
