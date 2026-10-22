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
  final RequestStatus? filter;
  const RequestsLoading(this.filter);

  @override
  List<Object?> get props => [filter];
}

final class RequestsSuccess extends RequestsState {
  final Paginated<RequestModel> page;
  final RequestSummary summary;
  final RequestStatus? filter;

  const RequestsSuccess({
    required this.page,
    required this.summary,
    this.filter,
  });

  List<RequestModel> get requests => page.items;

  RequestsSuccess copyWith({
    Paginated<RequestModel>? page,
    RequestSummary? summary,
  }) =>
      RequestsSuccess(
        page: page ?? this.page,
        summary: summary ?? this.summary,
        filter: filter,
      );

  @override
  List<Object?> get props => [page, summary, filter];
}

final class RequestsError extends RequestsState {
  final String message;
  final RequestStatus? filter;
  const RequestsError(this.message, this.filter);

  @override
  List<Object?> get props => [message, filter];
}
