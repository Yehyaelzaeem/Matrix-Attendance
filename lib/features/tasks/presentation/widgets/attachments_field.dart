import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/utils/media_picker.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/field_label.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../data/models/task_enums.dart';
import '../../data/models/task_model.dart';
import 'attachment_tile.dart';
import 'attachment_viewer.dart';

class AttachmentsField extends StatelessWidget {
  const AttachmentsField({
    super.key,
    required this.attachments,
    required this.onAdd,
    required this.onRemove,
    this.optional = false,
    this.hint,
  });

  final List<TaskAttachment> attachments;
  final ValueChanged<List<TaskAttachment>> onAdd;
  final ValueChanged<int> onRemove;
  final bool optional;
  final String? hint;

  Future<void> _pick() async {
    final result = await MediaPicker.pickMedia();
    final files = [
      for (final f in result.files)
        TaskAttachment(
          name: f.name,
          path: f.path,
          type: f.isVideo ? AttachmentType.video : AttachmentType.image,
        ),
    ];
    if (files.isNotEmpty) onAdd(files);
    if (result.skippedTooLarge > 0) {
      AppOverlay.showError(LocaleKeys.common_mediaTooBig.tr());
    } else if (files.isNotEmpty) {
      AppOverlay.showSuccess(LocaleKeys.common_mediaAdded.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return LabeledField(
      label: LocaleKeys.common_attachments.tr(),
      hint: hint,
      badge: optional
          ? StatusChip(small: true, label: LocaleKeys.common_optional.tr())
          : attachments.isEmpty
              ? null
              : StatusChip(
                  small: true, label: '${attachments.length}', numeric: true),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.w,
        children: [
          for (var i = 0; i < attachments.length; i++)
            AttachmentTile(
              attachment: attachments[i],
              onTap: () => AttachmentViewer.open(context, attachments[i]),
              onRemove: () => onRemove(i),
            ),
          GestureDetector(
            onTap: _pick,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceColor.themeColor,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                    color: AppColors.dashedBorderColor.themeColor, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(AppEmojis.plus,
                      fontSize: 20, color: AppColors.primaryColor.themeColor),
                  AppText(LocaleKeys.common_addMedia.tr(),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      color: AppColors.primaryColor.themeColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
