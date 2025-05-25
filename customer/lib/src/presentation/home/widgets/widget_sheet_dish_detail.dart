import 'package:network_resources/network_resources.dart';
import 'package:app/src/constants/constants.dart';
import 'package:network_resources/product/model/product.dart';
import 'package:app/src/presentation/cart/cubit/cart_cubit.dart';
import 'package:app/src/utils/app_utils.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/store/models/models.dart';

class WidgetSheetDishDetail extends StatefulWidget {
  final ProductModel product;
  final StoreModel? store;
  const WidgetSheetDishDetail({super.key, required this.product, this.store});

  @override
  State<WidgetSheetDishDetail> createState() => _WidgetSheetDishDetailState();
}

class _WidgetSheetDishDetailState extends State<WidgetSheetDishDetail> {
  int quantity = 1;

  List<VariationValue> selectedVariationValues = [];

  @override
  void initState() {
    super.initState();
    if (widget.product.variations?.isNotEmpty ?? false) {
      selectedVariationValues = widget.product.variations
              ?.map((e) => e.values!.firstWhere(
                  (element) => element.isDefault == 1,
                  orElse: () => e.values!.first))
              .toList() ??
          [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 393),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 5.sw,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.sw)),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.product.name ?? '',
                  style: w600TextStyle(fontSize: 20.sw),
                ),
                16.h,
                Stack(
                  children: [
                    WidgetAppImage(
                      imageUrl: widget.product.image ?? '',
                      fit: BoxFit.cover,
                      height: 220.sw,
                      width: 240.sw,
                      radius: 12.sw,
                    ),
                    Positioned(
                      right: 16,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: hexColor('#F17228'),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            WidgetAppSVG(
                              'icon34',
                              width: 20.sw,
                            ),
                            SizedBox(width: 4.sw),
                            Text(
                              '20% off',
                              style: w400TextStyle(
                                color: Colors.white,
                                fontSize: 14.sw,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                DottedLine(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: hexColor('#D1D1D1'),
                  dashRadius: 0.0,
                  dashGapLength: 4.0,
                  dashGapColor: Colors.transparent,
                  dashGapRadius: 0.0,
                ),
                16.h,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price:',
                      style: w400TextStyle(fontSize: 18.sw),
                    ),
                    Row(
                      children: [
                        Text(
                          currencyFormatted(
                              widget.product.priceCompare?.toDouble()),
                          style: w400TextStyle(
                              color: hexColor('8E8E8E').withOpacity(.55),
                              fontSize: 18.sw,
                              decoration: TextDecoration.lineThrough),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          currencyFormatted(widget.product.price?.toDouble()),
                          style: w500TextStyle(
                            color: hexColor('#F17228'),
                            fontSize: 18.sw,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: w400TextStyle(
                      fontSize: 14.sw,
                      color: hexColor('8E8E8E').withOpacity(.55),
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'We cannot respond to requests such as increase / decrease or non-use of ingredients..',
                      ),
                      TextSpan(
                        text: 'show more',
                        style: w400TextStyle(color: hexColor('#74CA45')),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (widget.product.variations?.isNotEmpty ?? false)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: hexColor('#E7E7E7')),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12.sw,
                      children: [
                        ...widget.product.variations!.map((e) =>
                            _buildMenuSection(
                              e.name ?? '',
                              e.values?.map(
                                    (e) {
                                      bool isSelected = selectedVariationValues
                                          .any((element) => element.id == e.id);
                                      return GestureDetector(
                                        onTap: () {
                                          if (isSelected) {
                                            selectedVariationValues.removeWhere(
                                                (element) =>
                                                    element.id == e.id);
                                          } else {
                                            selectedVariationValues.removeWhere(
                                                (element) =>
                                                    element.parentId ==
                                                    e.parentId);
                                            selectedVariationValues.add(e);
                                          }
                                          setState(() {});
                                        },
                                        child: _MenuItem(
                                          title: e.value ?? '',
                                          price:
                                              "+${currencyFormatted(e.price?.toDouble())}",
                                          isSelected: isSelected,
                                        ),
                                      );
                                    },
                                  ).toList() ??
                                  [],
                            )),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 32),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE7E7E7)),
                    borderRadius: BorderRadius.circular(46),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: Row(
                    children: [
                      WidgetInkWellTransparent(
                        onTap: () {
                          appHaptic();
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: WidgetAppSVG(
                            'icon52',
                            width: 24.sw,
                            color: appColorText
                                .withOpacity(quantity > 1 ? 1 : 0.5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          '$quantity',
                          style: w400TextStyle(fontSize: 18.sw),
                        ),
                      ),
                      const SizedBox(width: 8),
                      WidgetInkWellTransparent(
                        onTap: () {
                          appHaptic();
                          setState(() {
                            quantity++;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: WidgetAppSVG(
                            'icon53',
                            width: 24.sw,
                            color: appColorText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: WidgetInkWellTransparent(
                    onTap: () {
                      appHaptic();
                      context.pop();
                      cartCubit.addToCart(
                        widget.store ?? widget.product.store!,
                        widget.product,
                        quantity,
                        selectedVariationValues: selectedVariationValues,
                      );
                    },
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: hexColor('#74CA45'),
                        borderRadius: BorderRadius.circular(120),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add to order'.tr(),
                            style: w500TextStyle(
                              color: Colors.white,
                              fontSize: 18.sw,
                            ),
                          ),
                          Text(
                            currencyFormatted(
                                (widget.product.price! * quantity +
                                        selectedVariationValues.fold(
                                            0,
                                            (previousValue, element) =>
                                                previousValue + element.price!))
                                    .toDouble()),
                            style: w600TextStyle(
                              color: Colors.white,
                              fontSize: 18.sw,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: w600TextStyle(fontSize: 16.sw)),
        const SizedBox(height: 8),
        ...items,
      ],
    );
  }
}

// Menu Item Widget
class _MenuItem extends StatelessWidget {
  final String title;
  final String price;
  final bool isSelected;

  const _MenuItem({
    Key? key,
    required this.title,
    required this.price,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: isSelected
          ? BoxDecoration(
              border: Border.all(color: appColorPrimary),
              color: hexColor('#E6FBDA'),
              borderRadius: BorderRadius.circular(12),
            )
          : BoxDecoration(
              color: hexColor('#F9F8F6'),
              borderRadius: BorderRadius.circular(12),
            ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: w400TextStyle(
                  color: isSelected ? Colors.black : hexColor('#7D7575'),
                  fontSize: 14.sw,
                ),
              ),
            ),
            Text(
              price,
              style: w500TextStyle(
                color: isSelected ? hexColor('#538D33') : hexColor('#B6B6B6'),
                fontSize: 14.sw,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
