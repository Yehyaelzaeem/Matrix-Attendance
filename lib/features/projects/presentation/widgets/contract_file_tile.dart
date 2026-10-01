import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

class ContractFileTile extends StatelessWidget {
  const ContractFileTile(
      {super.key, required this.fileName, required this.onTap});

  final String fileName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final has = fileName.isNotEmpty;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor.themeColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
              color: AppColors.dashedBorderColor.themeColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 48.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.errorSoftColor.themeColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: AppText(LocaleKeys.common_pdf.tr(),
                  numeric: true,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.errorColor.themeColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    has ? fileName : LocaleKeys.projects_noContract.tr(),
                    numeric: has,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    maxLines: 1,
                  ),
                  AppText(
                    has
                        ? LocaleKeys.projects_replaceContract.tr()
                        : LocaleKeys.projects_uploadContract.tr(),
                    fontSize: 11.5,
                    color: AppColors.textSecondaryColor.themeColor,
                  ),
                ],
              ),
            ),
            AppText(
              has
                  ? LocaleKeys.common_replace.tr()
                  : LocaleKeys.common_upload.tr(),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor.themeColor,
            ),
          ],
        ),
      ),
    );
  }
}
