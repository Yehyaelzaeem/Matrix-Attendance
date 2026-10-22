import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../admin/logic/approvals_cubit.dart';
import '../../logic/app_tab.dart';
import 'nav_item.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.tabs,
    required this.current,
    required this.onSelect,
  });

  final List<AppTab> tabs;
  final AppTab current;
  final ValueChanged<AppTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        border:
            Border(top: BorderSide(color: AppColors.dividerColor.themeColor)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64.h,
          child: Row(
            children: [
              for (final tab in tabs)
                Expanded(
                  child: tab == AppTab.approvals
                      ? BlocBuilder<ApprovalsCubit, ApprovalsState>(
                          builder: (_, state) => NavItem(
                            tab: tab,
                            selected: tab == current,
                            badge: state is ApprovalsSuccess
                                ? state.pendingCount
                                : 0,
                            onTap: () => onSelect(tab),
                          ),
                        )
                      : NavItem(
                          tab: tab,
                          selected: tab == current,
                          onTap: () => onSelect(tab),
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
