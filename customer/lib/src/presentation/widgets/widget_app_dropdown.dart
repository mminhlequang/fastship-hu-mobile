import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/setup/app_utils.dart';
import 'package:internal_core/widgets/widgets.dart';

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    this.height = 120,
    required this.items,
    this.isAutoHeight = false,
    this.indexSelected,
    this.title,
    required this.hintText,
    required this.onChanged,
    required this.child,
    required this.itemAsString,
    this.isRequired = true,
  });

  final Widget child;
  final bool isAutoHeight;
  final double height;
  final List<T> items;
  final int? indexSelected;
  final String? title;
  final String hintText;
  final ValueChanged<int> onChanged;
  final bool isRequired;
  final String Function(T item) itemAsString;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text.rich(
            TextSpan(
              text: title,
              style: w600TextStyle(),
              children: isRequired
                  ? [
                      TextSpan(
                        text: '*',
                        style: w600TextStyle(color: Colors.red),
                      )
                    ]
                  : null,
            ),
          ),
        if (title != null) Gap(8.sw),
        WidgetOverlayActions(
          inkwellBorderRadius: 8.sw,
          child: child,
          builder: (child, size, childPosition, pointerPosition, animationValue,
              hide) {
            return Positioned(
              top: childPosition.dy + size.height + 2,
              left: childPosition.dx,
              child: Transform.scale(
                scaleY: animationValue,
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 4.sw),
                  height: isAutoHeight ? null : height,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 12,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: isAutoHeight,
                    physics:
                        isAutoHeight ? NeverScrollableScrollPhysics() : null,
                    padding: EdgeInsets.symmetric(vertical: 12.sw),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return WidgetInkWellTransparent(
                        enableInkWell: false,
                        onTap: () async {
                          await hide();
                          onChanged(index);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Text(
                            itemAsString(items[index]),
                            style: w400TextStyle(
                              fontSize: 16.sw,
                              color: index == indexSelected
                                  ? appColorPrimaryOrange
                                  : appColorText,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
