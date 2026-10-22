import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/paginated.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/json_reader.dart';
import '../../reports/data/models/employee_report.dart';
import '../../reports/data/reports_repo.dart';
import '../data/models/employee_model.dart';
import '../data/team_repo.dart';

class EmployeesState extends Equatable {
  const EmployeesState({
    this.page,
    this.metrics = const {},
    this.query = '',
    this.loading = true,
    this.error,
  });

  final Paginated<EmployeeModel>? page;
  final Map<int, EmployeeMetrics> metrics;
  final String query;
  final bool loading;
  final String? error;

  EmployeesState copyWith({
    Paginated<EmployeeModel>? page,
    Map<int, EmployeeMetrics>? metrics,
    String? query,
    bool? loading,
    String? error,
    bool clearError = false,
  }) =>
      EmployeesState(
        page: page ?? this.page,
        metrics: metrics ?? this.metrics,
        query: query ?? this.query,
        loading: loading ?? this.loading,
        error: clearError ? null : (error ?? this.error),
      );

  @override
  List<Object?> get props => [page, metrics, query, loading, error];
}

class EmployeesCubit extends Cubit<EmployeesState> {
  EmployeesCubit(this._repo, this._reports) : super(const EmployeesState());

  final TeamRepo _repo;
  final ReportsRepo _reports;

  Future<void> load() async {
    _loadMetrics();
    await search('');
  }

  Future<void> _loadMetrics() async {
    try {
      final board = await _reports.board(
        month: JsonReader.formatMonth(DateTime.now()),
        mode: ReportMode.overall,
        sortDesc: true,
      );
      emit(state.copyWith(metrics: {
        for (final p in board.people)
          p.userId: EmployeeMetrics(
            attendance: p.lineIntOrNull('attendance'),
            kpi: p.lineIntOrNull('tasks_kpi'),
            overall: p.score,
          ),
      }));
    } catch (_) {}
  }

  Future<void> search(String query) async {
    emit(state.copyWith(query: query, loading: true, clearError: true));
    try {
      final page = await _repo.searchEmployees(search: query);
      if (state.query != query) return;
      emit(state.copyWith(page: page, loading: false));
    } catch (e) {
      emit(state.copyWith(
          loading: false, error: NetworkException.from(e).message));
    }
  }

  Future<void> refresh() => search(state.query);

  Future<void> loadMore() async {
    final page = state.page;
    if (page == null || !page.hasMore || page.loadingMore) return;
    emit(state.copyWith(page: page.copyWith(loadingMore: true)));
    try {
      final next =
          await _repo.searchEmployees(search: state.query, page: page.nextPage);
      emit(state.copyWith(page: page.append(next)));
    } catch (e) {
      emit(state.copyWith(page: page));
      AppOverlay.showError(NetworkException.from(e).message);
    }
  }

  void upsert(EmployeeModel employee) {
    final page = state.page;
    if (page == null) return;
    final exists = page.items.any((e) => e.id == employee.id);
    emit(state.copyWith(
        page: exists
            ? page.replace((e) => e.id == employee.id, employee)
            : page.prepend(employee)));
  }
}
