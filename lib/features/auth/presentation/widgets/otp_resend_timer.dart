import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/date_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

class OtpResendTimer extends StatefulWidget {
  const OtpResendTimer({super.key, required this.onResend});

  final VoidCallback onResend;

  @override
  State<OtpResendTimer> createState() => _OtpResendTimerState();
}

class _OtpResendTimerState extends State<OtpResendTimer> {
  Timer? _timer;
  int _seconds = AppConstants.otpResendSeconds;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _timer?.cancel();
    setState(() => _seconds = AppConstants.otpResendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _seconds--);
      if (_seconds <= 0) t.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.textSecondaryColor.themeColor;
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: _seconds > 0
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(LocaleKeys.auth_resendIn.tr(), color: muted),
                SizedBox(width: 4.w),
                AppText('00:${DateHelper.twoDigits(_seconds)}',
                    numeric: true, fontWeight: FontWeight.w700),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(LocaleKeys.auth_noCode.tr(), color: muted),
                SizedBox(width: 4.w),
                GestureDetector(
                  onTap: () {
                    widget.onResend();
                    _start();
                  },
                  child: AppText(LocaleKeys.auth_resend.tr(),
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor.themeColor),
                ),
              ],
            ),
    );
  }
}
