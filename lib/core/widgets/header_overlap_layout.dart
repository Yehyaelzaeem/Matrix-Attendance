import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderOverlapLayout extends StatelessWidget {
  const HeaderOverlapLayout({
    super.key,
    required this.header,
    required this.body,
    this.overlap = 76,
  });

  final Widget header;
  final Widget body;
  final double overlap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        Transform.translate(offset: Offset(0, -overlap.h), child: body),
      ],
    );
  }
}
