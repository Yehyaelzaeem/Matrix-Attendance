import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/emoji_box.dart';

class QuickAction {
  const QuickAction({
    required this.emoji,
    required this.background,
    required this.label,
    required this.onTap,
  });

  final String emoji;
  final Color background;
  final String label;
  final VoidCallback onTap;
}

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key, required this.actions});

  final List<QuickAction> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Row(
        children: [
          for (var i = 0; i < actions.length; i++) ...[
            if (i > 0) SizedBox(width: 8.w),
            Expanded(
              child: GestureDetector(
                onTap: actions[i].onTap,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor.themeColor,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Column(
                    children: [
                      EmojiBox(
                        emoji: actions[i].emoji,
                        background: actions[i].background,
                        size: 42,
                        fontSize: 20,
                      ),
                      SizedBox(height: 8.h),
                      AppText(actions[i].label,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          maxLines: 1,
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
