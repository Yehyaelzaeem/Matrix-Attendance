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
  final List<DecisionModel> decisions;
  const DecisionsSuccess(this.decisions);

  int get unreadCount => decisions.where((d) => d.needsAction).length;

  DecisionModel? get pinned {
    for (final d in decisions) {
      if (d.kind == DecisionKind.decision && !d.acked) return d;
    }
    return null;
  }

  @override
  List<Object?> get props => [decisions];
}

final class DecisionsError extends DecisionsState {
  final String message;
  const DecisionsError(this.message);

  @override
  List<Object?> get props => [message];
}
