import 'package:flutter/material.dart';

class CustomTapEffect extends StatefulWidget {
  const CustomTapEffect({
    super.key,
    this.isClickable = true,
    this.enableAnimation = true,
    required this.onTap,
    required this.child,
  });

  final bool isClickable;
  final bool enableAnimation;
  final VoidCallback? onTap;
  final Widget child;

  @override
  _TapEffectState createState() => _TapEffectState();
}

class _TapEffectState extends State<CustomTapEffect>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  DateTime tapTime = DateTime.now();
  bool isProgress = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    animationController!.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant CustomTapEffect oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.enableAnimation) {
      animationController!.value = 1.0;
    }
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  Future<void> _onDelayed() async {
    if (widget.isClickable) {
      final int tapDuration = DateTime.now().millisecondsSinceEpoch -
          tapTime.millisecondsSinceEpoch;

      if (tapDuration < 120) {
        await Future.delayed(
          Duration(milliseconds: 120 - tapDuration),
        );
      }
    }
  }

  Future<void> onTapCancel() async {
    if (widget.isClickable && widget.enableAnimation) {
      await _onDelayed();
      animationController!.animateTo(
        1.0,
        duration: const Duration(milliseconds: 240),
        curve: Curves.fastOutSlowIn,
      );
    }
    isProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.isClickable) {
          await Future.delayed(const Duration(milliseconds: 280));
          try {
            if (!isProgress) {
              widget.onTap?.call();
              isProgress = true;
            }
          } catch (_) {}
        }
      },
      onTapDown: (details) {
        if (widget.isClickable && widget.enableAnimation) {
          tapTime = DateTime.now();
          animationController!.animateTo(
            0.9,
            duration: const Duration(milliseconds: 120),
            curve: Curves.fastOutSlowIn,
          );
        }
        isProgress = true;
      },
      onTapUp: (details) {
        onTapCancel();
      },
      onTapCancel: () {
        onTapCancel();
      },
      child: AnimatedBuilder(
        animation: animationController!,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.enableAnimation ? animationController!.value : 1.0,
            child: widget.child,
          );
        },
      ),
    );
  }
}
