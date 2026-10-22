import 'package:equatable/equatable.dart';

import '../../../../core/utils/json_reader.dart';
import '../../../board/data/models/board_entry.dart';

class PendingRequestsCard extends Equatable {
  const PendingRequestsCard(
      {this.total = 0, this.employee = 0, this.reviewer = 0});

  final int total;
  final int employee;
  final int reviewer;

  @override
  List<Object?> get props => [total, employee, reviewer];
}

class OverdueTasksCard extends Equatable {
  const OverdueTasksCard({required this.count, required this.projects});

  final int count;
  final int projects;

  @override
  List<Object?> get props => [count, projects];
}

class ActivePollCard extends Equatable {
  const ActivePollCard({
    required this.id,
    required this.title,
    required this.yesPct,
    required this.voted,
    required this.total,
    required this.daysLeft,
  });

  final int id;
  final String title;
  final int yesPct;
  final int voted;
  final int total;
  final int daysLeft;

  @override
  List<Object?> get props => [id, title, yesPct, voted, total, daysLeft];
}

class OpenDecisionCard extends Equatable {
  const OpenDecisionCard({
    required this.id,
    required this.title,
    required this.acked,
    required this.total,
    required this.pending,
  });

  final int id;
  final String title;
  final int acked;
  final int total;
  final int pending;

  @override
  List<Object?> get props => [id, title, acked, total, pending];
}

class AdminDashboard extends Equatable {
  const AdminDashboard({
    required this.today,
    required this.pendingRequests,
    this.overdueTasks,
    this.activePoll,
    this.openDecision,
  });

  final BoardSummary today;
  final PendingRequestsCard pendingRequests;
  final OverdueTasksCard? overdueTasks;
  final ActivePollCard? activePoll;
  final OpenDecisionCard? openDecision;

  factory AdminDashboard.fromJson(Map<String, dynamic> json) {
    final needs = JsonReader.map(json['needs_decision']);
    final requests = JsonReader.mapOrNull(needs['pending_requests']);
    final tasks = JsonReader.mapOrNull(needs['overdue_tasks']);
    final poll = JsonReader.mapOrNull(needs['active_poll']);
    final decision = JsonReader.mapOrNull(needs['open_decision']);
    return AdminDashboard(
      today: BoardSummary.fromJson(json['today']),
      pendingRequests: PendingRequestsCard(
        total: JsonReader.toInt(requests?['total']),
        employee: JsonReader.toInt(requests?['employee']),
        reviewer: JsonReader.toInt(requests?['reviewer']),
      ),
      overdueTasks: tasks == null
          ? null
          : OverdueTasksCard(
              count: JsonReader.toInt(tasks['count']),
              projects: JsonReader.toInt(tasks['projects_count']),
            ),
      activePoll: poll == null
          ? null
          : ActivePollCard(
              id: JsonReader.toInt(poll['id']),
              title: JsonReader.string(poll['title']),
              yesPct: JsonReader.toInt(poll['yes_pct']),
              voted: JsonReader.toInt(poll['voted']),
              total: JsonReader.toInt(poll['total']),
              daysLeft: JsonReader.toInt(poll['days_left']),
            ),
      openDecision: decision == null
          ? null
          : OpenDecisionCard(
              id: JsonReader.toInt(decision['id']),
              title: JsonReader.string(decision['title']),
              acked: JsonReader.toInt(decision['acked']),
              total: JsonReader.toInt(decision['total']),
              pending: JsonReader.toInt(decision['pending_count']),
            ),
    );
  }

  @override
  List<Object?> get props =>
      [today, pendingRequests, overdueTasks, activePoll, openDecision];
}

class MonthReview extends Equatable {
  const MonthReview({
    required this.month,
    required this.closed,
    required this.reviewed,
    required this.total,
    required this.pct,
    required this.isLastDay,
    required this.allReviewed,
    required this.noPendingFixes,
  });

  final DateTime month;
  final bool closed;
  final int reviewed;
  final int total;
  final int pct;
  final bool isLastDay;
  final bool allReviewed;
  final bool noPendingFixes;

  factory MonthReview.fromJson(Map<String, dynamic> json) {
    final reviewed = JsonReader.map(json['reviewed']);
    final checklist = JsonReader.map(json['checklist']);
    final month = JsonReader.string(json['month']);
    return MonthReview(
      month: DateTime.tryParse('$month-01') ?? DateTime.now(),
      closed: JsonReader.string(json['status']) == 'closed',
      reviewed: JsonReader.toInt(reviewed['done']),
      total: JsonReader.toInt(reviewed['total']),
      pct: JsonReader.toInt(reviewed['pct']),
      isLastDay: JsonReader.toBool(json['is_last_day_of_month']),
      allReviewed:
          JsonReader.toBool(JsonReader.map(checklist['all_reviewed'])['ok']),
      noPendingFixes: JsonReader.toBool(
          JsonReader.map(checklist['no_pending_fixes'])['ok']),
    );
  }

  @override
  List<Object?> get props => [
        month,
        closed,
        reviewed,
        total,
        pct,
        isLastDay,
        allReviewed,
        noPendingFixes
      ];
}

class ReviewerDashboard extends Equatable {
  const ReviewerDashboard({
    required this.monthReview,
    required this.inReview,
    required this.inTest,
    required this.today,
  });

  final MonthReview monthReview;
  final int inReview;
  final int inTest;
  final BoardSummary today;

  factory ReviewerDashboard.fromJson(Map<String, dynamic> json) {
    final tasks = JsonReader.map(json['tasks']);
    return ReviewerDashboard(
      monthReview: MonthReview.fromJson(JsonReader.map(json['month_review'])),
      inReview: JsonReader.toInt(tasks['review']),
      inTest: JsonReader.toInt(tasks['test']),
      today: BoardSummary.fromJson(json['today']),
    );
  }

  @override
  List<Object?> get props => [monthReview, inReview, inTest, today];
}
