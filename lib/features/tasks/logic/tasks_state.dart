part of 'tasks_cubit.dart';

sealed class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object?> get props => [];
}

final class TasksInitial extends TasksState {
  const TasksInitial();
}

final class TasksLoading extends TasksState {
  const TasksLoading();
}

final class TasksSuccess extends TasksState {
  final List<TaskModel> tasks;
  const TasksSuccess(this.tasks);

  TaskModel? byId(String id) {
    for (final t in tasks) {
      if (t.id == id) return t;
    }
    return null;
  }

  @override
  List<Object?> get props => [tasks];
}

final class TasksError extends TasksState {
  final String message;
  const TasksError(this.message);

  @override
  List<Object?> get props => [message];
}
