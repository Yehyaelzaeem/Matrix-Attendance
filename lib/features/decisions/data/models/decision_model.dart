import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/utils/app_emojis.dart';
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

  String get shortLabel => switch (this) {
        DecisionKind.info => LocaleKeys.decisions_kindInfoShort.tr(),
        DecisionKind.decision => LocaleKeys.decisions_kindDecisionShort.tr(),
        DecisionKind.poll => LocaleKeys.decisions_kindPollShort.tr(),
      };
}

enum DecisionAudience {
  all,
  developers,
  testers,
  managers,
  injox;

  String get label => switch (this) {
        DecisionAudience.all => LocaleKeys.decisions_audAll.tr(),
        DecisionAudience.developers => LocaleKeys.decisions_audDevs.tr(),
        DecisionAudience.testers => LocaleKeys.decisions_audTesters.tr(),
        DecisionAudience.managers => LocaleKeys.decisions_audPms.tr(),
        DecisionAudience.injox => LocaleKeys.decisions_audInjox.tr(),
      };

  String get sentTo => this == DecisionAudience.all
      ? LocaleKeys.decisions_toAll.tr()
      : LocaleKeys.decisions_toAudience.tr(namedArgs: {'name': label});
}

class PollVoter extends Equatable {
  const PollVoter(this.name, this.agree, [this.comment = '']);

  final String name;
  final bool agree;
  final String comment;

  @override
  List<Object?> get props => [name, agree, comment];
}

class DecisionModel extends Equatable {
  const DecisionModel({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.when,
    required this.by,
    required this.audience,
    this.deadline,
    this.acked = false,
    this.vote,
    this.doneCount = 0,
    this.total = 20,
    this.pendingNames = const [],
    this.yes = 0,
    this.no = 0,
    this.voters = const [],
  });

  final String id;
  final DecisionKind kind;
  final String title;
  final String body;
  final String when;
  final String by;
  final DecisionAudience audience;
  final String? deadline;
  final bool acked;
  final bool? vote;
  final int doneCount;
  final int total;
  final List<String> pendingNames;
  final int yes;
  final int no;
  final List<PollVoter> voters;

  bool get needsAction =>
      (kind == DecisionKind.decision && !acked) ||
      (kind == DecisionKind.poll && vote == null);

  int get votes => yes + no;

  DecisionModel copyWith({
    bool? acked,
    bool? vote,
    int? doneCount,
    int? yes,
    int? no,
    List<String>? pendingNames,
  }) =>
      DecisionModel(
        id: id,
        kind: kind,
        title: title,
        body: body,
        when: when,
        by: by,
        audience: audience,
        deadline: deadline,
        acked: acked ?? this.acked,
        vote: vote ?? this.vote,
        doneCount: doneCount ?? this.doneCount,
        total: total,
        pendingNames: pendingNames ?? this.pendingNames,
        yes: yes ?? this.yes,
        no: no ?? this.no,
        voters: voters,
      );

  @override
  List<Object?> get props => [
        id,
        kind,
        title,
        body,
        when,
        by,
        audience,
        deadline,
        acked,
        vote,
        doneCount,
        total,
        pendingNames,
        yes,
        no,
        voters,
      ];
}
