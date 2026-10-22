import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/services/location_service.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../data/attendance_repo.dart';
import '../data/whatsapp_group_repo.dart';
import '../data/models/attendance_day.dart';
import '../data/models/attendance_enums.dart';
import '../data/models/attendance_overview.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit(this._repo, this._whatsapp, this._location)
      : super(const AttendanceInitial());

  final AttendanceRepo _repo;
  final WhatsappGroupRepo _whatsapp;
  final LocationService _location;

  AttendanceOverview? get overview =>
      state is AttendanceSuccess ? (state as AttendanceSuccess).overview : null;

  Future<void> load({bool force = false}) async {
    if (state is AttendanceSuccess && !force) return;
    if (state is! AttendanceSuccess) emit(const AttendanceLoading());
    try {
      emit(AttendanceSuccess(await _repo.getOverview()));
    } catch (e) {
      final msg = NetworkException.from(e).message;
      if (state is AttendanceSuccess) {
        AppOverlay.showError(msg);
      } else {
        emit(AttendanceError(msg));
      }
    }
  }

  Future<void> refresh() => load(force: true);

  Future<LocationFix?> locate() async {
    try {
      return await _location.currentFix();
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return null;
    }
  }

  Future<AttendanceDay?> checkIn(LocationFix fix) =>
      _apply(() => _repo.checkIn(fix));

  Future<AttendanceDay?> pause(PauseReason reason, String note) =>
      _apply(() => _repo.pause(reason, note));

  Future<AttendanceDay?> resume() => _apply(_repo.resume);

  Future<AttendanceDay?> checkOut() => _apply(_repo.checkOut);

  Future<void> postToGroup(String message) async {
    if (!_whatsapp.isEnabled) return;
    try {
      await _whatsapp.send(message);
      AppOverlay.showSuccess(LocaleKeys.attendance_waPosted.tr());
    } catch (e) {
      debugPrint(
          'WhatsApp group post failed: ${e is NetworkException ? e.message : e}');
      AppOverlay.showError(LocaleKeys.attendance_waSendFailed.tr());
    }
  }

  Future<AttendanceDay?> _apply(Future<AttendanceDay> Function() action) async {
    try {
      final day = await action();
      final current = overview;
      if (current != null) emit(AttendanceSuccess(current.copyWith(day: day)));
      return day;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return null;
    }
  }
}
