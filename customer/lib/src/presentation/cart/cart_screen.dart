import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/home/widgets/widget_restaurant_card.dart';
import 'package:app/src/presentation/navigation/cubit/navigation_cubit.dart';
import 'package:app/src/utils/utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/product/model/product.dart';

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
    cartCubit.getCarts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexColor('#F9F8F6'),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 12),
                      Text(
                        'My cart'.tr(),
                        style: w500TextStyle(
                          fontSize: 20.sw,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.more_vert, size: 28),
                ],
              ),
            ),
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
                          'icon8',
                          width: 237,
                          height: 232,
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
                          child: ElevatedButton(
                            onPressed: () {
                              appHaptic();
                              navigationCubit.changeIndex(1);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF74CA45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(120),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            child: Text(
                              'Order Now',
                              style: w500TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                      ],
                    ));
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
                            '\$ ${product.price?.toStringAsFixed(2)}',
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
