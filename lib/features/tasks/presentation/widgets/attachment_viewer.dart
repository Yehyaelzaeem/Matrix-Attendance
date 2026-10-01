import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../core/utils/app_emojis.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/task_enums.dart';
import '../../data/models/task_model.dart';

class AttachmentViewer extends StatelessWidget {
  const AttachmentViewer({super.key, required this.attachment});

  final TaskAttachment attachment;

  static void open(BuildContext context, TaskAttachment attachment) {
    if (attachment.type != AttachmentType.image || attachment.path == null) {
      AppOverlay.showSuccess('${AppEmojis.document} ${attachment.name}');
      return;
    }
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.94),
      builder: (_) => AttachmentViewer(attachment: attachment),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PhotoView(
                    imageProvider: FileImage(File(attachment.path!)),
                    backgroundDecoration:
                        const BoxDecoration(color: Colors.transparent),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: AppText(attachment.name,
                      numeric: true,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      maxLines: 1),
                ),
              ],
            ),
            PositionedDirectional(
              top: 8.h,
              start: 16.w,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(Icons.close_rounded,
                      color: Colors.white, size: 20.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
