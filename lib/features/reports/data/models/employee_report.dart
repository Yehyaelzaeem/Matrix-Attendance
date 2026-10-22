import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/json_reader.dart';
import '../../../../core/utils/locale_keys.dart';

enum ReportMode {
  attendance('att'),
  kpi('kpi'),
  overall('all');

  const ReportMode(this.key);

  final String key;
}

extension ReportModeLabel on ReportMode {
  String get tab => switch (this) {
        ReportMode.attendance => LocaleKeys.reports_modeAttendance.tr(),
        ReportMode.kpi => LocaleKeys.reports_modeKpi.tr(),
        ReportMode.overall => LocaleKeys.reports_modeOverall.tr(),
      };

  String get unit => switch (this) {
        ReportMode.attendance => LocaleKeys.reports_unitAttendance.tr(),
        ReportMode.kpi => LocaleKeys.reports_unitKpi.tr(),
        ReportMode.overall => LocaleKeys.reports_unitOverall.tr(),
      };
}

class ReportPerson extends Equatable {
  const ReportPerson({
    required this.rank,
    required this.userId,
    required this.name,
    required this.job,
    required this.score,
    required this.line,
    required this.reviewed,
    this.image,
  });

  final int rank;
  final int userId;
  final String name;
  final String job;
  final String? image;
  final int? score;
  final Map<String, dynamic> line;
  final bool reviewed;

  factory ReportPerson.fromJson(Map<String, dynamic> json) {
    final user = JsonReader.map(json['user']);
    return ReportPerson(
      rank: JsonReader.toInt(json['rank']),
      userId: JsonReader.toInt(user['id']),
      name: JsonReader.string(user['name']),
      job: JsonReader.string(user['job']),
      image: JsonReader.stringOrNull(user['image']),
      score: JsonReader.intOrNull(json['score']),
      line: JsonReader.map(json['line']),
      reviewed: JsonReader.toBool(json['reviewed']),
    );
  }

  int lineInt(String key) => JsonReader.toInt(line[key]);

  int? lineIntOrNull(String key) => JsonReader.intOrNull(line[key]);

  ReportPerson withReviewed(bool value) => ReportPerson(
        rank: rank,
        userId: userId,
        name: name,
        job: job,
        image: image,
        score: score,
        line: line,
        reviewed: value,
      );

  @override
  List<Object?> get props =>
      [rank, userId, name, job, image, score, line, reviewed];
}

class ReportBoard extends Equatable {
  const ReportBoard({
    required this.month,
    required this.closed,
    required this.mode,
    required this.reviewedDone,
    required this.reviewedTotal,
    required this.summary,
    required this.people,
  });

  final String month;
  final bool closed;
  final ReportMode mode;
  final int reviewedDone;
  final int reviewedTotal;
  final Map<String, dynamic> summary;
  final List<ReportPerson> people;

  bool get allReviewed => reviewedTotal > 0 && reviewedDone >= reviewedTotal;

  int summaryInt(String key) => JsonReader.toInt(summary[key]);

  int? summaryIntOrNull(String key) => JsonReader.intOrNull(summary[key]);

  factory ReportBoard.fromJson(Map<String, dynamic> json, ReportMode mode) {
    final reviewed = JsonReader.map(json['reviewed']);
    return ReportBoard(
      month: JsonReader.string(json['month']),
      closed: JsonReader.string(json['status']) == 'closed',
      mode: mode,
      reviewedDone: JsonReader.toInt(reviewed['done']),
      reviewedTotal: JsonReader.toInt(reviewed['total']),
      summary: JsonReader.map(json['summary']),
      people:
          JsonReader.list(json['people']).map(ReportPerson.fromJson).toList(),
    );
  }

  ReportBoard copyWith(
          {List<ReportPerson>? people, int? reviewedDone, bool? closed}) =>
      ReportBoard(
        month: month,
        closed: closed ?? this.closed,
        mode: mode,
        reviewedDone: reviewedDone ?? this.reviewedDone,
        reviewedTotal: reviewedTotal,
        summary: summary,
        people: people ?? this.people,
      );

  @override
  List<Object?> get props =>
      [month, closed, mode, reviewedDone, reviewedTotal, summary, people];
}

