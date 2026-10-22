import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/data/models/job_name_model.dart';
import '../data/catalog_repo.dart';

class CatalogState extends Equatable {
  const CatalogState({
    this.categories = const [],
    this.jobNames = const [],
    this.loaded = false,
    this.loading = false,
  });

  final List<JobCategoryModel> categories;
  final List<JobNameModel> jobNames;
  final bool loaded;
  final bool loading;

  String categoryName(int id) {
    for (final c in categories) {
      if (c.id == id) return c.name;
    }
    return '';
  }

  List<JobNameModel> jobsOf(int categoryId) =>
      jobNames.where((j) => j.category?.id == categoryId).toList();

  @override
  List<Object?> get props => [categories, jobNames, loaded, loading];
}

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit(this._repo) : super(const CatalogState());

  final CatalogRepo _repo;

  Future<void> load() async {
    if (state.loaded || state.loading) return;
    emit(const CatalogState(loading: true));
    try {
      final results = await Future.wait([_repo.categories(), _repo.jobNames()]);
      emit(CatalogState(
        categories: results[0] as List<JobCategoryModel>,
        jobNames: results[1] as List<JobNameModel>,
        loaded: true,
      ));
    } catch (_) {
      emit(const CatalogState());
    }
  }
}
