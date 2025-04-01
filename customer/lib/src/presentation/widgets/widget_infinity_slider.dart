import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';

class WidgetInfinitySlider extends StatefulWidget {
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Widget child;
  final Duration? duration;
  final Axis? scrollDirection;
  final bool isIncrement;
  const WidgetInfinitySlider({
    super.key,
    this.width,
    this.height,
    this.decoration,
    this.padding,
    this.margin,
    required this.child,
    this.duration,
    this.scrollDirection,
    this.isIncrement = true,
  });

  @override
  State<WidgetInfinitySlider> createState() => _WidgetInfinitySliderState();
}

class _WidgetInfinitySliderState extends State<WidgetInfinitySlider> {
  final InfiniteScrollController _scrollController = InfiniteScrollController();
  late double width = 0;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    if (mounted) {
      setState(() {});
      timer?.cancel();
      timer = Timer.periodic(
          widget.duration ?? const Duration(milliseconds: 10), (timer) async {
        if (_scrollController.hasClients) {
          width = (width + (widget.isIncrement ? 1 : -1));
          _scrollController.jumpTo(width);
        }
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.decoration,
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      margin: widget.margin,
      child: InfiniteListView.builder(
        clipBehavior: Clip.none,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: widget.scrollDirection ?? Axis.horizontal,
        itemBuilder: (_, index) => widget.child,
        controller: _scrollController,
      ),
    );
  }
}
