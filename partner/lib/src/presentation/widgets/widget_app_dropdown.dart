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
    required this.selectedItem,
    required this.title,
    required this.hintText,
    required this.onChanged,
    this.isRequired = true,
  });

  final double height;
  final List<T> items;
  final T? selectedItem;
  final String title;
  final String hintText;
  final ValueChanged<T?> onChanged;
  final bool isRequired;

  /// Customize display by item type
  /// For example, if app has Country model, so if T is Country => return item.name
  String _itemAsString(item) {
    // if (item is LoginAccessToken) {
    //   return item.publicInfo?.name ?? '';
    // } else if (item is BmBusiness) {
    //   return item.name ?? '';
    // }
    return item.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: title,
            style: w600TextStyle(),
            children: isRequired
                ? [
                    TextSpan(
                      text: '*',
                      style: w600TextStyle(color: appColorError),
                    )
                  ]
                : null,
          ),
        ),
        Gap(8.sw),
        WidgetOverlayActions(
          inkwellBorderRadius: 8.sw,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.sw, vertical: 8.sw),
            decoration: BoxDecoration(
              color: appColorBackground,
              borderRadius: BorderRadius.circular(8.sw),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedItem != null
                        ? _itemAsString(selectedItem)
                        : hintText,
                    style: w400TextStyle(
                      fontSize: 16.sw,
                      color: selectedItem != null
                          ? appColorText
                          : hexColor('#8A8C91'),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const WidgetAppSVG('arrow_down'),
              ],
            ),
          ),
          builder: (child, size, childPosition, pointerPosition, animationValue,
              hide) {
            return Positioned(
              top: childPosition.dy + size.height + 2,
              left: childPosition.dx,
              child: Transform.scale(
                scaleY: animationValue,
                alignment: Alignment.topCenter,
                child: Container(
                  height: height,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 12,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.all(16.sw),
                    itemCount: items.length,
                    separatorBuilder: (context, index) => Gap(16.sw),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          onChanged(items[index]);
                          hide();
                        },
                        child: Text(
                          _itemAsString(items[index]),
                          style: w400TextStyle(fontSize: 16.sw),
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
