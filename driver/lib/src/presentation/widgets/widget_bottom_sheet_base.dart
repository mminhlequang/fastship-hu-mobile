import 'dart:io';

import 'package:flutter/material.dart';
import 'package:app/src/utils/utils.dart';
import 'package:app/src/constants/app_colors.dart';
import 'package:internal_core/internal_core.dart';

class WidgetAppBaseSheet extends StatelessWidget {
  static double get maxHeight =>
      appContext.height -
      appContext.mediaQueryPadding.top -
      appContext.mediaQueryPadding.bottom -
      55;

  const WidgetAppBaseSheet({
    super.key,
    required this.child,
    this.color,
    this.title,
    this.actions,
    this.enableSafeArea = false,
    this.height,
    this.width,
    this.padding,
  });

  final Widget child;
  final Color? color;
  final double? height;
  final dynamic title;
  final List<Widget>? actions;
  final bool enableSafeArea;
  final double? width;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          color: color ?? appColorBackground),
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              child: Center(
                child: Container(
                  height: 5,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AppColors.instance.grey5,
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
            if (title != null)
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, top: 8, bottom: 8, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: title is Widget
                              ? title
                              : Text(
                                  title!,
                                  style: w400TextStyle(
                                    fontSize: 16,
                                    color: AppColors.instance.text,
                                  ),
                                ),
                        ),
                        if (actions != null) ...actions!,
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.instance.grey8,
                  ),
                  Container(
                    height: height,
                    width: width,
                    padding: padding,
                    child: child,
                  ),
                  if (enableSafeArea)
                    SizedBox(height: MediaQuery.paddingOf(context).bottom),
                ],
              )
            else
              Container(
                height: height,
                width: width,
                padding: padding,
                child: child,
              ),
          ],
        ),
      ),
    );
  }
}
