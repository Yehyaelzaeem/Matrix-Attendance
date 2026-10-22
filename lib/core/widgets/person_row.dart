import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_avatar.dart';
import 'app_text.dart';

class PersonRow extends StatelessWidget {
  const PersonRow({
    super.key,
    required this.name,
    this.subtitle,
    this.trailing,
    this.titleBadge,
    this.avatarSize = 44,
    this.titleSize = 14.5,
    this.avatarName,
    this.avatarImage,
  });

  final String name;
  final String? subtitle;
  final Widget? trailing;
  final Widget? titleBadge;
  final double avatarSize;
  final double titleSize;
  final String? avatarName;
  final String? avatarImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppAvatar(
            name: avatarName ?? name, size: avatarSize, imagePath: avatarImage),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: AppText(name,
                        fontSize: titleSize,
                        fontWeight: FontWeight.w700,
                        maxLines: 1),
                  ),
                  if (titleBadge != null) ...[
                    SizedBox(width: 6.w),
                    titleBadge!,
                  ],
                ],
              ),
              if (subtitle != null && subtitle!.isNotEmpty)
                AppText(subtitle!,
                    fontSize: 12,
                    maxLines: 1,
                    color: AppColors.textSecondaryColor.themeColor),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
