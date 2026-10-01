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
  final List<EmployeeReport> reports;
  final Set<String> reviewed;
  final bool currentClosed;
  final bool viewingPrevious;
  final ReportMode mode;
  final bool sortDesc;

  const ReportsSuccess({
    required this.reports,
    required this.reviewed,
    this.currentClosed = false,
    this.viewingPrevious = false,
    this.mode = ReportMode.attendance,
    this.sortDesc = true,
  });

  bool get isLocked => currentClosed || viewingPrevious;

  bool isReviewed(String name) => isLocked || reviewed.contains(name);

  int get reviewedCount => currentClosed ? reports.length : reviewed.length;

  bool get allReviewed => reviewedCount >= reports.length;

  ReportsSuccess copyWith({
    Set<String>? reviewed,
    bool? currentClosed,
    bool? viewingPrevious,
    ReportMode? mode,
    bool? sortDesc,
  }) =>
      ReportsSuccess(
        reports: reports,
        reviewed: reviewed ?? this.reviewed,
        currentClosed: currentClosed ?? this.currentClosed,
        viewingPrevious: viewingPrevious ?? this.viewingPrevious,
        mode: mode ?? this.mode,
        sortDesc: sortDesc ?? this.sortDesc,
      );

  @override
  List<Object?> get props =>
      [reports, reviewed, currentClosed, viewingPrevious, mode, sortDesc];
}

final class ReportsError extends ReportsState {
  final String message;
  const ReportsError(this.message);

  @override
  List<Object?> get props => [message];
}
