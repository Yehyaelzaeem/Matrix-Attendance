import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/models/enum_value.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/json_reader.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/status_chip.dart';

enum DecisionKind {
  info(ChipTone.blue, AppEmojis.megaphone),
  decision(ChipTone.orange, AppEmojis.pin),
  poll(ChipTone.violet, AppEmojis.ballot);

  const DecisionKind(this.tone, this.emoji);

  final ChipTone tone;
  final String emoji;

  String get label => switch (this) {
        DecisionKind.info => LocaleKeys.decisions_kindInfo.tr(),
        DecisionKind.decision => LocaleKeys.decisions_kindDecision.tr(),
        DecisionKind.poll => LocaleKeys.decisions_kindPoll.tr(),
      };

  static DecisionKind fromKey(String? key) => DecisionKind.values
      .firstWhere((e) => e.name == key, orElse: () => DecisionKind.info);

  String get shortLabel => switch (this) {
        DecisionKind.info => LocaleKeys.decisions_kindInfoShort.tr(),
        DecisionKind.decision => LocaleKeys.decisions_kindDecisionShort.tr(),
        DecisionKind.poll => LocaleKeys.decisions_kindPollShort.tr(),
      };
}

class DecisionAudience extends Equatable {
  const DecisionAudience.all()
      : isAll = true,
        ids = const [];

  const DecisionAudience.groups(this.ids) : isAll = false;

  final bool isAll;
  final List<int> ids;

  factory DecisionAudience.fromJson(dynamic json) {
    final map = JsonReader.map(json);
    if (JsonReader.string(map['type'], 'all') == 'all') {
      return const DecisionAudience.all();
    }
    return DecisionAudience.groups([
      for (final id in (map['ids'] as List? ?? const [])) JsonReader.toInt(id),
    ]);
  }

  Map<String, dynamic> toJson() =>
      isAll ? {'type': 'all'} : {'type': 'job_groups', 'ids': ids};

  String label(String Function(int id) categoryName) => isAll
      ? LocaleKeys.decisions_audAll.tr()
      : ids.map(categoryName).where((n) => n.isNotEmpty).join('، ');

  String sentTo(String Function(int id) categoryName) => isAll
      ? LocaleKeys.decisions_toAll.tr()
      : LocaleKeys.decisions_toAudience
          .tr(namedArgs: {'name': label(categoryName)});

  @override
  List<Object?> get props => [isAll, ids];
}

class PollVoter extends Equatable {
  const PollVoter(this.name, this.agree, [this.comment = '', this.image]);

  final String name;
  final bool agree;
  final String comment;
  final String? image;

  factory PollVoter.fromJson(Map<String, dynamic> json) {
    final user = JsonReader.map(json['user']);
    return PollVoter(
      JsonReader.string(user['name']),
      EnumValue.keyOf(json['vote']) == 'yes',
      JsonReader.string(json['comment']),
      JsonReader.stringOrNull(user['image']),
    );
  }

  @override
  List<Object?> get props => [name, agree, comment, image];
}

class DecisionModel extends Equatable {
  const DecisionModel({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.publishedAt,
    required this.by,
    required this.audience,
    this.endsAt,
    this.isPinned = false,
    this.acked = false,
    this.vote,
    this.doneCount = 0,
    this.total = 0,
    this.pendingNames = const [],
    this.yesPct = 0,
    this.noPct = 0,
    this.voted = 0,
    this.voters = const [],
  });

  final int id;
  final DecisionKind kind;
  final String title;
  final String body;
  final DateTime publishedAt;
  final String by;
  final DecisionAudience audience;
  final DateTime? endsAt;
  final bool isPinned;
  final bool acked;
  final bool? vote;
  final int doneCount;
  final int total;
  final List<String> pendingNames;
  final int yesPct;
  final int noPct;
  final int voted;
  final List<PollVoter> voters;

  String get when => DateHelper.relative(publishedAt);

  bool get isEnded => endsAt != null && endsAt!.isBefore(DateTime.now());

