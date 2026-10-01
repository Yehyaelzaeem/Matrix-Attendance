import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/locale_keys.dart';
import '../../auth/data/models/user_role.dart';

enum AppTab {
  home(Icons.home_outlined),
  board(Icons.groups_outlined),
  myWork(Icons.work_outline_rounded),
  requests(Icons.description_outlined),
  profile(Icons.person_outline_rounded),
  reviewerHome(Icons.home_outlined),
  reviewTasks(Icons.fact_check_outlined),
  reports(Icons.bar_chart_rounded),
  adminHome(Icons.home_outlined),
  approvals(Icons.fact_check_outlined),
  adminDecisions(Icons.campaign_outlined),
  more(Icons.grid_view_rounded);

  const AppTab(this.icon);

  final IconData icon;

  String get label => switch (this) {
        AppTab.home ||
        AppTab.reviewerHome ||
        AppTab.adminHome =>
          LocaleKeys.nav_home.tr(),
        AppTab.board => LocaleKeys.nav_board.tr(),
        AppTab.myWork => LocaleKeys.nav_myWork.tr(),
        AppTab.requests => LocaleKeys.nav_requests.tr(),
        AppTab.profile => LocaleKeys.nav_profile.tr(),
        AppTab.reviewTasks => LocaleKeys.nav_review.tr(),
        AppTab.reports => LocaleKeys.nav_reports.tr(),
        AppTab.approvals => LocaleKeys.nav_approvals.tr(),
        AppTab.adminDecisions => LocaleKeys.nav_decisions.tr(),
        AppTab.more => LocaleKeys.nav_more.tr(),
      };

  static List<AppTab> forRole(UserRole role) => switch (role) {
        UserRole.employee => const [
            AppTab.home,
            AppTab.board,
            AppTab.myWork,
            AppTab.requests,
            AppTab.profile,
          ],
        UserRole.reviewer => const [
            AppTab.reviewerHome,
            AppTab.reviewTasks,
            AppTab.board,
            AppTab.reports,
            AppTab.profile,
          ],
        UserRole.admin => const [
            AppTab.adminHome,
            AppTab.approvals,
            AppTab.board,
            AppTab.adminDecisions,
            AppTab.more,
          ],
      };
}
