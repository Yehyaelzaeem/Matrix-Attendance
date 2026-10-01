import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../data/board_repo.dart';
import '../data/models/board_entry.dart';

part 'board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  BoardCubit(this._repo) : super(const BoardInitial());

  final BoardRepo _repo;

  BoardDay get today => _repo.todaySnapshot();

  Future<void> loadDay(int daysAgo) async {
    emit(BoardLoading(daysAgo));
    try {
      emit(BoardSuccess(await _repo.getDay(daysAgo)));
    } catch (_) {
      final msg = LocaleKeys.error_generic.tr();
      AppOverlay.showError(msg);
      emit(BoardError(msg));
    }
  }
}
