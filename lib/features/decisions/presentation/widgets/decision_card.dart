import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/info_box.dart';
import '../../data/models/decision_model.dart';
import '../../logic/decisions_cubit.dart';
import 'decision_card_frame.dart';
import 'poll_vote_box.dart';

class DecisionCard extends StatelessWidget {
  const DecisionCard({super.key, required this.decision, this.index = 0});

  final DecisionModel decision;
  final int index;

  @override
  Widget build(BuildContext context) {
    final Widget? action = switch (decision.kind) {
      DecisionKind.decision => decision.acked
          ? InfoBox(
              text: LocaleKeys.decisions_acked.tr(), tone: InfoTone.success)
          : CustomButton(
              title: LocaleKeys.decisions_ack.tr(),
              height: 46,
              fontSize: 14.5,
              onTap: () =>
                  context.read<DecisionsCubit>().acknowledge(decision.id),
            ),
      DecisionKind.poll => decision.vote != null
          ? InfoBox(
              text: LocaleKeys.decisions_votedNote.tr(namedArgs: {
                'vote': decision.vote!
                    ? LocaleKeys.decisions_agreeShort.tr()
                    : LocaleKeys.decisions_disagreeShort.tr(),
              }),
            )
          : PollVoteBox(decisionId: decision.id),
      DecisionKind.info => null,
    };
    return FadeSlideIn(
      delay: Duration(milliseconds: index * 60),
      child: DecisionCardFrame(
        decision: decision,
        footerStart: decision.by,
        children: [
          if (action != null) ...[SizedBox(height: 12.h), action],
        ],
      ),
    );
  }
}
