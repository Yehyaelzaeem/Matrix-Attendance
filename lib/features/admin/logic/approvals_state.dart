part of 'approvals_cubit.dart';

sealed class ApprovalsState extends Equatable {
  const ApprovalsState();

  @override
  List<Object?> get props => [];
}

final class ApprovalsInitial extends ApprovalsState {
  const ApprovalsInitial();
}

final class ApprovalsLoading extends ApprovalsState {
  const ApprovalsLoading();
}

final class ApprovalsSuccess extends ApprovalsState {
  final Paginated<RequestModel> pending;
  final RoleSummary summary;
  final Paginated<RequestModel>? log;
  final bool logLoading;
  final UserRole? role;

  const ApprovalsSuccess({
    required this.pending,
    required this.summary,
    this.log,
    this.logLoading = false,
    this.role,
  });

  List<RequestModel> get requests => pending.items;

  int get pendingCount => pending.total;

  int countFrom(UserRole? role) => summary.of(role);

  ApprovalsSuccess copyWith({
    Paginated<RequestModel>? pending,
    RoleSummary? summary,
    Paginated<RequestModel>? log,
    bool? logLoading,
  }) =>
      ApprovalsSuccess(
        pending: pending ?? this.pending,
        summary: summary ?? this.summary,
        log: log ?? this.log,
        logLoading: logLoading ?? this.logLoading,
        role: role,
      );

  @override
  List<Object?> get props => [pending, summary, log, logLoading, role];
}

final class ApprovalsError extends ApprovalsState {
  final String message;
  const ApprovalsError(this.message);

  @override
  List<Object?> get props => [message];
}
