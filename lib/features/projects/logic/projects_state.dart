part of 'projects_cubit.dart';

sealed class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object?> get props => [];
}

final class ProjectsInitial extends ProjectsState {
  const ProjectsInitial();
}

final class ProjectsLoading extends ProjectsState {
  const ProjectsLoading();
}

final class ProjectsSuccess extends ProjectsState {
  final List<ProjectModel> projects;
  const ProjectsSuccess(this.projects);

  ProjectModel? byId(String id) {
    for (final p in projects) {
      if (p.id == id) return p;
    }
    return null;
  }

  @override
  List<Object?> get props => [projects];
}

final class ProjectsError extends ProjectsState {
  final String message;
  const ProjectsError(this.message);

  @override
  List<Object?> get props => [message];
}
