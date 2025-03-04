import 'package:app/src/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:internal_core/internal_core.dart';
import 'package:flutter/material.dart';

double get _height => 52.sw;

class WidgetAppButtonOK extends StatelessWidget {
  final bool enable;
  final bool loading;
  final String label;
  final VoidCallback? onTap;
  final double? height;

  const WidgetAppButtonOK({
    super.key,
    this.enable = true,
    this.loading = false,
    required this.label,
    this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: !enable || loading ? null : onTap,
        child: Ink(
          height: height ?? _height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.sw),
            color: enable ? appColorPrimary : AppColors.instance.grey8,
          ),
          child: Center(
            child: loading
                ? SizedBox(
                    width: 32,
                    height: 32,
                    child: CupertinoActivityIndicator(
                      color: Colors.white,
                      radius: 14,
                    ),
                  )
                : Text(
                    label,
                    style: w400TextStyle(
                        color: enable ? Colors.white : AppColors.instance.grey1,
                        fontSize: 18.sw),
                  ),
          ),
        ),
      ),
    );
  }
}

class WidgetAppButtonCancel extends StatelessWidget {
  final bool enable;
  final bool loading;
  final String label;
  final VoidCallback? onTap;
  final double? height;

  const WidgetAppButtonCancel({
    super.key,
    this.enable = true,
    this.loading = false,
    required this.label,
    this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: !enable || loading ? null : onTap,
        child: Ink(
          height: height ?? _height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.sw),
            color: Colors.transparent,
            border: Border.all(
              color:
                  enable ? appColorPrimary : appColorPrimary.withOpacity(0.45),
              width: 1.2,
            ),
          ),
          child: Center(
            child: loading
                ? SizedBox(
                    width: 32,
                    height: 32,
                    child: CupertinoActivityIndicator(
                      color: appColorPrimary,
                      radius: 14,
                    ),
                  )
                : Text(
                    label,
                    style:
                        w400TextStyle(color: appColorPrimary, fontSize: 18.sw),
                  ),
          ),
        ),
      ),
    );
  }
}
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
        hoverColor: hoverColor  ,
        child: child,
      ),
    );
  }
}
