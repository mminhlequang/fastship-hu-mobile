import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

//Don't work
class WidgetLazyLoad extends StatefulWidget {
  final Widget child;

  const WidgetLazyLoad({
    super.key,
    required this.child,
  });

  @override
  State<WidgetLazyLoad> createState() => _WidgetLazyLoadState();
}

class _WidgetLazyLoadState extends State<WidgetLazyLoad> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('${widget.child.runtimeType}'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: _isVisible
          ? widget.child
          : const SizedBox(
              height: 100,
            ),
    );
  }
}
