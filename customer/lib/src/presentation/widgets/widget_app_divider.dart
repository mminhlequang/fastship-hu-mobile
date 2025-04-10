import 'package:app/src/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.height = 1,
    this.thickness = 1,
    this.color,
    this.padding,
  });

  final double height;
  final double thickness;
  final Color? color;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Divider(
        height: height,
        thickness: thickness,
        color: color ?? appColorBorder,
      ),
    );
  }
}
