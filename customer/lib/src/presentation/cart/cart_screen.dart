import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/navigation/cubit/navigation_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_core/internal_core.dart';

import 'cubit/cart_cubit.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
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
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
                    if (state.isLoading) {
                      // TODO: Show loading
                      return const Center(child: CircularProgressIndicator());
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

                    return ListView(
                      padding: EdgeInsets.all(16),
                      children: [
                        CartItem(
                          imageUrl:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/274dad09f12da0d3892fc999ee19595d57f77470',
                          title: 'Pork cutlet burger and drink .',
                          description:
                              'We cannot respond to requests such as increase / decrease or non-use of ingredients.',
                          price: 2.20,
                          quantity: 3,
                          showQuantityControls: false,
                        ),
                        CartItem(
                          title: 'Mentaiko and cheese chicken ...',
                          description:
                              'We cannot respond to requests such as increase / decrease or non-use of ingredients.',
                          price: 2.20,
                          quantity: 3,
                          showQuantityControls: true,
                        ),
                        CartItem(
                          imageUrl:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/aa07a702781a4c1191b25a0f3614dd9f5cb64de5',
                          title: 'Mentaiko and cheese chicken ...',
                          description:
                              'We cannot respond to requests such as increase / decrease or non-use of ingredients.',
                          price: 2.20,
                          quantity: 3,
                          showQuantityControls: false,
                        ),
                        CartItem(
                          imageUrl:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/aa07a702781a4c1191b25a0f3614dd9f5cb64de5',
                          title: 'Mentaiko and cheese chicken ...',
                          description:
                              'We cannot respond to requests such as increase / decrease or non-use of ingredients.',
                          price: 2.20,
                          quantity: 3,
                          showQuantityControls: false,
                        ),
                        CartItem(
                          imageUrl:
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/aa07a702781a4c1191b25a0f3614dd9f5cb64de5',
                          title: 'Mentaiko and cheese chicken ...',
                          description:
                              'We cannot respond to requests such as increase / decrease or non-use of ingredients.',
                          price: 2.20,
                          quantity: 3,
                          showQuantityControls: false,
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String description;
  final double price;
  final int quantity;
  final bool showQuantityControls;

  const CartItem({
    Key? key,
    this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.showQuantityControls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFD1D1D1),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null) ...[
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl!,
                          width: 60,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: Color(0xFF363853),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 8),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF14142A),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7D7575),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'Over 15 mins',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7D7575),
                            ),
                          ),
                          _buildDivider(),
                          Text(
                            '1,8 km',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7D7575),
                            ),
                          ),
                          _buildDivider(),
                          Text(
                            '\$ ${price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
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
          if (showQuantityControls)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFE7E7E7)),
                borderRadius: BorderRadius.circular(46),
                color: Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF120F0F),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '$quantity',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      '-',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF120F0F),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(46),
                color: Color(0xFFF2F1F1),
              ),
              child: Text(
                '$quantity',
                style: TextStyle(fontSize: 14),
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
