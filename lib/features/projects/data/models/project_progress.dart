import '../../../tasks/data/models/task_model.dart';
import 'project_model.dart';

class ProjectProgress {
  ProjectProgress._();

  static int of(ProjectModel project, List<TaskModel> tasks) {
    if (project.status == ProjectStatus.delivered) return 100;
    final mine = tasks.where((t) => t.projectId == project.id).toList();
    if (mine.isEmpty) return 0;
    return (mine.where((t) => t.isDone).length / mine.length * 100).round();
  }
}
