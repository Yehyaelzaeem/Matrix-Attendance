import 'dart:async';

import 'package:app_base/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/router/navigation_services.dart';
import 'app_colors.dart';

class AppOverlay {
  AppOverlay._();

  static OverlayEntry? _current;

  static void showError(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) =>
      _show(message, _BannerType.error, duration);

  static void showSuccess(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) =>
      _show(message, _BannerType.success, duration);

  static void _show(String message, _BannerType type, Duration duration) {
    final overlay = NavigationService.navigationKey.currentState?.overlay;
    if (overlay == null) return;

    _current?.remove();
    _current = null;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _AppBanner(
        message: message,
        type: type,
        duration: duration,
        onDismiss: () {
          entry.remove();
          if (_current == entry) _current = null;
        },
      ),
    );

    _current = entry;
    overlay.insert(entry);
  }
}

enum _BannerType { error, success }

class _AppBanner extends StatefulWidget {
  const _AppBanner({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
  });

  final String message;
  final _BannerType type;
  final Duration duration;
  final VoidCallback onDismiss;

  @override
  State<_AppBanner> createState() => _AppBannerState();
}

class _AppBannerState extends State<_AppBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();
    _timer = Timer(widget.duration, _dismiss);
  }

  void _dismiss() {
    if (!mounted) return;
    _controller.reverse().then((_) => widget.onDismiss());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isError = widget.type == _BannerType.error;
    final bg =
        isError ? AppColors.errorColor.light : AppColors.successColor.light;
    final icon = isError
        ? Icons.error_outline_rounded
        : Icons.check_circle_outline_rounded;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: GestureDetector(
            onTap: _dismiss,
            child: Material(
              color: Colors.transparent,
              child: SafeArea(
                bottom: false,
                child: Container(
                  margin: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: bg.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(icon, color: Colors.white, size: 22.sp),
                      12.width,
                      Expanded(
                        child: Text(
                          widget.message,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                      ),
                      8.width,
                      GestureDetector(
                        onTap: _dismiss,
                        child: Icon(Icons.close_rounded,
                            color: Colors.white.withValues(alpha: 0.7),
                            size: 18.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
