import 'dart:async';

import 'package:flutter/material.dart';

class WidgetBlink extends StatefulWidget {
  final Widget Function(Color) builder;
  final Color? color1;
  final Color color2;
  final Duration duration;
  const WidgetBlink({
    super.key,
    this.color1,
    required this.color2,
    required this.builder,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State<WidgetBlink> createState() => __WidgetBlinkState();
}

class __WidgetBlinkState extends State<WidgetBlink> {
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(widget.duration, (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(DateTime.now().second % 2 == 0
        ? (widget.color1 ?? Colors.transparent)
        : widget.color2);
  }
}
