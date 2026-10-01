part of 'requests_cubit.dart';

sealed class RequestsState extends Equatable {
  const RequestsState();

  @override
  List<Object?> get props => [];
}

final class RequestsInitial extends RequestsState {
  const RequestsInitial();
}

final class RequestsLoading extends RequestsState {
  const RequestsLoading();
}

final class RequestsSuccess extends RequestsState {
  final List<RequestModel> requests;
  const RequestsSuccess(this.requests);

  @override
  List<Object?> get props => [requests];
}

final class RequestsError extends RequestsState {
  final String message;
  const RequestsError(this.message);

  @override
  List<Object?> get props => [message];
}
