import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/utils/media_picker.dart';
import '../../../../core/utils/number_helper.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/info_block.dart';
import '../../../../core/widgets/key_value_row.dart';
import '../../data/models/project_model.dart';
import '../../logic/projects_cubit.dart';
import 'contract_file_tile.dart';
import 'edit_client_sheet.dart';

class ProjectClientTab extends StatelessWidget {
  const ProjectClientTab({super.key, required this.project});

  final ProjectModel project;

  Future<void> _upload(ProjectsCubit cubit) async {
    final result = await MediaPicker.pickMedia();
    if (result.files.isEmpty) return;
    await cubit.uploadContract(project.id, result.files.first.path);
  }

  @override
  Widget build(BuildContext context) {
    final c = project.client;
    final k = project.contract;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InfoBlock(
          title: LocaleKeys.projects_clientInfo.tr(),
          trailing: GestureDetector(
            onTap: () => AppSheet.show(context,
                child: EditClientSheet(project: project)),
            child: AppText(LocaleKeys.common_edit.tr(),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor.themeColor),
          ),
          child: Column(
            children: [
              KeyValueRow(
                  label: LocaleKeys.projects_clientName.tr(), value: c.name),
              KeyValueRow(
                  label: LocaleKeys.projects_clientCompany.tr(),
                  value: c.company),
              KeyValueRow(
                  label: LocaleKeys.projects_clientPhone.tr(),
                  value: c.phone,
                  numeric: true),
              KeyValueRow(
                  label: LocaleKeys.projects_clientEmail.tr(),
                  value: c.email,
                  numeric: true),
              KeyValueRow(
                  label: LocaleKeys.projects_clientCity.tr(),
                  value: c.city,
                  showDivider: false),
            ],
          ),
        ),
        InfoBlock(
          title: LocaleKeys.projects_contract.tr(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KeyValueRow(
                  label: LocaleKeys.projects_contractNo.tr(),
                  value: k.number,
                  numeric: true),
              KeyValueRow(
                  label: LocaleKeys.projects_contractSigned.tr(),
                  value: DateHelper.dayMonthOrNotYet(k.signedAt)),
              KeyValueRow(
                  label: LocaleKeys.projects_contractDuration.tr(),
                  value: LocaleKeys.projects_monthsCount
                      .tr(namedArgs: {'n': '${k.months}'})),
              KeyValueRow(
                label: LocaleKeys.projects_contractValue.tr(),
                value: NumberHelper.money(project.value, project.currency),
                showDivider: k.notes.isNotEmpty,
              ),
              if (k.notes.isNotEmpty)
                KeyValueRow(
                    label: LocaleKeys.projects_notes.tr(),
                    value: k.notes,
                    showDivider: false),
              SizedBox(height: 12.h),
              ContractFileTile(
                  fileName: k.fileName,
                  onTap: () => _upload(context.read<ProjectsCubit>())),
            ],
          ),
        ),
      ],
    );
  }
}
