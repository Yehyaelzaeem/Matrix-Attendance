import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmojiBox extends StatelessWidget {
  const EmojiBox({
    super.key,
    required this.emoji,
    required this.background,
    this.size = 44,
    this.radius,
    this.fontSize,
    this.color,
  });

  final String emoji;
  final Color background;
  final double size;
  final double? radius;
  final double? fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular((radius ?? size * 0.32).r),
      ),
      child: Text(
        emoji,
        style: TextStyle(
          fontSize: (fontSize ?? size * 0.45).sp,
          color: color,
          fontWeight: FontWeight.w800,
          height: 1.1,
        ),
      ),
    );
  }
}
