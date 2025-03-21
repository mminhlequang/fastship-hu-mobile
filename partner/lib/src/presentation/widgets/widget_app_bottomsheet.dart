import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widget_app_divider.dart';
import 'package:flutter/material.dart';
import 'package:app/src/utils/utils.dart';
import 'package:app/src/constants/app_colors.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/extensions/context_extension.dart';
import 'package:internal_core/setup/app_textstyles.dart';

class WidgetAppBottomSheet extends StatelessWidget {
  static double get maxHeight =>
      appContext.height -
      appContext.mediaQueryPadding.top -
      appContext.mediaQueryPadding.bottom -
      55;

  const WidgetAppBottomSheet({
    super.key,
    required this.child,
    this.color,
    this.title,
    this.actions = const [],
    this.enableSafeArea = false,
    this.height,
    this.width,
    this.padding,
  });

  final Widget child;
  final Color? color;
  final double? height;
  final dynamic title;
  final List<Widget> actions;
  final bool enableSafeArea;
  final double? width;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        color: color ?? Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(16.sw, 4.sw, 6.sw, 4.sw),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: w600TextStyle(fontSize: 16.sw, color: grey1),
                  ),
                  const CloseButton(),
                ],
              ),
            ),
            const AppDivider(),
          ],
          Container(
            height: height,
            width: width,
            padding: padding,
            child: child,
          ),
          if (actions.isNotEmpty) ...[
            const AppDivider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 10.sw),
              child: Row(
                children: List.generate(
                  actions.length,
                  (index) => Expanded(child: actions[index]),
                )..insert(1, Gap(10.sw)),
              ),
            ),
          ],
          if (enableSafeArea) SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}
