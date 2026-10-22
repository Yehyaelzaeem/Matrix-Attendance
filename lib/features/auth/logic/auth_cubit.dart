import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../data/auth_repo.dart';
import '../data/models/device_model.dart';
import '../data/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repo) : super(const AuthInitial());

  final AuthRepo _repo;

  UserModel? currentUser;
  String? _otpPhone;
  int _attempt = 0;

  bool get isRegisterFlow => false;

  UserModel? restoreSession() {
    currentUser = _repo.cachedUser();
    return currentUser;
  }

  Future<void> sendLoginOtp(String phone) async {
    emit(const AuthLoading());
    try {
      await _repo.sendLoginOtp(phone);
      _otpPhone = phone;
      _attempt++;
      emit(AuthOtpSent(phone, isRegister: false, attempt: _attempt));
    } catch (e) {
      _fail(e);
    }
  }

  Future<void> resendOtp() async {
    final phone = _otpPhone;
    if (phone == null) return;
    try {
      await _repo.resendOtp(phone);
      _attempt++;
      emit(AuthOtpSent(phone, isRegister: false, attempt: _attempt));
      AppOverlay.showSuccess(LocaleKeys.auth_otpResent.tr());
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
      emit(AuthSuccess(user));
    } catch (e) {
      _fail(e);
    }
  }

  Future<void> refreshStatus() => refreshMe();

  Future<void> refreshMe() async {
    if (currentUser == null) return;
    try {
      final updated = await _repo.fetchMe();
      currentUser = updated;
      emit(AuthSuccess(updated));
    } catch (_) {}
  }

  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? email,
    String? orgTitle,
    String? imagePath,
  }) async {
    if (currentUser == null) return false;
    try {
      final updated = await _repo.updateProfile(
        name: name,
        phone: phone,
        email: email,
        orgTitle: orgTitle,
        imagePath: imagePath,
      );
      currentUser = updated;
      AppOverlay.showSuccess(LocaleKeys.admin_profileSaved.tr());
      emit(AuthSuccess(updated));
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }

  Future<DeviceModel?> myDevice() async {
    try {
      return await _repo.myDevice();
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return null;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    clearSession();
  }

  void clearSession() {
    currentUser = null;
    _otpPhone = null;
    emit(const AuthInitial());
  }

  void _fail(Object e) {
    final msg = NetworkException.from(e).message;
    AppOverlay.showError(msg);
    emit(AuthError(msg));
  }
}