class EmployeeReportDetail extends Equatable {
  const EmployeeReportDetail({
    required this.month,
    required this.closed,
    required this.reviewed,
    required this.userId,
    required this.name,
    required this.job,
    required this.attendanceScore,
    required this.kpiScore,
    required this.overall,
    required this.present,
    required this.required,
    required this.totalWorked,
    required this.lateCount,
    required this.lateMinutes,
    required this.lateAfterGrace,
    required this.deficitDays,
    required this.deficitMinutes,
    required this.violations,
    required this.absences,
    required this.pauses,
    required this.pauseMinutes,
    required this.leaves,
    required this.tasksTotal,
    required this.tasksDone,
    required this.completion,
    required this.onTime,
    required this.onTimePct,
    required this.efficiency,
    required this.returns,
    required this.openLate,
    required this.projects,
    this.image,
  });

  final String month;
  final bool closed;
  final bool reviewed;
  final int userId;
  final String name;
  final String job;
  final String? image;
  final int attendanceScore;
  final int? kpiScore;
  final int overall;
  final int present;
  final int required;
  final String totalWorked;
  final int lateCount;
  final int lateMinutes;
  final int lateAfterGrace;
  final int deficitDays;
  final int deficitMinutes;
  final int violations;
  final int absences;
  final int pauses;
  final int pauseMinutes;
  final int leaves;
  final int tasksTotal;
  final int tasksDone;
  final int completion;
  final int? onTime;
  final int? onTimePct;
  final int? efficiency;
  final int returns;
  final int openLate;
  final List<String> projects;

  factory EmployeeReportDetail.fromJson(Map<String, dynamic> json) {
    final user = JsonReader.map(json['user']);
    final scores = JsonReader.map(json['scores']);
    final att = JsonReader.map(json['attendance']);
    final days = JsonReader.map(att['attendance_days']);
    final lateness = JsonReader.map(att['lateness']);
    final deficit = JsonReader.map(att['deficit']);
    final pauses = JsonReader.map(att['pauses']);
    final tasks = JsonReader.map(json['tasks']);
    return EmployeeReportDetail(
      month: JsonReader.string(json['month']),
      closed: JsonReader.string(json['month_status']) == 'closed',
      reviewed: JsonReader.toBool(json['reviewed']),
      userId: JsonReader.toInt(user['id']),
      name: JsonReader.string(user['name']),
      job: JsonReader.string(user['job']),
      image: JsonReader.stringOrNull(user['image']),
      attendanceScore: JsonReader.toInt(scores['attendance']),
      kpiScore: JsonReader.intOrNull(scores['tasks_kpi']),
      overall: JsonReader.toInt(scores['overall_rating']),
      present: JsonReader.toInt(days['present']),
      required: JsonReader.toInt(days['required']),
      totalWorked: JsonReader.string(att['total_worked'], '0:00:00'),
      lateCount: JsonReader.toInt(lateness['count']),
      lateMinutes: JsonReader.toInt(lateness['total_minutes']),
      lateAfterGrace: JsonReader.toInt(att['late_after_1030']),
      deficitDays: JsonReader.toInt(deficit['days']),
      deficitMinutes: JsonReader.intOrNull(deficit['total_minutes']) ??
          JsonReader.toInt(deficit['total_seconds']) ~/ 60,
      violations: JsonReader.toInt(JsonReader.map(att['violations'])['count']),
      absences: JsonReader.toInt(att['unexcused_absences']),
      pauses: JsonReader.toInt(pauses['count']),
      pauseMinutes: JsonReader.toInt(pauses['total_minutes']),
      leaves: JsonReader.toInt(att['leaves_and_permissions']),
      tasksTotal: JsonReader.toInt(tasks['total']),
      tasksDone: JsonReader.toInt(tasks['done']),
      completion: JsonReader.toInt(tasks['completion_pct']),
      onTime: JsonReader.intOrNull(tasks['on_time']),
      onTimePct: JsonReader.intOrNull(tasks['on_time_pct']),
      efficiency: JsonReader.intOrNull(tasks['efficiency']),
      returns: JsonReader.toInt(tasks['returns_total']),
      openLate: JsonReader.toInt(tasks['open_late']),
      projects: [
        for (final p in (tasks['projects'] as List? ?? const []))
          p is Map ? JsonReader.string(p['name']) : p.toString(),
      ],
    );
  }

  @override
  List<Object?> get props =>
      [month, userId, reviewed, attendanceScore, kpiScore];
}
