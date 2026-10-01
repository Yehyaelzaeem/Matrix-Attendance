import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/page_top_bar.dart';
import '../../../core/widgets/search_field.dart';
import '../logic/team_cubit.dart';
import 'widgets/employee_list_card.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final _cubit = getIt<TeamCubit>()..load();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.themeColor,
      body: BlocBuilder<TeamCubit, TeamState>(
        bloc: _cubit,
        builder: (context, _) {
          final q = _query.trim().toLowerCase();
          final list = _cubit.employees
              .where((e) =>
                  q.isEmpty ||
                  e.name.contains(q) ||
                  e.jobTitle.toLowerCase().contains(q))
              .toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PageTopBar(
                title: LocaleKeys.team_employeesTitle.tr(),
                subtitle: LocaleKeys.team_employeesCount
                    .tr(namedArgs: {'n': '${_cubit.employees.length}'}),
                showBack: true,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.w, 0, 20.w, 8.h),
                child: SearchField(
                  hint: LocaleKeys.team_searchHint.tr(),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              Expanded(
                child: list.isEmpty
                    ? AppEmpty(message: LocaleKeys.common_noResults.tr())
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
                        itemCount: list.length,
                        separatorBuilder: (_, __) => SizedBox(height: 10.h),
                        itemBuilder: (_, i) =>
                            EmployeeListCard(employee: list[i], index: i),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
