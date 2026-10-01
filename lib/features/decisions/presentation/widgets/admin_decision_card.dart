import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/meter_bar.dart';
import '../../../requests/presentation/widgets/reason_box.dart';
import '../../data/models/decision_model.dart';
import '../../logic/decisions_cubit.dart';
import 'decision_card_frame.dart';
import 'poll_results.dart';
import 'progress_stat_line.dart';

class AdminDecisionCard extends StatelessWidget {
  const AdminDecisionCard({super.key, required this.decision, this.index = 0});

  final DecisionModel decision;
  final int index;

  @override
  Widget build(BuildContext context) {
    final d = decision;
    final children = <Widget>[];
    if (d.kind == DecisionKind.poll) {
      children.add(PollResults(decision: d));
    } else {
      children.add(ProgressStatLine(
        label: (d.kind == DecisionKind.decision
                ? LocaleKeys.decisions_ackedOf
                : LocaleKeys.decisions_seenOf)
            .tr(namedArgs: {'a': '${d.doneCount}', 'b': '${d.total}'}),
        bar: MeterBar(
          value: d.total == 0 ? 0 : d.doneCount / d.total,
          color: d.kind == DecisionKind.decision
              ? AppColors.orangeColor.themeColor
              : AppColors.primaryColor.themeColor,
        ),
      ));
      if (d.kind == DecisionKind.decision && d.pendingNames.isNotEmpty) {
        children.addAll([
          ReasonBox(
            label: LocaleKeys.decisions_notAcked.tr(),
            text: d.pendingNames.join('، '),
          ),
          SizedBox(height: 10.h),
          CustomButton(
            title: LocaleKeys.decisions_remind.tr(),
            type: ButtonStyleType.ghost,
            height: 42,
            fontSize: 13.5,
            onTap: () => getIt<DecisionsCubit>().remind(d),
          ),
        ]);
      }
    }
    return FadeSlideIn(
      delay: Duration(milliseconds: index * 60),
      child: DecisionCardFrame(
        decision: d,
        showAudience: true,
        footerStart: d.audience.sentTo,
        children: children,
      ),
    );
  }
}
