import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/date_helper.dart';
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

  String get me => _auth.currentUser?.name ?? '';

  bool get canManage => _auth.currentUser?.role.canManageTasks ?? false;

  bool get isAdmin => _auth.currentUser?.role == UserRole.admin;

  List<TaskModel> get tasks =>
      state is TasksSuccess ? (state as TasksSuccess).tasks : const [];

  TaskModel? byId(String id) =>
      state is TasksSuccess ? (state as TasksSuccess).byId(id) : null;

  Future<void> load() async {
    if (state is TasksSuccess) return;
    emit(const TasksLoading());
    try {
      emit(TasksSuccess(await _repo.getTasks()));
    } catch (_) {
      final msg = LocaleKeys.error_generic.tr();
      AppOverlay.showError(msg);
      emit(TasksError(msg));
    }
  }

  String get _actor => Validators.firstName(me);

  TaskComment _system(String text) => TaskComment(
      text: text, at: LocaleKeys.common_now.tr(), kind: CommentKind.system);

  Future<void> _put(TaskModel task) async {
    await _repo.save(task);
    emit(TasksSuccess([
      for (final t in tasks)
        if (t.id == task.id) task else t,
      if (byId(task.id) == null) task,
    ]));
  }

  Future<void> move(String id, TaskStatus status) async {
    final task = byId(id);
    if (task == null) return;
    final args = {'name': _actor};
    final note = switch (status) {
      TaskStatus.doing => LocaleKeys.tasks_sysStarted.tr(namedArgs: args),
      TaskStatus.review => LocaleKeys.tasks_sysSubmitted.tr(namedArgs: args),
      TaskStatus.test => LocaleKeys.tasks_sysToTest.tr(namedArgs: args),
      TaskStatus.done => LocaleKeys.tasks_sysDone.tr(namedArgs: args),
      TaskStatus.todo => LocaleKeys.tasks_sysStatus
          .tr(namedArgs: {...args, 'status': status.label}),
    };
    await _put(task.copyWith(
      status: status,
      doneAt: status == TaskStatus.done ? DateHelper.today() : null,
      clearDoneAt: status != TaskStatus.done,
      returned: status == TaskStatus.doing ? task.returned : false,
      comments: [...task.comments, _system(note)],
    ));
    final assignee = {'name': Validators.firstName(task.assignee)};
    AppOverlay.showSuccess(switch (status) {
      TaskStatus.doing => LocaleKeys.tasks_toastStarted.tr(),
      TaskStatus.review => LocaleKeys.tasks_toastSubmitted.tr(),
      TaskStatus.test => LocaleKeys.tasks_toastToTest.tr(namedArgs: assignee),
      TaskStatus.done => LocaleKeys.tasks_toastDone.tr(namedArgs: assignee),
      TaskStatus.todo => LocaleKeys.tasks_toastSaved.tr(),
    });
  }

  Future<void> returnTask(String id, String reason) async {
    final task = byId(id);
    if (task == null) return;
    await _put(task.copyWith(
      status: TaskStatus.doing,
      clearDoneAt: true,
      returned: true,
      returns: task.returns + 1,
      comments: [
        ...task.comments,
        TaskComment(
            by: me,
            text: reason,
            at: LocaleKeys.common_now.tr(),
            kind: CommentKind.returned),
      ],
    ));
    AppOverlay.showSuccess(LocaleKeys.tasks_toastReturned
        .tr(namedArgs: {'name': Validators.firstName(task.assignee)}));
  }

  Future<void> toggleDone(String id) async {
    final task = byId(id);
    if (task == null) return;
    if (task.isDone) {
      await _put(task.copyWith(status: TaskStatus.doing, clearDoneAt: true));
    } else {
      await _put(
          task.copyWith(status: TaskStatus.done, doneAt: DateHelper.today()));
      AppOverlay.showSuccess(LocaleKeys.tasks_toastMarkedDone
          .tr(namedArgs: {'title': task.title}));
    }
  }

  Future<void> logTime(String id, double hours) async {
    final task = byId(id);
    if (task == null) return;
    final startNow = task.status == TaskStatus.todo;
    await _put(task.copyWith(
      spent: double.parse((task.spent + hours).toStringAsFixed(1)),
      status: startNow ? TaskStatus.doing : null,
      comments: startNow
          ? [
              ...task.comments,
              _system(
                  LocaleKeys.tasks_sysStarted.tr(namedArgs: {'name': _actor})),
            ]
          : null,
    ));
    AppOverlay.showSuccess(hours < 1
        ? LocaleKeys.tasks_toastLogged30.tr()
        : LocaleKeys.tasks_toastLoggedHours
            .tr(namedArgs: {'n': '${hours.round()}'}));
  }

  Future<void> saveEdits(
    String id, {
    required TaskStatus status,
    required String assignee,
    required TaskPriority priority,
    required DateTime due,
    required double estimate,
  }) async {
    final task = byId(id);
    if (task == null) return;
    final notes = <TaskComment>[
      if (status != task.status)
        _system(LocaleKeys.tasks_sysStatus
            .tr(namedArgs: {'name': _actor, 'status': status.label})),
      if (assignee != task.assignee)
        _system(LocaleKeys.tasks_sysReassigned.tr(
            namedArgs: {'name': _actor, 'to': Validators.firstName(assignee)})),
    ];
    await _put(task.copyWith(
      status: status,
      assignee: assignee,
      priority: priority,
      due: due,
      estimate: estimate,
      doneAt: status == TaskStatus.done
          ? (task.doneAt ?? DateHelper.today())
          : null,
      clearDoneAt: status != TaskStatus.done,
      comments: [...task.comments, ...notes],
    ));
    AppOverlay.showSuccess(assignee != task.assignee
        ? LocaleKeys.tasks_toastReassigned
            .tr(namedArgs: {'name': Validators.firstName(assignee)})
        : LocaleKeys.tasks_toastSaved.tr());
  }

  Future<void> addComment(String id, String text) async {
    final task = byId(id);
    if (task == null) return;
    await _put(task.copyWith(comments: [
      ...task.comments,
      TaskComment(by: me, text: text, at: LocaleKeys.common_now.tr()),
    ]));
    final to = task.assignee == me
        ? LocaleKeys.tasks_projectManager.tr()
        : Validators.firstName(task.assignee);
    AppOverlay.showSuccess(
        LocaleKeys.tasks_toastCommented.tr(namedArgs: {'name': to}));
  }

  Future<void> addAttachments(String id, List<TaskAttachment> files) async {
    final task = byId(id);
    if (task == null || files.isEmpty) return;
    await _put(task.copyWith(attachments: [...task.attachments, ...files]));
  }

  Future<void> removeAttachment(String id, int index) async {
    final task = byId(id);
    if (task == null) return;
    await _put(
        task.copyWith(attachments: [...task.attachments]..removeAt(index)));
  }

  Future<void> create({
    required String projectId,
    required String title,
    required String description,
    required String assignee,
    required TaskPriority priority,
    required DateTime due,
    required double estimate,
    required List<TaskAttachment> attachments,
  }) async {
    final task = TaskModel(
      id: _repo.nextId(),
      projectId: projectId,
      title: title,
      description: description,
      assignee: assignee,
      status: TaskStatus.todo,
      priority: priority,
      due: due,
      estimate: estimate,
      attachments: attachments,
    );
    await _repo.save(task);
    emit(TasksSuccess([task, ...tasks]));
    AppOverlay.showSuccess(LocaleKeys.tasks_toastCreated
        .tr(namedArgs: {'name': Validators.firstName(assignee)}));
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    emit(TasksSuccess(tasks.where((t) => t.id != id).toList()));
    AppOverlay.showSuccess(LocaleKeys.tasks_toastDeleted.tr());
  }
}
