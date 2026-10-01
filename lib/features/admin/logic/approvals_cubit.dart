import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/utils/validators.dart';
import '../../auth/data/models/user_role.dart';
import '../../requests/data/models/request_model.dart';
import '../data/approvals_repo.dart';
import '../data/models/approval_models.dart';

part 'approvals_state.dart';

class ApprovalsCubit extends Cubit<ApprovalsState> {
  ApprovalsCubit(this._repo) : super(const ApprovalsInitial());

  final ApprovalsRepo _repo;

  Future<void> load() async {
    if (state is ApprovalsSuccess) return;
    emit(const ApprovalsLoading());
    try {
      await _refresh();
    } catch (_) {
      final msg = LocaleKeys.error_generic.tr();
      AppOverlay.showError(msg);
      emit(ApprovalsError(msg));
    }
  }

  Future<void> _refresh() async {
    final (requests, accounts, log) = await _repo.getAll();
    emit(ApprovalsSuccess(requests: requests, accounts: accounts, log: log));
  }

  String _what(RequestModel r) => '${r.type.label} – ${r.title}';

  Future<void> approve(RequestModel request) async {
    await _repo.decideRequest(
      request.id,
      ApprovalLogEntry(
        name: request.employee ?? '',
        what: _what(request),
        outcome: LogOutcome.approved,
        when: LocaleKeys.common_now.tr(),
      ),
    );
    await _refresh();
    AppOverlay.showSuccess(LocaleKeys.admin_toastApproved
        .tr(namedArgs: {'name': Validators.firstName(request.employee ?? '')}));
  }

  Future<void> reject(RequestModel request, String reason) async {
    await _repo.decideRequest(
      request.id,
      ApprovalLogEntry(
        name: request.employee ?? '',
        what: _what(request),
        outcome: LogOutcome.rejected,
        when: LocaleKeys.common_now.tr(),
        reason: reason,
      ),
    );
    await _refresh();
    AppOverlay.showSuccess(LocaleKeys.admin_toastRejected.tr());
  }

  Future<void> denyAccount(NewAccountModel account) async {
    await _repo.decideAccount(
      account.name,
      ApprovalLogEntry(
        name: account.name,
        what: LocaleKeys.admin_newAccountRequest.tr(),
        outcome: LogOutcome.rejected,
        when: LocaleKeys.common_now.tr(),
        reason: LocaleKeys.admin_notEmployee.tr(),
      ),
    );
    await _refresh();
    AppOverlay.showSuccess(LocaleKeys.admin_toastAccountDenied.tr());
  }

  Future<void> activateAccount(NewAccountModel account, UserRole role) async {
    await _repo.decideAccount(
      account.name,
      ApprovalLogEntry(
        name: account.name,
        what: LocaleKeys.admin_activatedAs.tr(namedArgs: {'role': role.label}),
        outcome: LogOutcome.activated,
        when: LocaleKeys.common_now.tr(),
      ),
    );
    await _refresh();
    AppOverlay.showSuccess(LocaleKeys.admin_toastActivated
        .tr(namedArgs: {'name': Validators.firstName(account.name)}));
  }
}
