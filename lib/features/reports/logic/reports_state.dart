part of 'reports_cubit.dart';

sealed class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

final class ReportsInitial extends ReportsState {
  const ReportsInitial();
}

final class ReportsLoading extends ReportsState {
  const ReportsLoading();
}

final class ReportsSuccess extends ReportsState {
  final ReportBoard board;
  final bool viewingPrevious;
  final bool refreshing;

  const ReportsSuccess({
    required this.board,
    this.viewingPrevious = false,
    this.refreshing = false,
  });

  ReportMode get mode => board.mode;

  List<ReportPerson> get people => board.people;

  bool get isLocked => board.closed;

  bool get currentClosed => !viewingPrevious && board.closed;

  int get reviewedCount => board.reviewedDone;

  int get total => board.reviewedTotal;

  bool get allReviewed => board.allReviewed;

  bool isReviewed(int userId) =>
      isLocked || people.any((p) => p.userId == userId && p.reviewed);

  ReportsSuccess copyWith({ReportBoard? board, bool? refreshing}) =>
      ReportsSuccess(
        board: board ?? this.board,
        viewingPrevious: viewingPrevious,
        refreshing: refreshing ?? this.refreshing,
      );

  @override
  List<Object?> get props => [board, viewingPrevious, refreshing];
}

final class ReportsError extends ReportsState {
  final String message;
  const ReportsError(this.message);

  @override
  List<Object?> get props => [message];
}
