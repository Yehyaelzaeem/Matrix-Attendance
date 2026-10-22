import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/json_reader.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/utils/validators.dart';
import '../../auth/data/models/user_role.dart';
import '../../auth/logic/auth_cubit.dart';
import '../data/models/task_enums.dart';
import '../data/models/task_model.dart';
import '../data/tasks_repo.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit(this._repo, this._auth) : super(const TasksInitial());

  final TasksRepo _repo;
  final AuthCubit _auth;

  int get meId => _auth.currentUser?.id ?? -1;

  String get me => _auth.currentUser?.name ?? '';

  bool get canManage => _auth.currentUser?.role.canManageTasks ?? false;

  bool get isAdmin => _auth.currentUser?.role == UserRole.admin;

  bool get _mine => _auth.currentUser?.role == UserRole.employee;

  List<TaskModel> get tasks =>
      state is TasksSuccess ? (state as TasksSuccess).tasks : const [];

  TaskCounts get counts => state is TasksSuccess
      ? (state as TasksSuccess).counts
      : const TaskCounts();

  Map<int, String> get projectNames => {
        for (final t in tasks) t.projectId: t.projectName,
      };

  Map<int, ({String name, String? image})> get assignees => {
        for (final t in tasks)
          t.assigneeId: (name: t.assignee, image: t.assigneeImage),
      };

  TaskModel? byId(int id) =>
      state is TasksSuccess ? (state as TasksSuccess).byId(id) : null;

  int _version = 0;

  Future<void> load() async {
    if (state is TasksSuccess || state is TasksLoading) return;
    emit(const TasksLoading());
    await refresh();
  }

  Future<void> refresh() async {
    try {
      final (list, counts) = await _repo.getTasks(mine: _mine);
      final current = {for (final t in tasks) t.id: t};
      emit(TasksSuccess(
        [for (final t in list) current[t.id]?.mergeSummary(t) ?? t],
        counts: counts,
        version: ++_version,
      ));
    } catch (e) {
      final msg = NetworkException.from(e).message;
      if (state is TasksSuccess) {
        AppOverlay.showError(msg);
      } else {
        emit(TasksError(msg));
      }
    }
  }

  void _put(TaskModel task) {
    final exists = byId(task.id) != null;
    emit(TasksSuccess(
      exists
          ? [for (final t in tasks) t.id == task.id ? task : t]
          : [task, ...tasks],
      counts: counts,
      version: ++_version,
    ));
  }

  Future<void> loadDetail(int id) async {
    try {
      _put(await _repo.getTask(id));
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
    }
  }

  Future<bool> _transition(int id, TaskStatus to, {String? comment}) async {
    try {
      _put(await _repo.transition(id, to, comment: comment));
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }

  Future<void> move(int id, TaskStatus status) async {
    final task = byId(id);
    if (task == null) return;
    if (!await _transition(id, status)) return;
    final assignee = {'name': Validators.firstName(task.assignee)};
    AppOverlay.showSuccess(switch (status) {
      TaskStatus.doing => LocaleKeys.tasks_toastStarted.tr(),
      TaskStatus.review => LocaleKeys.tasks_toastSubmitted.tr(),
      TaskStatus.test => LocaleKeys.tasks_toastToTest.tr(namedArgs: assignee),
      TaskStatus.done => LocaleKeys.tasks_toastDone.tr(namedArgs: assignee),
      TaskStatus.todo => LocaleKeys.tasks_toastSaved.tr(),
    });
  }

  Future<void> returnTask(int id, String reason) async {
    final task = byId(id);
    if (task == null) return;
    if (await _transition(id, TaskStatus.doing, comment: reason)) {
      AppOverlay.showSuccess(LocaleKeys.tasks_toastReturned
          .tr(namedArgs: {'name': Validators.firstName(task.assignee)}));
    }
  }

  Future<void> toggleDone(int id) async {
    final task = byId(id);
    if (task == null) return;
    if (task.isDone) {
      await _transition(id, TaskStatus.doing,
          comment: LocaleKeys.tasks_reopenedComment.tr());
    } else if (await _transition(id, TaskStatus.done)) {
      AppOverlay.showSuccess(LocaleKeys.tasks_toastMarkedDone
          .tr(namedArgs: {'title': task.title}));
    }
  }

  Future<void> logTime(int id, double hours) async {
    try {
      await _repo.logTime(id, hours);
      _put(await _repo.getTask(id));
      AppOverlay.showSuccess(hours < 1
          ? LocaleKeys.tasks_toastLogged30.tr()
          : LocaleKeys.tasks_toastLoggedHours
              .tr(namedArgs: {'n': '${hours.round()}'}));
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
    }
  }

  Future<bool> saveEdits(
    int id, {
    required TaskStatus status,
    required int assigneeId,
    required String assigneeName,
    required TaskPriority priority,
    required DateTime due,
    required double estimate,
  }) async {
    final task = byId(id);
    if (task == null) return false;
    final regress = status.index < task.status.index;
    try {
      _put(await _repo.update(id, {
        if (status != task.status) 'status': status.name,
        if (status != task.status && regress)
          'comment': LocaleKeys.tasks_statusChangedComment.tr(),
        'assignee_id': assigneeId,
        'priority': priority.name,
        'due_date': JsonReader.formatDate(due),
        'estimate_hours': estimate,
      }));
      AppOverlay.showSuccess(assigneeId != task.assigneeId
          ? LocaleKeys.tasks_toastReassigned
              .tr(namedArgs: {'name': Validators.firstName(assigneeName)})
          : LocaleKeys.tasks_toastSaved.tr());
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }

  Future<void> addComment(int id, String text) async {
    final task = byId(id);
    if (task == null) return;
    try {
      final comment = await _repo.addComment(id, text);
      final latest = byId(id) ?? task;
      _put(latest.copyWith(comments: [...latest.comments, comment]));
      final to = task.assigneeId == meId
          ? LocaleKeys.tasks_projectManager.tr()
          : Validators.firstName(task.assignee);
      AppOverlay.showSuccess(
          LocaleKeys.tasks_toastCommented.tr(namedArgs: {'name': to}));
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
    }
  }

  Future<void> addAttachments(int id, List<TaskAttachment> files) async {
    for (final file in files) {
      final path = file.path;
      if (path == null) continue;
      try {
        final uploaded = await _repo.upload(id, path);
        final latest = byId(id);
        if (latest != null) {
          _put(latest.copyWith(attachments: [...latest.attachments, uploaded]));
        }
      } catch (e) {
        AppOverlay.showError(NetworkException.from(e).message);
      }
    }
  }

  Future<void> removeAttachment(int id, int index) async {
    final task = byId(id);
    if (task == null || index >= task.attachments.length) return;
    final attachment = task.attachments[index];
    try {
      await _repo.removeAttachment(id, attachment.id);
      final latest = byId(id) ?? task;
      _put(latest.copyWith(
          attachments:
              latest.attachments.where((a) => a.id != attachment.id).toList()));
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
    }
  }

  Future<bool> create({
    required int projectId,
    required String title,
    required String description,
    required int assigneeId,
    required String assigneeName,
    required TaskPriority priority,
    required DateTime due,
    required double estimate,
    required List<TaskAttachment> attachments,
  }) async {
    try {
      final task = await _repo.create({
        'project_id': projectId,
        'title': title,
        if (description.isNotEmpty) 'description': description,
        'assignee_id': assigneeId,
        'priority': priority.name,
        'due_date': JsonReader.formatDate(due),
        'estimate_hours': estimate,
      }, [
        for (final a in attachments)
          if (a.path != null) a.path!,
      ]);
      _put(task);
      AppOverlay.showSuccess(LocaleKeys.tasks_toastCreated
          .tr(namedArgs: {'name': Validators.firstName(assigneeName)}));
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }

  Future<bool> delete(int id) async {
    try {
      await _repo.delete(id);
      emit(TasksSuccess(tasks.where((t) => t.id != id).toList(),
          counts: counts, version: ++_version));
      AppOverlay.showSuccess(LocaleKeys.tasks_toastDeleted.tr());
      return true;
    } catch (e) {
      AppOverlay.showError(NetworkException.from(e).message);
      return false;
    }
  }
}
