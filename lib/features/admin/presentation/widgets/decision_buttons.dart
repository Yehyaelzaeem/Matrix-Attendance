import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_button.dart';

class DecisionButtons extends StatelessWidget {
  const DecisionButtons({
    super.key,
    required this.rejectLabel,
    required this.acceptLabel,
    required this.onReject,
    required this.onAccept,
    this.acceptType = ButtonStyleType.success,
  });

  final String rejectLabel;
  final String acceptLabel;
  final VoidCallback onReject;
  final VoidCallback onAccept;
  final ButtonStyleType acceptType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: CustomButton(
              title: rejectLabel,
              height: 44,
              radius: 13,
              fontSize: 14,
              type: ButtonStyleType.softDanger,
              onTap: onReject,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            flex: 15,
            child: CustomButton(
              title: acceptLabel,
              height: 44,
              radius: 13,
              fontSize: 14,
              type: acceptType,
              onTap: onAccept,
            ),
          ),
        ],
      ),
    );
  }
}
