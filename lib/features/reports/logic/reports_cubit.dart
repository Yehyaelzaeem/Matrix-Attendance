import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/date_helper.dart';
import '../../../core/utils/json_reader.dart';
import '../../../core/utils/locale_keys.dart';
import '../data/models/employee_report.dart';
import '../data/reports_repo.dart';

part 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit(this._repo) : super(const ReportsInitial());

  final ReportsRepo _repo;

  ReportMode _mode = ReportMode.attendance;
  bool _sortDesc = true;
  bool _previous = false;

  ReportMode get mode => _mode;
  bool get sortDesc => _sortDesc;
  bool get viewingPrevious => _previous;

  ReportsSuccess? get data =>
      state is ReportsSuccess ? state as ReportsSuccess : null;

  static DateTime get _now => DateTime.now();

  static String get currentMonth => JsonReader.formatMonth(_now);

  static String get previousMonth =>
      JsonReader.formatMonth(DateTime(_now.year, _now.month - 1));

  String get month => _previous ? previousMonth : currentMonth;

  Future<void> load() async {
    if (state is ReportsSuccess || state is ReportsLoading) return;
    emit(const ReportsLoading());
    await _fetch();
  }

  Future<void> refresh() => _fetch();

  Future<void> _fetch() async {
    final current = data;
    if (current != null) emit(current.copyWith(refreshing: true));
    try {
      final board =
          await _repo.board(month: month, mode: _mode, sortDesc: _sortDesc);
      emit(ReportsSuccess(board: board, viewingPrevious: _previous));
    } catch (e) {
      final msg = NetworkException.from(e).message;
      if (current == null) {
        emit(ReportsError(msg));
      } else {
        emit(current.copyWith(refreshing: false));
        AppOverlay.showError(msg);
      }
    }
  }

  Future<void> setMode(ReportMode mode) async {
    _mode = mode;
    await _fetch();
  }

  Future<void> setSortDesc(bool desc) async {
    _sortDesc = desc;
    await _fetch();
  }

  Future<void> viewPrevious(bool previous) async {
    _previous = previous;
    await _fetch();
  }

  void _setReviewed(int userId, bool reviewed) {
    final current = data;
    if (current == null) return;
    final board = current.board;
    final before = board.people.where((p) => p.userId == userId).firstOrNull;
    if (before == null || before.reviewed == reviewed) return;
    emit(current.copyWith(
      board: board.copyWith(
        people: [
          for (final p in board.people)
            p.userId == userId ? p.withReviewed(reviewed) : p,
        ],
        reviewedDone: board.reviewedDone + (reviewed ? 1 : -1),
      ),
    ));
  }

  Future<bool> setReviewed(int userId, String name, bool reviewed) async {
    try {
      await _repo.setReviewed(month, userId, reviewed);
      _setReviewed(userId, reviewed);
      if (reviewed) {
        AppOverlay.showSuccess(
            LocaleKeys.reports_toastReviewed.tr(namedArgs: {'name': name}));
      }
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }

  Future<void> markAllReviewed() async {
    try {
      await _repo.reviewAll(month);
      AppOverlay.showSuccess(LocaleKeys.reports_toastAllReviewed.tr());
      await _fetch();
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
    }
  }

  Future<CloseCheck?> closeCheck() async {
    try {
      return await _repo.closeCheck(month);
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return null;
    }
  }

  Future<bool> closeMonth() async {
    try {
      await _repo.close(month);
      AppOverlay.showSuccess(LocaleKeys.reports_toastClosed.tr(namedArgs: {
        'month': DateHelper.monthName(
            _previous ? DateTime(_now.year, _now.month - 1).month : _now.month)
      }));
      await _fetch();
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }

  Future<bool> reopenMonth(String reason) async {
    try {
      await _repo.reopen(month, reason);
      AppOverlay.showSuccess(LocaleKeys.reports_toastReopened.tr());
      await _fetch();
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }
}
