import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/paginated.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../data/models/request_model.dart';
import '../data/requests_repo.dart';

part 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  RequestsCubit(this._repo) : super(const RequestsInitial());

  final RequestsRepo _repo;

  RequestStatus? get filter => switch (state) {
        RequestsLoading s => s.filter,
        RequestsSuccess s => s.filter,
        RequestsError s => s.filter,
        _ => null,
      };

  int get pendingCount =>
      state is RequestsSuccess ? (state as RequestsSuccess).summary.pending : 0;

  Future<void> load() async {
    if (state is RequestsSuccess || state is RequestsLoading) return;
    await setFilter(null);
  }

  Future<void> setFilter(RequestStatus? filter) async {
    emit(RequestsLoading(filter));
    try {
      final (page, summary) = await _repo.getMyRequests(status: filter);
      emit(RequestsSuccess(page: page, summary: summary, filter: filter));
    } catch (e) {
      emit(RequestsError(NetworkException.from(e).message, filter));
    }
  }

  Future<void> refresh() async {
    try {
      final (page, summary) = await _repo.getMyRequests(status: filter);
      emit(RequestsSuccess(page: page, summary: summary, filter: filter));
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! RequestsSuccess ||
        !current.page.hasMore ||
        current.page.loadingMore) {
      return;
    }
    emit(current.copyWith(page: current.page.copyWith(loadingMore: true)));
    try {
      final (next, summary) = await _repo.getMyRequests(
          status: current.filter, page: current.page.nextPage);
      emit(current.copyWith(page: current.page.append(next), summary: summary));
    } catch (e) {
      emit(current);
      AppOverlay.showError(NetworkException.from(e).message);
    }
  }

  Future<bool> submit({
    required RequestType type,
    required String reason,
    required Map<String, dynamic> payload,
  }) async {
    try {
      await _repo.submit(type: type, reason: reason, payload: payload);
      AppOverlay.showSuccess(LocaleKeys.requests_sent.tr());
      await refresh();
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }
}
