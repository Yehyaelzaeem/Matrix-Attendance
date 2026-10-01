import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../data/auth_repo.dart';
import '../data/models/register_payload.dart';
import '../data/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repo) : super(const AuthInitial());

  final AuthRepo _repo;

  UserModel? currentUser;
  String? _otpPhone;
  RegisterPayload? _registration;
  int _attempt = 0;

  bool get isRegisterFlow => _registration != null;

  UserModel? restoreSession() {
    currentUser = _repo.cachedUser();
    return currentUser;
  }

  Future<void> sendLoginOtp(String phone) async {
    _registration = null;
    await _sendOtp(phone);
  }

  Future<void> sendRegisterOtp(RegisterPayload payload) async {
    _registration = payload;
    await _sendOtp(payload.phone);
  }

  Future<void> resendOtp() async {
    final phone = _otpPhone;
    if (phone == null) return;
    await _sendOtp(phone);
    AppOverlay.showSuccess(LocaleKeys.auth_otpResent.tr());
  }

  Future<void> _sendOtp(String phone) async {
    emit(const AuthLoading());
    try {
      final registration = _registration;
      if (registration != null) {
        await _repo.register(registration);
      } else {
        await _repo.sendLoginOtp(phone);
      }
      _otpPhone = phone;
      _attempt++;
      emit(AuthOtpSent(phone, isRegister: isRegisterFlow, attempt: _attempt));
    } catch (e) {
      _fail(e);
    }
  }

  Future<void> verifyOtp(String code) async {
    final phone = _otpPhone;
    if (phone == null) return;
    emit(const AuthLoading());
    try {
      final user = await _repo.verifyOtp(phone: phone, code: code);
      currentUser = user;
      _registration = null;
      emit(AuthSuccess(user));
    } catch (e) {
      _fail(e);
    }
  }

  Future<void> refreshStatus() async {
    final user = currentUser;
    if (user == null) return;
    emit(const AuthLoading());
    try {
      final updated = await _repo.fetchMe();
      currentUser = updated;
      if (updated.isActive) {
        AppOverlay.showSuccess(LocaleKeys.auth_accountActivated.tr());
      } else {
        AppOverlay.showError(LocaleKeys.auth_stillPending.tr());
      }
      emit(AuthSuccess(updated));
    } catch (e) {
      _fail(e);
    }
  }

  Future<void> updateProfile({
    required String name,
    required String jobTitle,
    required String email,
  }) async {
    if (currentUser == null) return;
    try {
      final updated = await _repo.updateProfile(
          name: name, jobTitle: jobTitle, email: email);
      currentUser = updated;
      AppOverlay.showSuccess(LocaleKeys.admin_profileSaved.tr());
      emit(AuthSuccess(updated));
    } catch (e) {
      _fail(e);
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    currentUser = null;
    _registration = null;
    _otpPhone = null;
    emit(const AuthInitial());
  }

  void _fail(Object e) {
    final msg =
        e is NetworkException ? e.message : LocaleKeys.error_generic.tr();
    AppOverlay.showError(msg);
    emit(AuthError(msg));
  }
}
