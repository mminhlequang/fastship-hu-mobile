import 'package:app/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';

import 'widget_popup_container.dart';

class WidgetDropSelectorBuilder extends StatelessWidget {
  final List<dynamic> items;
  final dynamic selectedItem;

  final String Function(dynamic) titleBuilder;
  final Function(dynamic) onChanged;
  final Widget child;

  const WidgetDropSelectorBuilder({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.titleBuilder,
    required this.onChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetOverlayActions(
      builder:
          (child, size, childPosition, pointerPosition, animationValue, hide) {
        return Positioned(
          left: 20,
          right: 20,
          top: childPosition.dy + size.height + 4,
          child: WidgetPopupContainer(
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(
                      items.length,
                      (index) => InkWell(
                        onTap: () {
                          hide();
                          onChanged(items[index]);
                        },
                        child: Ink(
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            titleBuilder(items[index]),
                            style: w400TextStyle(fontSize: 16.sw),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      child: IgnorePointer(
        ignoring: true,
        child: child,
      ),
    );
  }
}
