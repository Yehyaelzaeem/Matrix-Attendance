import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/day_type.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../data/attendance_repo.dart';
import '../data/models/attendance_day.dart';
import '../data/models/attendance_enums.dart';
import '../data/models/attendance_overview.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit(this._repo) : super(const AttendanceInitial());

  final AttendanceRepo _repo;

  AttendanceOverview? get overview =>
      state is AttendanceSuccess ? (state as AttendanceSuccess).overview : null;

  Future<void> load() async {
    if (state is AttendanceSuccess) return;
    emit(const AttendanceLoading());
    try {
      emit(AttendanceSuccess(await _repo.getOverview()));
    } catch (_) {
      _fail();
    }
  }

  Future<AttendanceDay?> checkIn(DayType location) =>
      _apply(() => _repo.checkIn(location));

  Future<AttendanceDay?> pause(PauseReason reason, String note) =>
      _apply(() => _repo.pause(reason, note));

  Future<AttendanceDay?> resume() => _apply(_repo.resume);

  Future<AttendanceDay?> checkOut() => _apply(_repo.checkOut);

  void reset() {
    _repo.reset();
    emit(const AttendanceInitial());
  }

  Future<AttendanceDay?> _apply(Future<AttendanceDay> Function() action) async {
    final current = overview;
    if (current == null) return null;
    try {
      final day = await action();
      emit(AttendanceSuccess(current.copyWith(day: day)));
      return day;
    } catch (_) {
      _fail();
      return null;
    }
  }

  void _fail() {
    final msg = LocaleKeys.error_generic.tr();
    AppOverlay.showError(msg);
    emit(AttendanceError(msg));
  }
}
