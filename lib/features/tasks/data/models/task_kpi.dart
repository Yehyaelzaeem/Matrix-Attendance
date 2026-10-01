import 'task_model.dart';

class TaskKpi {
  const TaskKpi({
    required this.total,
    required this.done,
    required this.onTime,
    required this.late,
    required this.completion,
    required this.onTimePercent,
    required this.efficiency,
    required this.estimate,
    required this.spent,
    required this.returns,
    required this.score,
  });

  final int total;
  final int done;
  final int onTime;
  final int late;
  final int completion;
  final int onTimePercent;
  final int efficiency;
  final double estimate;
  final double spent;
  final int returns;
  final int? score;

  factory TaskKpi.of(String name, List<TaskModel> tasks) {
    final mine = tasks.where((t) => t.assignee == name).toList();
    final done = mine.where((t) => t.isDone).toList();
    final onTime =
        done.where((t) => t.doneAt != null && !t.doneAt!.isAfter(t.due)).length;
    final late = mine.where((t) => t.isLate).length;
    final estimate = done.fold<double>(0, (a, t) => a + t.estimate);
    final spent = done.fold<double>(0, (a, t) => a + t.spent);
    final completion =
        mine.isEmpty ? 0 : (done.length / mine.length * 100).round();
    final onTimePercent =
        done.isEmpty ? 0 : (onTime / done.length * 100).round();
    final efficiency =
        spent == 0 ? 0 : (estimate / spent * 100).round().clamp(0, 100);
    final returns = mine.fold<int>(0, (a, t) => a + t.returns);
    final score = mine.isEmpty
        ? null
        : (0.4 * completion +
                0.4 * onTimePercent +
                0.2 * efficiency -
                late * 5 -
                returns * 3)
            .round()
            .clamp(0, 100);
    return TaskKpi(
      total: mine.length,
      done: done.length,
      onTime: onTime,
      late: late,
      completion: completion,
      onTimePercent: onTimePercent,
      efficiency: efficiency,
      estimate: double.parse(estimate.toStringAsFixed(1)),
      spent: double.parse(spent.toStringAsFixed(1)),
      returns: returns,
      score: score,
    );
  }
}
