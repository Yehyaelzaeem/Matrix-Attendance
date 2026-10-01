import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/date_helper.dart';
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

  ProjectModel? byId(String id) =>
      state is ProjectsSuccess ? (state as ProjectsSuccess).byId(id) : null;

  Future<void> load() async {
    if (state is ProjectsSuccess) return;
    emit(const ProjectsLoading());
    try {
      emit(ProjectsSuccess(await _repo.getProjects()));
    } catch (_) {
      final msg = LocaleKeys.error_generic.tr();
      AppOverlay.showError(msg);
      emit(ProjectsError(msg));
    }
  }

  Future<void> _put(ProjectModel project, {String? toast}) async {
    await _repo.save(project);
    final exists = byId(project.id) != null;
    emit(ProjectsSuccess(exists
        ? [for (final p in projects) p.id == project.id ? project : p]
        : [project, ...projects]));
    if (toast != null) AppOverlay.showSuccess(toast);
  }

  Future<void> setStatus(String id, ProjectStatus status) async {
    final p = byId(id);
    if (p == null) return;
    await _put(
      p.copyWith(
        status: status,
        delivered: status == ProjectStatus.delivered
            ? (p.delivered ?? DateHelper.today())
            : null,
        clearDelivered: status != ProjectStatus.delivered,
      ),
      toast: LocaleKeys.projects_toastStatus
          .tr(namedArgs: {'status': status.label}),
    );
  }

  Future<void> setManager(String id, String name) async {
    final p = byId(id);
    if (p == null) return;
    await _put(p.copyWith(manager: name),
        toast: LocaleKeys.projects_toastManager
            .tr(namedArgs: {'name': Validators.firstName(name)}));
  }

  Future<void> removeMember(String id, String name,
      {required int openTasks}) async {
    final p = byId(id);
    if (p == null) return;
    final args = {'name': Validators.firstName(name), 'n': '$openTasks'};
    await _put(
      p.copyWith(team: p.team.where((m) => m.name != name).toList()),
      toast: openTasks > 0
          ? LocaleKeys.projects_toastRemovedWithTasks.tr(namedArgs: args)
          : LocaleKeys.projects_toastRemoved.tr(namedArgs: args),
    );
  }

  Future<void> addMember(String id, TeamMember member) async {
    final p = byId(id);
    if (p == null) return;
    await _put(p.copyWith(team: [...p.team, member]),
        toast: LocaleKeys.projects_toastAdded
            .tr(namedArgs: {'name': Validators.firstName(member.name)}));
  }

  Future<void> markPaid(String id, int index) async {
    final p = byId(id);
    if (p == null) return;
    final payments = [...p.payments];
    payments[index] = payments[index].markPaid(DateHelper.today());
    await _put(p.copyWith(payments: payments),
        toast: LocaleKeys.projects_toastPaid.tr());
  }

  Future<void> addPayment(String id, PaymentModel payment) async {
    final p = byId(id);
    if (p == null) return;
    await _put(p.copyWith(payments: [...p.payments, payment]),
        toast: LocaleKeys.projects_toastPaymentAdded.tr());
  }

  Future<void> updateClient(String id, ClientInfo client) async {
    final p = byId(id);
    if (p == null) return;
    await _put(p.copyWith(client: client),
        toast: LocaleKeys.projects_toastClientSaved.tr());
  }

  Future<void> setContractFile(String id, String fileName) async {
    final p = byId(id);
    if (p == null) return;
    await _put(p.copyWith(contract: p.contract.withFile(fileName)),
        toast: LocaleKeys.projects_toastContractUploaded.tr());
  }

  Future<String> create({
    required String name,
    required String kind,
    required String description,
    required String clientName,
    required String company,
    required String phone,
    required String manager,
    required double value,
    required String currency,
    required DateTime start,
    required DateTime due,
  }) async {
    final id = 'p${DateTime.now().millisecondsSinceEpoch}';
    final palette = AppColors.avatarPalette;
    final dash = LocaleKeys.common_dash.tr();
    final project = ProjectModel(
      id: id,
      name: name,
      kind: kind.isEmpty ? LocaleKeys.projects_newProjectKind.tr() : kind,
      color: palette[projects.length % palette.length],
      status: ProjectStatus.active,
      description: description.isEmpty
          ? LocaleKeys.projects_noDescription.tr()
          : description,
      manager: manager,
      team: [TeamMember(manager, 'PM')],
      client: ClientInfo(
        name: clientName.isEmpty ? dash : clientName,
        company: company.isEmpty ? dash : company,
        phone: phone.isEmpty ? dash : phone,
        email: dash,
        city: dash,
      ),
      currency: currency,
      value: value,
      payments: value > 0
          ? [
              PaymentModel(
                label: LocaleKeys.projects_downPayment.tr(),
                amount: (value * 0.3).roundToDouble(),
                due: start,
              ),
            ]
          : const [],
      start: start,
      beta: due,
      due: due,
      contract: ContractInfo(
        number: 'MC-${DateTime.now().year}-0${projects.length + 20}',
        signedAt: start,
        months: (due.difference(start).inDays / 30).round().clamp(1, 120),
      ),
    );
    await _put(project, toast: LocaleKeys.projects_toastCreated.tr());
    return id;
  }

  Color colorOf(String id) => byId(id)?.color ?? Colors.grey;
}
