import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class ExpandableSection extends StatefulWidget {
  const ExpandableSection(
      {super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              children: [
                Expanded(
                  child: AppText(widget.title,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: primary),
                ),
                AnimatedRotation(
                  turns: _open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.keyboard_arrow_down_rounded,
                      color: primary, size: 20.sp),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          alignment: Alignment.topCenter,
          child: _open
              ? Column(children: widget.children)
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}
