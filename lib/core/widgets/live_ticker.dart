import 'dart:async';

import 'package:flutter/material.dart';

class LiveTicker extends StatefulWidget {
  const LiveTicker({
    super.key,
    required this.builder,
    this.enabled = true,
    this.interval = const Duration(seconds: 1),
  });

  final Widget Function(BuildContext context, DateTime now) builder;
  final bool enabled;
  final Duration interval;

  @override
  State<LiveTicker> createState() => _LiveTickerState();
}

class _LiveTickerState extends State<LiveTicker> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(covariant LiveTicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) _sync();
  }

  void _sync() {
    _timer?.cancel();
    if (widget.enabled) {
      _timer = Timer.periodic(widget.interval, (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, DateTime.now());
}
