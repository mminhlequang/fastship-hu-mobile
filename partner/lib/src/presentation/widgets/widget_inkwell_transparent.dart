import 'package:flutter/material.dart';

class WidgetInkWellTransparent extends StatelessWidget {
  const WidgetInkWellTransparent({
    super.key,
    this.onTap,
    required this.child,
    this.borderRadius,
    this.radius,
    this.hoverColor,
    this.onTapDown,
    this.enableInkWell = true,
  });

  final bool enableInkWell;
  final Color? hoverColor;
  final Widget child;
  final VoidCallback? onTap;
  final dynamic onTapDown;
  final BorderRadius? borderRadius;
  final double? radius;

  BorderRadius get _borderRadius =>
      borderRadius ?? BorderRadius.circular(radius ?? 999);

  @override
  Widget build(BuildContext context) {
    if (onTap == null) return child;
    if (!enableInkWell) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: ColoredBox(color: Colors.transparent, child: child),
        ),
      );
    }
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: _borderRadius),
      child: InkWell(
        borderRadius: _borderRadius,
        onTap: onTap,
        onTapDown: onTapDown,
        hoverColor: hoverColor,
        child: child,
      ),
    );
  }
}
