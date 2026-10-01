import 'package:flutter/material.dart';

class GridBackground extends StatefulWidget {
  const GridBackground({
    super.key,
    this.opacity = 1,
    this.cell = 36,
    this.animate = true,
    this.lineAlpha = 0.06,
  });

  final double opacity;
  final double cell;
  final bool animate;
  final double lineAlpha;

  @override
  State<GridBackground> createState() => _GridBackgroundState();
}

class _GridBackgroundState extends State<GridBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: widget.opacity,
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (rect) => const RadialGradient(
            center: Alignment(0, -0.1),
            radius: 0.9,
            colors: [Colors.black, Colors.transparent],
          ).createShader(rect),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => CustomPaint(
              size: Size.infinite,
              painter: GridPainter(
                cell: widget.cell,
                shift: _controller.value * widget.cell,
                color: Colors.white.withValues(alpha: widget.lineAlpha),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  GridPainter({required this.cell, required this.shift, required this.color});

  final double cell;
  final double shift;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (double x = shift - cell; x < size.width; x += cell) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = shift - cell; y < size.height; y += cell) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) =>
      oldDelegate.shift != shift || oldDelegate.color != color;
}
