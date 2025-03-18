import 'package:flutter/material.dart';
import '../setup/index.dart';

class WidgetRippleButton extends StatelessWidget {
  const WidgetRippleButton({
    super.key,
    this.color,
    this.elevation = 0,
    this.onTap,
    this.child,
    this.shadowColor,
    this.enable = true,
    this.radius = 0,
    this.borderSide = BorderSide.none,
  });

  final bool enable;
  final Color? color;
  final Color? shadowColor;
  final double elevation;
  final VoidCallback? onTap;
  final Widget? child;
  final double radius;
  final BorderSide borderSide;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      shadowColor: shadowColor ?? appColors?.text.withValues(alpha: .1),
      color: enable ? (color ?? appColorPrimary) : hexColor('#F2F2F2'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: borderSide,
      ),
      clipBehavior: Clip.none,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: enable && onTap != null
            ? () {
                appHaptic();
                onTap!.call();
              }
            : null,
        child: child,
      ),
    );
  }
}
