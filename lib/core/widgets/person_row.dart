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
    this.avatarSize = 44,
    this.titleSize = 14.5,
    this.avatarName,
  });

  final String name;
  final String? subtitle;
  final Widget? trailing;
  final double avatarSize;
  final double titleSize;
  final String? avatarName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppAvatar(name: avatarName ?? name, size: avatarSize),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(name,
                  fontSize: titleSize,
                  fontWeight: FontWeight.w700,
                  maxLines: 1),
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
