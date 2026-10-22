import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/json_reader.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/utils/validators.dart';
import '../data/models/project_model.dart';
import '../data/projects_repo.dart';

part 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  ProjectsCubit(this._repo) : super(const ProjectsInitial());

  final ProjectsRepo _repo;

  List<ProjectModel> get projects =>
      state is ProjectsSuccess ? (state as ProjectsSuccess).projects : const [];

  ProjectModel? byId(int id) =>
      state is ProjectsSuccess ? (state as ProjectsSuccess).byId(id) : null;

  Future<void> load() async {
    if (state is ProjectsSuccess || state is ProjectsLoading) return;
    emit(const ProjectsLoading());
    await refresh();
  }

  Future<void> refresh() async {
    try {
      emit(ProjectsSuccess(await _repo.getProjects()));
    } catch (e) {
      final msg = NetworkException.from(e).message;
      if (state is ProjectsSuccess) {
        AppOverlay.showError(msg);
      } else {
        emit(ProjectsError(msg));
      }
    }
  }

  Future<void> reload(int id) async {
    try {
      _put(await _repo.getProject(id));
    } catch (_) {}
  }

  void _put(ProjectModel project) {
    final exists = byId(project.id) != null;
    emit(ProjectsSuccess(exists
        ? [for (final p in projects) p.id == project.id ? project : p]
        : [project, ...projects]));
  }

  void putAll(List<ProjectModel> updated) {
    if (updated.isEmpty) return;
    final byId = {for (final p in updated) p.id: p};
    emit(ProjectsSuccess([for (final p in projects) byId[p.id] ?? p]));
  }

  Future<bool> _run(Future<ProjectModel> Function() call,
      {String? toast}) async {
    try {
      _put(await call());
      if (toast != null) AppOverlay.showSuccess(toast);
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }

  Future<bool> setStatus(int id, ProjectStatus status) => _run(
        () => _repo.setStatus(id, status),
        toast: LocaleKeys.projects_toastStatus
            .tr(namedArgs: {'status': status.label}),
      );

  Future<bool> setManager(int id, TeamMember member) => _run(
        () => _repo.setManager(id, member.userId),
        toast: LocaleKeys.projects_toastManager
            .tr(namedArgs: {'name': Validators.firstName(member.name)}),
      );

  Future<bool> removeMember(int id, TeamMember member,
          {required int openTasks}) =>
      _run(
        () => _repo.removeMember(id, member.userId),
        toast: (openTasks > 0
                ? LocaleKeys.projects_toastRemovedWithTasks
                : LocaleKeys.projects_toastRemoved)
            .tr(namedArgs: {
          'name': Validators.firstName(member.name),
          'n': '$openTasks',
        }),
      );

  Future<bool> addMember(int id,
          {required int userId, required String name, required String role}) =>
      _run(
        () => _repo.addMember(id, userId, role),
        toast: LocaleKeys.projects_toastAdded
            .tr(namedArgs: {'name': Validators.firstName(name)}),
      );

  Future<bool> updateClient(int id, ClientInfo client) => _run(
        () => _repo.updateClient(id, client),
        toast: LocaleKeys.projects_toastClientSaved.tr(),
      );

  Future<bool> uploadContract(int id, String path) => _run(
        () => _repo.uploadContract(id, path),
        toast: LocaleKeys.projects_toastContractUploaded.tr(),
      );

  Future<bool> addPayment(
      int id, String label, double amount, DateTime due) async {
    final p = byId(id);
    try {
      final payment = await _repo.addPayment(id, label, amount, due);
      if (p != null) _put(p.copyWith(payments: [...p.payments, payment]));
      AppOverlay.showSuccess(LocaleKeys.projects_toastPaymentAdded.tr());
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }

  Future<bool> markPaid(int id, int paymentId) async {
    final p = byId(id);
    try {
      final payment = await _repo.markPaid(id, paymentId);
      if (p != null) {
        _put(p.copyWith(payments: [
          for (final x in p.payments) x.id == paymentId ? payment : x,
        ]));
      }
      AppOverlay.showSuccess(LocaleKeys.projects_toastPaid.tr());
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }

  Future<int?> create({
    required String name,
    required String kind,
    required String description,
    required String clientName,
    required String company,
    required String phone,
    required int? managerId,
    required double value,
    required String currency,
    required DateTime start,
    required DateTime due,
  }) async {
    try {
      var project = await _repo.create({
        'name': name,
        'kind': kind.isEmpty ? LocaleKeys.projects_newProjectKind.tr() : kind,
        if (description.isNotEmpty) 'description': description,
        if (managerId != null) 'manager_id': managerId,
        'currency': currency,
        'contract_value': value,
        'start_date': JsonReader.formatDate(start),
        'due_date': JsonReader.formatDate(due),
      });
      if (clientName.isNotEmpty) {
        project = await _repo.updateClient(project.id,
            ClientInfo(name: clientName, company: company, phone: phone));
      }
      _put(project);
      AppOverlay.showSuccess(LocaleKeys.projects_toastCreated.tr());
      return project.id;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return null;
    }
  }

  Color colorOf(int id) => byId(id)?.color ?? ProjectModel.parseColor(null, id);
}
