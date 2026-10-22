import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/date_helper.dart';
import '../data/board_repo.dart';
import '../data/models/board_entry.dart';

part 'board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  BoardCubit(this._repo) : super(const BoardInitial());

  final BoardRepo _repo;
  BoardDay? _today;

  BoardSummary get today => _today?.summary ?? const BoardSummary();

  Future<void> loadDay(int daysAgo, {bool silent = false}) async {
    if (!silent) emit(BoardLoading(daysAgo));
    try {
      final day = await _repo.getDay(DateHelper.fromToday(-daysAgo));
      if (daysAgo == 0) _today = day;
      emit(BoardSuccess(day));
    } catch (e) {
      emit(BoardError(NetworkException.from(e).message, daysAgo));
    }
  }

  void applyLive(BoardDay day) {
    final current = state;
    if (day.daysAgo == 0) _today = day;
    if (current is BoardSuccess && current.day.date == day.date) {
      emit(BoardSuccess(day));
    }
  }
}
