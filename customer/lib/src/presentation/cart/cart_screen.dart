import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/home/widgets/widget_restaurant_card.dart';
import 'package:app/src/presentation/navigation/cubit/navigation_cubit.dart';
import 'package:app/src/presentation/widgets/widget_button.dart';
import 'package:app/src/utils/utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/network_resources.dart';
import 'package:network_resources/product/model/product.dart';

import '../widgets/widget_appbar.dart';
import 'cubit/cart_cubit.dart';
import 'widgets/widget_cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int? cartId;

  @override
  void initState() {
    super.initState();
    cartCubit.fetchCarts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexColor('#F9F8F6'),
      body: Column(
        children: [
          WidgetAppBar(
            showBackButton: false,
            title: 'My cart'.tr(),
            actions: [
              WidgetInkWellTransparent(
                enableInkWell: false,
                onTap: () {
                  appHaptic();
                  // context.push('/help-center');
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Icon(Icons.more_vert, size: 28),
                ),
              ),
            ],
          ),
          Expanded(
            child: BlocBuilder<CartCubit, CartState>(
                bloc: cartCubit,
                builder: (context, state) {
                  if (state.isLoading && state.items.isEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: WidgetRestaurantCardShimmer(),
                        );
                      },
                    );
                  } else if (state.items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          WidgetAppSVG(
                            'icon89',
                            width: 160,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Empty',
                            style: w500TextStyle(
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'You don\'t have any foods in cart at this time',
                            textAlign: TextAlign.center,
                            style: w400TextStyle(
                              fontSize: 16,
                              color: appColorText2,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 21),
                          // Order Now Button
                          SizedBox(
                            width: context.width * .65,
                            child: WidgetButtonConfirm(
                              onPressed: () {
                                appHaptic();
                                navigationCubit.changeIndex(1);
                              },
                              color: appColorPrimary,
                              text: 'Order Now',
                              borderRadius: 120,
                            ),
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                    );
                  }

                  if (cartId == null && state.items.isNotEmpty) {
                    cartId = state.items.first.id;
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.sw),
                    itemBuilder: (context, index) {
                      if (index == state.items.length) {
                        return Container(
                          height: 120 + MediaQuery.of(context).padding.bottom,
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          appHaptic();
                          setState(() {
                            cartId = state.items[index].id;
                          });
                        },
                        child: WidgetCartItem(
                          cart: state.items[index],
                          isSelected: cartId == state.items[index].id,
                        ),
                      );
                    },
                    itemCount: state.items.length + 1,
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final ProductModel product;
  final int quantity;

  const CartItem({
    Key? key,
    required this.product,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 8, top: 8, left: 12.sw, right: 12.sw),
      decoration: BoxDecoration(),
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetAppImage(
                  imageUrl: product.image ?? '',
                  width: 60.sw,
                  height: 48.sw,
                  radius: 8,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? '',
                        style: w400TextStyle(
                          fontSize: 16.sw,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        product.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: w400TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7D7575),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Over 15 mins',
                            style: w400TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7D7575),
                            ),
                          ),
                          _buildDivider(),
                          Text(
                            '1,8 km',
                            style: w400TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7D7575),
                            ),
                          ),
                          _buildDivider(),
                          Text(
                            currencyFormatted(product.price),
                            style: w500TextStyle(
                              fontSize: 14,
                              color: Color(0xFFF17228),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
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
                    // setState(() {
                    //   quantity--;
                    // });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: WidgetAppSVG(
                      'icon52',
                      width: 24.sw,
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
                    // setState(() {
                    //   quantity++;
                    // });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: WidgetAppSVG(
                      'icon53',
                      width: 24.sw,
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

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 1,
        height: 13.5,
        color: Color(0xFFF1EFE9),
      ),
    );
  }
}
