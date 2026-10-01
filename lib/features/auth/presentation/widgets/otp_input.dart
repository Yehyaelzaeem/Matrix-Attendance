import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/widgets/app_text.dart';

class OtpInput extends StatefulWidget {
  const OtpInput(
      {super.key, required this.onChanged, required this.onCompleted});

  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {});
    widget.onChanged(value);
    if (value.length == AppConstants.otpLength) {
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) widget.onCompleted(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final code = _controller.text;
    return GestureDetector(
      onTap: () => _focus.requestFocus(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(AppConstants.otpLength, (i) {
                final filled = i < code.length;
                final active = _focus.hasFocus && i == code.length;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 42.w,
                  height: 56.h,
                  margin: EdgeInsets.symmetric(horizontal: 3.5.w),
                  transform: Matrix4.translationValues(0, active ? -2 : 0, 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: filled
                        ? AppColors.primarySoftColor.themeColor
                        : AppColors.cardColor.themeColor,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: filled || active
                          ? AppColors.primaryColor.themeColor
                          : AppColors.dividerColor.themeColor,
                      width: 1.5,
                    ),
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: AppColors.primaryColor.themeColor
                                  .withValues(alpha: 0.12),
                              spreadRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                  child: AppText(
                    filled ? code[i] : '',
                    numeric: true,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                );
              }),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: 0,
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  keyboardType: TextInputType.number,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  showCursor: false,
                  enableInteractiveSelection: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(AppConstants.otpLength),
                  ],
                  onChanged: _onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