  String? get deadline {
    final ends = endsAt;
    if (ends == null) return null;
    if (isEnded) return LocaleKeys.decisions_ended.tr();
    final days =
        DateHelper.dateOnly(ends).difference(DateHelper.today()).inDays;
    return days <= 0
        ? LocaleKeys.decisions_endsToday.tr()
        : LocaleKeys.decisions_daysLeft.tr(namedArgs: {'n': '$days'});
  }

  bool get needsAction =>
      (kind != DecisionKind.poll && !acked) ||
      (kind == DecisionKind.poll && vote == null && !isEnded);

  int get votes => voted;

  factory DecisionModel.fromJson(Map<String, dynamic> json) {
    final myVote = JsonReader.mapOrNull(json['my_vote']);
    final poll = JsonReader.mapOrNull(json['poll']);
    final stats = JsonReader.mapOrNull(json['stats']);
    return DecisionModel(
      id: JsonReader.toInt(json['id']),
      kind: DecisionKind.fromKey(EnumValue.keyOf(json['kind'])),
      title: JsonReader.string(json['title']),
      body: JsonReader.string(json['body']),
      publishedAt: JsonReader.dateTime(json['published_at']) ??
          JsonReader.dateTime(json['created_at']) ??
          DateTime.now(),
      by: JsonReader.string(JsonReader.map(json['created_by'])['name']),
      audience: DecisionAudience.fromJson(json['audience']),
      endsAt: JsonReader.dateTime(json['ends_at']),
      isPinned: JsonReader.toBool(json['is_pinned']),
      acked: json['my_ack'] != null,
      vote: myVote == null ? null : EnumValue.keyOf(myVote['vote']) == 'yes',
      doneCount: JsonReader.toInt(stats?['responded']),
      total: JsonReader.toInt(stats?['total'] ?? poll?['total']),
      pendingNames: [
        for (final u in JsonReader.list(json['pending_users']))
          JsonReader.string(u['name']),
      ],
      yesPct: JsonReader.toInt(poll?['yes_pct']),
      noPct: JsonReader.toInt(poll?['no_pct']),
      voted: JsonReader.toInt(poll?['voted']),
    );
  }

  DecisionModel merge(Map<String, dynamic> json) {
    final myVote = JsonReader.mapOrNull(json['my_vote']);
    final poll = JsonReader.mapOrNull(json['poll']);
    final stats = JsonReader.mapOrNull(json['stats']);
    return copyWith(
      acked: json.containsKey('my_ack') ? json['my_ack'] != null : null,
      vote: myVote == null ? null : EnumValue.keyOf(myVote['vote']) == 'yes',
      doneCount: stats == null ? null : JsonReader.toInt(stats['responded']),
      total: stats == null && poll == null
          ? null
          : JsonReader.toInt(stats?['total'] ?? poll?['total']),
      yesPct: poll == null ? null : JsonReader.toInt(poll['yes_pct']),
      noPct: poll == null ? null : JsonReader.toInt(poll['no_pct']),
      voted: poll == null ? null : JsonReader.toInt(poll['voted']),
    );
  }

  DecisionModel copyWith({
    bool? acked,
    bool? vote,
    int? doneCount,
    int? total,
    int? yesPct,
    int? noPct,
    int? voted,
    List<String>? pendingNames,
    List<PollVoter>? voters,
  }) =>
      DecisionModel(
        id: id,
        kind: kind,
        title: title,
        body: body,
        publishedAt: publishedAt,
        by: by,
        audience: audience,
        endsAt: endsAt,
        isPinned: isPinned,
        acked: acked ?? this.acked,
        vote: vote ?? this.vote,
        doneCount: doneCount ?? this.doneCount,
        total: total ?? this.total,
        pendingNames: pendingNames ?? this.pendingNames,
        yesPct: yesPct ?? this.yesPct,
        noPct: noPct ?? this.noPct,
        voted: voted ?? this.voted,
        voters: voters ?? this.voters,
      );

  @override
  List<Object?> get props => [
        id,
        kind,
        title,
        body,
        publishedAt,
        by,
        audience,
        endsAt,
        isPinned,
        acked,
        vote,
        doneCount,
        total,
        pendingNames,
        yesPct,
        noPct,
        voted,
        voters,
      ];
}
