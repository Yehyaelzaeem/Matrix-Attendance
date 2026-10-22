import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/option_tile.dart';
import '../../../../core/widgets/search_field.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/widgets/custom_loading_widget.dart';
import '../../../catalog/logic/catalog_cubit.dart';
import '../../data/models/job_title.dart';

class JobPickerSheet extends StatefulWidget {
  const JobPickerSheet({super.key, this.selected});

  final String? selected;

  @override
  State<JobPickerSheet> createState() => _JobPickerSheetState();
}

class _JobPickerSheetState extends State<JobPickerSheet> {
  String _query = '';

  static final Map<String, String> _emojis = {
    for (final g in kJobGroups)
      for (final j in g.items) j.title.toLowerCase(): j.emoji,
  };

  static String emojiOf(String title) =>
      _emojis[title.toLowerCase()] ?? AppEmojis.briefcase;

  @override
  void initState() {
    super.initState();
    context.read<CatalogCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final catalog = context.watch<CatalogCubit>().state;
    final groups = [
      for (final c in catalog.categories)
        (
          c.name,
          catalog
              .jobsOf(c.id)
              .where((j) =>
                  q.isEmpty ||
                  j.name.toLowerCase().contains(q) ||
                  c.name.toLowerCase().contains(q))
              .toList(),
        ),
    ].where((g) => g.$2.isNotEmpty).toList();
    return Column(
      children: [
        AppText(LocaleKeys.auth_jobSheetTitle.tr(),
            fontSize: 18, fontWeight: FontWeight.w800),
        SizedBox(height: 14.h),
        SearchField(
          hint: LocaleKeys.auth_jobSearchHint.tr(),
          height: 50,
          onChanged: (v) => setState(() => _query = v),
        ),
        SizedBox(height: 6.h),
        Expanded(
          child: catalog.loading
              ? const Center(child: CustomLoadingWidget())
              : groups.isEmpty
                  ? AppEmpty(
                      message: LocaleKeys.common_noResultsFor
                          .tr(namedArgs: {'q': _query}))
                  : ListView(
                      children: [
                        for (final group in groups) ...[
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                4.w, 14.h, 4.w, 6.h),
                            child: AppText(group.$1,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textSecondaryColor.themeColor),
                          ),
                          for (final job in group.$2)
                            OptionTile(
                              leading: emojiOf(job.name),
                              title: job.name,
                              titleDirection: TextDirection.ltr,
                              selected: job.name == widget.selected,
                              onTap: () => Navigator.of(context).pop(job),
                            ),
                        ],
                      ],
                    ),
        ),
      ],
    );
  }
}
