import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/task_enums.dart';
import '../../data/models/task_model.dart';

class CommentBubble extends StatelessWidget {
  const CommentBubble({super.key, required this.comment, required this.isMine});

  final TaskComment comment;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.textSecondaryColor.themeColor;
    if (comment.isSystem) {
      return Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor.themeColor,
            borderRadius: BorderRadius.circular(999),
          ),
          child: AppText('${comment.text} · ${comment.at}',
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: muted,
              textAlign: TextAlign.center),
        ),
      );
    }
    final isReturn = comment.kind == CommentKind.returned;
    final background = isReturn
        ? AppColors.errorSoftColor.themeColor
        : isMine
            ? AppColors.primarySoftColor.themeColor
            : AppColors.surfaceColor.themeColor;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAvatar(name: comment.by, size: 32, radius: 10),
        SizedBox(width: 10.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(4.r),
                topEnd: Radius.circular(16.r),
                bottomStart: Radius.circular(16.r),
                bottomEnd: Radius.circular(16.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        '${comment.by}${isReturn ? LocaleKeys.tasks_returnedIt.tr() : ''}',
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        maxLines: 1,
                      ),
                    ),
                    AppText(comment.at, fontSize: 11, color: muted),
                  ],
                ),
                SizedBox(height: 3.h),
                AppText(comment.text,
                    fontSize: 13.5,
                    height: 1.75,
                    color: AppColors.textBodyColor.themeColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
