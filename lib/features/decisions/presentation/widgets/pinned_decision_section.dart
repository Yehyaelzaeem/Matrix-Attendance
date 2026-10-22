import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/section_title.dart';
import '../../data/models/decision_model.dart';
import '../../logic/decisions_cubit.dart';

class PinnedDecisionSection extends StatelessWidget {
  const PinnedDecisionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DecisionsCubit>();
    return BlocBuilder<DecisionsCubit, DecisionsState>(
      builder: (context, state) {
        if (state is! DecisionsSuccess) return const SizedBox.shrink();
        final pinned = state.pinned;
        final hasAcked = pinned == null &&
            state.decisions
                .any((d) => d.kind == DecisionKind.decision && d.acked);
        if (pinned == null && !hasAcked) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionTitle(
              title: LocaleKeys.decisions_pinnedTitle.tr(),
              actionLabel: LocaleKeys.decisions_allDecisions.tr(),
              onAction: () => context.pushNamed(Routes.decisionsScreen),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: pinned == null
                  ? Container(
                      key: const ValueKey('acked'),
                      margin: EdgeInsets.symmetric(horizontal: 18.w),
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.successSoftColor.themeColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          Text(AppEmojis.checkBox,
                              style: TextStyle(fontSize: 22.sp)),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: AppText(
                                LocaleKeys.decisions_ackDoneCard.tr(),
                                fontWeight: FontWeight.w700,
                                color: AppColors.successTextColor.themeColor),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      key: ValueKey(pinned.id),
                      margin: EdgeInsets.symmetric(horizontal: 18.w),
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        gradient: AppColors.pinnedGradient,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                            color: AppColors.warningBorderColor.themeColor,
                            width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.push_pin_rounded,
                                  size: 14.sp,
                                  color: AppColors.warningTextColor.themeColor),
                              SizedBox(width: 6.w),
                              AppText(LocaleKeys.decisions_needsAck.tr(),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.warningTextColor.themeColor),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          AppText(pinned.title,
                              fontSize: 15.5, fontWeight: FontWeight.w700),
                          SizedBox(height: 4.h),
                          AppText(pinned.body,
                              fontSize: 13,
                              height: 1.8,
                              color: AppColors.warningTextColor.themeColor),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  title: LocaleKeys.decisions_ack.tr(),
                                  height: 42,
                                  radius: 12,
                                  fontSize: 14,
                                  onTap: () => cubit.acknowledge(pinned.id),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: CustomButton(
                                  title: LocaleKeys.common_details.tr(),
                                  height: 42,
                                  radius: 12,
                                  fontSize: 14,
                                  type: ButtonStyleType.white,
                                  borderColor:
                                      AppColors.warningBorderColor.themeColor,
                                  textColor:
                                      AppColors.warningTextColor.themeColor,
                                  onTap: () =>
                                      context.pushNamed(Routes.decisionsScreen),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
