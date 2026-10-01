import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/validators.dart';
import 'app_text.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.name,
    this.size = 44,
    this.radius,
    this.color,
    this.gradient,
    this.imagePath,
    this.borderColor,
    this.borderWidth = 2,
  });

  final String name;
  final double size;
  final double? radius;
  final Color? color;
  final Gradient? gradient;
  final String? imagePath;
  final Color? borderColor;
  final double borderWidth;

  static Color colorFor(String name) {
    final hash = name.runes.fold<int>(0, (a, b) => a + b);
    return AppColors.avatarPalette[hash % AppColors.avatarPalette.length];
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.isNotEmpty;
    return Container(
      width: size.r,
      height: size.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? colorFor(name)) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular((radius ?? size * 0.32).r),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
        image: hasImage
            ? DecorationImage(
                image: FileImage(File(imagePath!)), fit: BoxFit.cover)
            : null,
      ),
      child: hasImage
          ? null
          : AppText(
              Validators.initials(name),
              fontSize: size * 0.34,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
    );
  }
}
