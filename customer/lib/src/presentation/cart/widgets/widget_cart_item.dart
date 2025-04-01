import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/cart/models/models.dart';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/cart/cubit/cart_cubit.dart';
import 'package:app/src/presentation/widgets/widget_button.dart';
import 'package:app/src/utils/utils.dart';

import 'widget_preview_order.dart';

class WidgetCartItem extends StatelessWidget {
  final CartModel cart;
  final bool isSelected;
  const WidgetCartItem({
    super.key,
    required this.cart,
    this.isSelected = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.sw),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isSelected ? const Color(0xFF74CA45) : Colors.transparent),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRestaurantHeader(),
          const Divider(
            height: 21,
            thickness: 1,
            color: Color(0xFFEDEDED),
          ),
          _buildOrderItems(),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: WidgetButtonConfirm(
                onPressed: () {
                  appHaptic();
                  appOpenBottomSheet(WidgetPreviewOrder(cart: cart));
                },
                text:
                    'Check out now (${currencyFormatted(cart.cartItems?.fold(0, (sum, item) => sum! + (item.product?.price ?? 0) * (item.quantity ?? 0)) ?? 0)})'
                        .tr(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRestaurantHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WidgetAvatar.withoutBorder(
                        imageUrl: cart.store?.avatarImage ?? '',
                        radius: 12.sw,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cart.store?.name ?? '',
                          style: w500TextStyle(
                            fontSize: 16.sw,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Over 15 mins',
                        style: w400TextStyle(
                          fontSize: 12.sw,
                          color: const Color(0xFF7D7575),
                        ),
                      ),
                      _buildVerticalDivider(),
                      Text(
                        '1,8 km',
                        style: w400TextStyle(
                          fontSize: 12.sw,
                          color: const Color(0xFF7D7575),
                        ),
                      ),
                      _buildVerticalDivider(),
                      Row(
                        children: [
                          WidgetAppSVG(
                            'icon39',
                            width: 16.sw,
                            height: 16.sw,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '\$1.30',
                            style: w400TextStyle(
                              fontSize: 12.sw,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF17228),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            WidgetAppSVG(
                              'icon34',
                              width: 16.sw,
                              height: 16.sw,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '2,0 off',
                              style: w400TextStyle(
                                fontSize: 12.sw,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 1,
      height: 13.5,
      color: const Color(0xFFF1EFE9),
    );
  }

  Widget _buildOrderItems() {
    return Column(
      spacing: 16.sw,
      children: [
        ...cart.cartItems!.map((e) => _WidgetItem(cartItem: e)).toList(),
      ],
    );
  }
}

class _WidgetItem extends StatefulWidget {
  final CartItemModel cartItem;
  const _WidgetItem({super.key, required this.cartItem});

  @override
  State<_WidgetItem> createState() => __WidgetItemState();
}

class __WidgetItemState extends State<_WidgetItem> {
  bool loadingIncrease = false;
  bool loadingDecrease = false;
  @override
  Widget build(BuildContext context) {
    var cartItem = widget.cartItem;
    String descText = "";

    // Kiểm tra và hiển thị thông tin variations
    if (cartItem.variations != null && cartItem.variations!.isNotEmpty) {
      descText = cartItem.variations!
          .map((v) => '${v.variation?.name}: ${v.value}')
          .join(', ');
    }

    // Thêm thông tin toppings nếu có
    if (cartItem.toppings != null && cartItem.toppings!.isNotEmpty) {
      String toppingText = cartItem.toppings!.map((t) => t.name).join(', ');

      if (descText.isNotEmpty) {
        descText += ', $toppingText';
      } else {
        descText = toppingText;
      }
    }

    // Nếu không có variations và toppings, hiển thị description
    if (descText.isEmpty && cartItem.product?.description != null) {
      descText = cartItem.product!.description!;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetAppImage(
          imageUrl: cartItem.product?.image ?? '',
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          radius: 8,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cartItem.product?.name ?? '',
                style: w500TextStyle(
                  fontSize: 14.sw,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                descText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: w400TextStyle(
                  fontSize: 12.sw,
                  color: const Color(0xFF847D79),
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        currencyFormatted(cartItem.product?.priceCompare ?? 0),
                        style: w400TextStyle(
                          fontSize: 16.sw,
                          color: const Color(0xFFA6A0A0),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        currencyFormatted(cartItem.product?.price ?? 0),
                        style: w600TextStyle(
                          fontSize: 16.sw,
                          color: const Color(0xFFF17228),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(46),
                      border: Border.all(color: const Color(0xFFE7E7E7)),
                    ),
                    child: Row(
                      children: [
                        _buildQuantityButton(
                          onPressed: () async {
                            if (loadingDecrease) return;
                            appHaptic();
                            setState(() {
                              loadingDecrease = true;
                              cartItem.quantity = cartItem.quantity! - 1;
                            });

                            if (cartItem.quantity! <= 1) {
                              await cartCubit.removeCartItem(cartItem.id!);
                            } else {
                              await cartCubit.updateCart(cartItem);
                            }
                            setState(() {
                              loadingDecrease = false;
                            });
                          },
                          icon: 'icon52',
                        ),
                        const SizedBox(width: 6),
                        Text(
                          cartItem.quantity.toString(),
                          style: w500TextStyle(
                            fontSize: 14.sw,
                          ),
                        ),
                        const SizedBox(width: 6),
                        _buildQuantityButton(
                          onPressed: () async {
                            if (loadingIncrease) return;
                            appHaptic();
                            setState(() {
                              loadingIncrease = true;
                              cartItem.quantity = cartItem.quantity! + 1;
                            });
                            await cartCubit.updateCart(cartItem);
                            setState(() {
                              loadingIncrease = false;
                            });
                          },
                          icon: 'icon53',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required VoidCallback onPressed,
    required String icon,
  }) {
    return WidgetInkWellTransparent(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: WidgetAppSVG(
          icon,
          width: 20.sw,
          height: 20.sw,
          color: const Color(0xFF120F0F),
        ),
      ),
    );
  }
}
