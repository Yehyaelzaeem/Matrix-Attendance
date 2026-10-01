import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShineOverlay extends StatefulWidget {
  const ShineOverlay({
    super.key,
    required this.child,
    this.enabled = true,
    this.radius = 20,
  });

  final Widget child;
  final bool enabled;
  final double radius;

  @override
  State<ShineOverlay> createState() => _ShineOverlayState();
}

class _ShineOverlayState extends State<ShineOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.radius.r),
              child: LayoutBuilder(
                builder: (_, constraints) => AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) {
                    final t = (_controller.value / 0.6).clamp(0.0, 1.0);
                    final width = constraints.maxWidth;
                    return Stack(
                      children: [
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: -80 + t * (width * 1.2 + 80),
                          width: 60,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withValues(alpha: 0),
                                  Colors.white.withValues(alpha: 0.35),
                                  Colors.white.withValues(alpha: 0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
