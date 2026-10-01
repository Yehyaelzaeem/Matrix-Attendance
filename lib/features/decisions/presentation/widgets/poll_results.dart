import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/meter_bar.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../data/models/decision_model.dart';
import 'expandable_section.dart';
import 'progress_stat_line.dart';

class PollResults extends StatelessWidget {
  const PollResults({super.key, required this.decision});

  final DecisionModel decision;

  Widget _row(String label, int pct, Color color) => Padding(
        padding: EdgeInsets.only(top: 9.h),
        child: Row(
          children: [
            SizedBox(
              width: 80.w,
              child: AppText(label,
                  fontSize: 13, fontWeight: FontWeight.w700, maxLines: 1),
            ),
            Expanded(
                child: MeterBar(value: pct / 100, color: color, height: 10)),
            SizedBox(width: 10.w),
            SizedBox(
              width: 38.w,
              child: AppText('$pct%',
                  numeric: true, fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final d = decision;
    final votes = d.votes;
    final yes = votes == 0 ? 0 : (d.yes / votes * 100).round();
    final no = votes == 0 ? 0 : 100 - yes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _row(LocaleKeys.decisions_agree.tr(), yes,
            AppColors.successColor.themeColor),
        _row(LocaleKeys.decisions_disagree.tr(), no,
            AppColors.errorColor.themeColor),
        ProgressStatLine(
          label: LocaleKeys.decisions_votedOf
              .tr(namedArgs: {'a': '$votes', 'b': '${d.total}'}),
          bar: MeterBar(
            value: d.total == 0 ? 0 : votes / d.total,
            color: AppColors.violetColor.themeColor,
          ),
        ),
        if (d.voters.isNotEmpty)
          ExpandableSection(
            title: LocaleKeys.decisions_votersToggle.tr(),
            children: [
              for (final v in d.voters)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: AppColors.dividerColor.themeColor)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppAvatar(name: v.name, size: 32, radius: 10),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 6.w,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                AppText(v.name,
                                    fontSize: 13, fontWeight: FontWeight.w700),
                                StatusChip(
                                  small: true,
                                  label: v.agree
                                      ? LocaleKeys.decisions_agreeShort.tr()
                                      : LocaleKeys.decisions_disagreeShort.tr(),
                                  tone: v.agree ? ChipTone.green : ChipTone.red,
                                ),
                              ],
                            ),
                            if (v.comment.isNotEmpty)
                              AppText(v.comment,
                                  fontSize: 12.5,
                                  color:
                                      AppColors.textSecondaryColor.themeColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
