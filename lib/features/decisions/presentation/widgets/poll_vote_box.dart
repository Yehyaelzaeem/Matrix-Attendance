import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../logic/decisions_cubit.dart';

class PollVoteBox extends StatefulWidget {
  const PollVoteBox({super.key, required this.decisionId});

  final String decisionId;

  @override
  State<PollVoteBox> createState() => _PollVoteBoxState();
}

class _PollVoteBoxState extends State<PollVoteBox> {
  final _comment = TextEditingController();
  bool? _agree;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Widget _option(bool agree) {
    final on = _agree == agree;
    final color = agree
        ? AppColors.successColor.themeColor
        : AppColors.errorColor.themeColor;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _agree = agree),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 48.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: on
                ? (agree
                    ? AppColors.successSoftColor.themeColor
                    : AppColors.errorSoftColor.themeColor)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: on ? color : AppColors.dividerColor.themeColor,
              width: 1.5,
            ),
          ),
          child: AppText(
            agree
                ? LocaleKeys.decisions_agree.tr()
                : LocaleKeys.decisions_disagree.tr(),
            fontWeight: FontWeight.w800,
            color: on ? color : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(children: [_option(true), SizedBox(width: 8.w), _option(false)]),
        SizedBox(height: 10.h),
        CustomTextField(
          controller: _comment,
          hint: LocaleKeys.decisions_commentOptional.tr(),
          minLines: 2,
          maxLines: 3,
        ),
        SizedBox(height: 10.h),
        CustomButton(
          title: LocaleKeys.decisions_sendVote.tr(),
          height: 46,
          fontSize: 14.5,
          enabled: _agree != null,
          onTap: () => getIt<DecisionsCubit>()
              .vote(widget.decisionId, _agree!, _comment.text.trim()),
        ),
      ],
    );
  }
}
