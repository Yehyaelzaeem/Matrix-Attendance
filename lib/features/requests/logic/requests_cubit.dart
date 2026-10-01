import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../data/models/request_model.dart';
import '../data/requests_repo.dart';

part 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  RequestsCubit(this._repo) : super(const RequestsInitial());

  final RequestsRepo _repo;

  Future<void> load() async {
    if (state is RequestsSuccess) return;
    emit(const RequestsLoading());
    try {
      emit(RequestsSuccess(await _repo.getMyRequests()));
    } catch (_) {
      final msg = LocaleKeys.error_generic.tr();
      AppOverlay.showError(msg);
      emit(RequestsError(msg));
    }
  }

  Future<bool> submit({
    required RequestType type,
    required String title,
    required String subtitle,
    required String reason,
  }) async {
    final current = state is RequestsSuccess
        ? (state as RequestsSuccess).requests
        : const <RequestModel>[];
    try {
      final request = await _repo.submit(RequestModel(
        id: 'r${DateTime.now().millisecondsSinceEpoch}',
        type: type,
        title: title,
        subtitle: subtitle,
        status: RequestStatus.pending,
        reason: reason,
        when: LocaleKeys.common_now.tr(),
      ));
      emit(RequestsSuccess([request, ...current]));
      AppOverlay.showSuccess(LocaleKeys.requests_sent.tr());
      return true;
    } catch (_) {
      AppOverlay.showError(LocaleKeys.error_generic.tr());
      return false;
    }
  }
}
