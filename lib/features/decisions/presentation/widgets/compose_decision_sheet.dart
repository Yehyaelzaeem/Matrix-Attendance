import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_pickers.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/choice_chips.dart';
import '../../../../core/widgets/field_label.dart';
import '../../../../core/widgets/segmented_toggle.dart';
import '../../../../core/widgets/select_field.dart';
import '../../../catalog/logic/catalog_cubit.dart';
import '../../data/models/decision_model.dart';
import '../../logic/decisions_cubit.dart';

class ComposeDecisionSheet extends StatefulWidget {
  const ComposeDecisionSheet({super.key});

  @override
  State<ComposeDecisionSheet> createState() => _ComposeDecisionSheetState();
}

class _ComposeDecisionSheetState extends State<ComposeDecisionSheet> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  DecisionKind _kind = DecisionKind.decision;
  int? _category;
  DateTime _ends = DateHelper.fromToday(3);
  bool _loading = false;

  bool get _valid =>
      _title.text.trim().length > 2 && _body.text.trim().length > 5;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    setState(() => _loading = true);
    final navigator = Navigator.of(context);
    final ok = await context.read<DecisionsCubit>().publish(
          kind: _kind,
          title: _title.text.trim(),
          body: _body.text.trim(),
          audience: _category == null
              ? const DecisionAudience.all()
              : DecisionAudience.groups([_category!]),
          endsAt: _kind == DecisionKind.poll ? _ends : null,
        );
    if (!mounted) return;
    if (ok) {
      navigator.pop();
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(LocaleKeys.decisions_composeTitle.tr(),
            fontSize: 18, fontWeight: FontWeight.w800),
        SizedBox(height: 14.h),
        LabeledField(
          label: LocaleKeys.decisions_type.tr(),
          child: SegmentedToggle<DecisionKind>(
            options: [
              (DecisionKind.info, LocaleKeys.decisions_kindInfoShort.tr()),
              (
                DecisionKind.decision,
                LocaleKeys.decisions_kindDecisionShort.tr()
              ),
              (DecisionKind.poll, LocaleKeys.decisions_kindPollShort.tr()),
            ],
            selected: _kind,
            onChanged: (k) => setState(() => _kind = k),
          ),
        ),
        LabeledField(
          label: LocaleKeys.decisions_postTitle.tr(),
          child: CustomTextField(
            controller: _title,
            hint: LocaleKeys.decisions_postTitleHint.tr(),
            onChanged: (_) => setState(() {}),
          ),
        ),
        LabeledField(
          label: LocaleKeys.decisions_postBody.tr(),
          child: CustomTextField(
            controller: _body,
            hint: LocaleKeys.decisions_postBodyHint.tr(),
            minLines: 3,
            maxLines: 5,
            onChanged: (_) => setState(() {}),
          ),
        ),
        LabeledField(
          label: LocaleKeys.decisions_audience.tr(),
          child: ChoiceChipsPicker<int?>(
            items: [
              ChoiceItem(null, LocaleKeys.decisions_audAll.tr()),
              for (final c in context.watch<CatalogCubit>().state.categories)
                ChoiceItem(c.id, c.name),
            ],
            isSelected: (id) => id == _category,
            onTap: (id) => setState(() => _category = id),
          ),
        ),
        if (_kind == DecisionKind.poll)
          LabeledField(
            label: LocaleKeys.decisions_pollEnds.tr(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SelectField(
                  placeholder: '',
                  value: DateHelper.dayMonth(_ends),
                  icon: Icons.event_outlined,
                  onTap: () async {
                    final picked =
                        await AppPickers.pickDate(context, initial: _ends);
                    if (picked != null) setState(() => _ends = picked);
                  },
                ),
                SizedBox(height: 6.h),
                AppText(LocaleKeys.decisions_pollPrivate.tr(),
                    fontSize: 11.5,
                    color: AppColors.textSecondaryColor.themeColor),
              ],
            ),
          ),
        CustomButton(
          title: LocaleKeys.decisions_publishNotify.tr(),
          enabled: _valid,
          loading: _loading,
          onTap: _publish,
        ),
      ],
    );
  }
}
