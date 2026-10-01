import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../logic/decisions_cubit.dart';
import 'widgets/decision_card.dart';

class DecisionsScreen extends StatelessWidget {
  const DecisionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = getIt<DecisionsCubit>()..load();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageTopBar(
            title: LocaleKeys.decisions_title.tr(),
            subtitle: LocaleKeys.decisions_subtitle.tr(),
            showBack: true,
          ),
          Expanded(
            child: BlocBuilder<DecisionsCubit, DecisionsState>(
              bloc: cubit,
              builder: (context, state) => CustomScreenStateLayout(
                isLoading: state is! DecisionsSuccess,
                builder: (_) {
                  final items = (state as DecisionsSuccess).decisions;
                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 30.h),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (_, i) =>
                        DecisionCard(decision: items[i], index: i),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
