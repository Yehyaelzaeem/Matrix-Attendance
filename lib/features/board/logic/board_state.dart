part of 'board_cubit.dart';

sealed class BoardState extends Equatable {
  const BoardState();

  @override
  List<Object?> get props => [];
}

final class BoardInitial extends BoardState {
  const BoardInitial();
}

final class BoardLoading extends BoardState {
  final int daysAgo;
  const BoardLoading(this.daysAgo);

  @override
  List<Object?> get props => [daysAgo];
}

final class BoardSuccess extends BoardState {
  final BoardDay day;
  const BoardSuccess(this.day);

  @override
  List<Object?> get props => [day];
}

final class BoardError extends BoardState {
  final String message;
  final int daysAgo;
  const BoardError(this.message, this.daysAgo);

  @override
  List<Object?> get props => [message, daysAgo];
}
