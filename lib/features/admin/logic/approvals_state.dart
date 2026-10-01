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
  final List<RequestModel> requests;
  final List<NewAccountModel> accounts;
  final List<ApprovalLogEntry> log;
  const ApprovalsSuccess({
    required this.requests,
    required this.accounts,
    required this.log,
  });

  int get pendingCount => requests.length + accounts.length;

  @override
  List<Object?> get props => [requests, accounts, log];
}

final class ApprovalsError extends ApprovalsState {
  final String message;
  const ApprovalsError(this.message);

  @override
  List<Object?> get props => [message];
}
