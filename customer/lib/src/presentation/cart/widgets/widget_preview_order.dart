import 'package:app/src/base/cubit/location_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/cart/cubit/cart_cubit.dart';
import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:app/src/utils/utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';

import 'widget_sheet_locations.dart';
import 'widget_sheet_vouchers.dart';

class WidgetPreviewOrder extends StatefulWidget {
  final List<CartItemModel> cartItems;
  const WidgetPreviewOrder({Key? key, required this.cartItems})
      : super(key: key);

  @override
  _WidgetPreviewOrderState createState() => _WidgetPreviewOrderState();
}

class _WidgetPreviewOrderState extends State<WidgetPreviewOrder> {
  double tip = 0;
  bool isPickupYourself = false;
  double get subtotal => widget.cartItems.fold(
        0,
        (sum, cartItem) =>
            sum +
            (cartItem.product.price! * cartItem.quantity +
                cartItem.selectedVariationValues.fold(
                      0,
                      (sum, variation) => sum + variation.price!.toInt(),
                    ) *
                    2),
      );

  double get applicationFee => subtotal * 0.1; //TODO: Get from backend
  double get discount => 0.5; //TODO: Get from backend;

  double get total => subtotal + applicationFee + tip - discount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              spacing: 20.sw,
              children: [
                WidgetAppBar(
                  title: widget.cartItems.first.store.name ?? "",
                  actions: [
                    WidgetAppSVG('icon20', width: 18.sw, height: 18.sw),
                    const SizedBox(width: 4),
                    Text(
                      "0.6 Km",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: w400TextStyle(
                        fontSize: 14.sw,
                        color: Color(0xFFF17228),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    spacing: 20.sw,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAddressSection(),
                      // _buildShippingOptions(),
                      _buildOrderItems(),
                      // _buildPaymentMethod(),
                      _buildCourierTip(),
                      _buildOrderSummary(),
                      _buildDiscountSection(),
                      SizedBox(
                          height: 150 +
                              MediaQuery.of(context)
                                  .padding
                                  .bottom), // Space for bottom bar
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBottomCheckout(context),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.sw,
      children: [
        GestureDetector(
          onTap: () {
            appHaptic();
            setState(() {
              isPickupYourself = false;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: !isPickupYourself
                ? appBoxDecorationSelected
                : appBoxDecorationUnSelected,
            child: Column(
              children: [
                Row(
                  children: [
                    WidgetAppSVG(
                      'icon20',
                      width: 24.sw,
                    ),
                    SizedBox(width: 8.sw),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Current location'.tr(),
                                  style: w500TextStyle(
                                    fontSize: 16.sw,
                                  ),
                                ),
                              ),
                              WidgetInkWellTransparent(
                                onTap: () {
                                  appHaptic();
                                  appOpenBottomSheet(
                                      const WidgetSheetLocations());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: WidgetAppSVG(
                                    'icon28',
                                    width: 24.sw,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          BlocBuilder<LocationCubit, LocationState>(
                              bloc: locationCubit,
                              builder: (context, state) {
                                return Text(
                                  locationCubit.addressDetail ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF3C3836),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 10),
                // Container(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(12),
                //     color: Colors.white,
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         'Add detailed address and delivery instructions',
                //         style: TextStyle(
                //           fontSize: 12,
                //           color: Color(0xFF847D79),
                //         ),
                //       ),
                //       Icon(
                //         Icons.edit,
                //         color: Color(0xFF74CA45),
                //         size: 24,
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            appHaptic();
            setState(() {
              isPickupYourself = true;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: isPickupYourself
                ? appBoxDecorationSelected
                : appBoxDecorationUnSelected,
            child: Row(
              children: [
                WidgetAppSVG('icon38'),
                const SizedBox(width: 8),
                Text(
                  'Pick up yourself',
                  style: w400TextStyle(
                    fontSize: 16,
                    color: hexColor('#847D79'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildShippingOptions() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Shipping options',
  //         style: TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w500,
  //           color: Color(0xFF14142A),
  //         ),
  //       ),
  //       const SizedBox(height: 12),
  //       Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(12),
  //           border: Border.all(color: Color(0xFF74CA45)),
  //           color: Color(0xFFF9F8F6),
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               children: [
  //                 Text(
  //                   'Super fast',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     color: Color(0xFF847D79),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 8),
  //                 Text(
  //                   '10 mins',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w500,
  //                     color: Color(0xFF3C3836),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Text(
  //               '\$ 1,00',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w500,
  //                 color: Color(0xFF120F0F),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 8),
  //       Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(12),
  //           color: Color(0xFFF9F8F6),
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Row(
  //               children: [
  //                 Text(
  //                   'basic',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     color: Color(0xFF847D79),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 8),
  //                 Text(
  //                   '25 mins',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w500,
  //                     color: Color(0xFF3C3836),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Text(
  //               '\$ 2,00',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w500,
  //                 color: Color(0xFF120F0F),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildOrderItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order items'.tr(),
              style: w500TextStyle(fontSize: 16.sw),
            ),
            GestureDetector(
              onTap: () {
                appHaptic();
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  WidgetAppSVG(
                    'icon53',
                    height: 18.sw,
                    color: appColorPrimary,
                  ),
                  SizedBox(width: 4.sw),
                  Text(
                    'Add more'.tr(),
                    style: w400TextStyle(
                      fontSize: 16.sw,
                      color: appColorPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(16),
          padding: EdgeInsets.all(12),
          strokeWidth: .8,
          dashPattern: [8, 4],
          color: Color(0xFFCEC6C5),
          child: Column(
            spacing: 12.sw,
            children: widget.cartItems
                .map((cartItem) => _buildOrderItem(cartItem))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(CartItemModel cartItem) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.sw),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 4.sw),
            height: 34.sw,
            width: 34.sw,
            decoration: BoxDecoration(
              color: hexColor('#F2F1F1'),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              cartItem.quantity.toString(),
              style: w500TextStyle(
                fontSize: 16.sw,
                height: 1,
              ),
            ),
          ),
          SizedBox(width: 12.sw),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 44.sw,
                      height: 44.sw,
                      padding: EdgeInsets.all(1.sw),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFFF8F1F0)),
                      ),
                      child: WidgetAppImage(
                        imageUrl: cartItem.product.image,
                        width: 44.sw,
                        height: 44.sw,
                        radius: 8,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 8.sw),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartItem.product.name ?? "",
                            style: w500TextStyle(
                              fontSize: 14.sw,
                              color: Color(0xFF3C3836),
                            ),
                          ),
                          Gap(4.sw),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: currencyFormatted(cartItem
                                              .product.price! *
                                          cartItem.quantity +
                                      cartItem.selectedVariationValues.fold(
                                              0,
                                              (sum, variation) =>
                                                  sum +
                                                  variation.price!.toInt()) *
                                          cartItem.quantity),
                                  style: w500TextStyle(
                                    fontSize: 14.sw,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      " (${currencyFormatted(cartItem.product.price!)} x ${cartItem.quantity} + ${currencyFormatted(cartItem.selectedVariationValues.fold(0, (sum, variation) => sum + variation.price!.toInt()) * cartItem.quantity)})",
                                  style: w400TextStyle(
                                      fontSize: 14.sw, color: appColorText2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ...cartItem.product.variations!.map((e) => _buildMenuSection(
                      e.name ?? '',
                      e.values?.map(
                            (e) {
                              bool isSelected = cartItem.selectedVariationValues
                                  .any((element) => element.id == e.id);
                              return GestureDetector(
                                onTap: () {
                                  if (isSelected) {
                                    cartItem.selectedVariationValues
                                        .removeWhere(
                                            (element) => element.id == e.id);
                                  } else {
                                    cartItem.selectedVariationValues
                                        .removeWhere((element) =>
                                            element.parentId == e.parentId);
                                    cartItem.selectedVariationValues.add(e);
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
    );
  }

  // Widget _buildPaymentMethod() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             'Payment method',
  //             style: TextStyle(
  //               fontSize: 16,
  //               color: Color(0xFF14142A),
  //             ),
  //           ),
  //           Row(
  //             children: [
  //               Icon(Icons.add, color: Color(0xFF74CA45)),
  //               Text(
  //                 'Add more',
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   color: Color(0xFF74CA45),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 12),
  //       Container(
  //         padding: const EdgeInsets.all(16),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(16),
  //           color: Color(0xFFF9F8F6),
  //         ),
  //         child: Column(
  //           children: [
  //             _buildPaymentOption(
  //               title: 'Cash',
  //               isSelected: true,
  //             ),
  //             Divider(color: Color(0xFFF1EFE9)),
  //             _buildPaymentOption(
  //               title: 'Bank Transfer',
  //               showImage: true,
  //             ),
  //             Divider(color: Color(0xFFF1EFE9)),
  //             _buildPaymentOption(
  //               title: 'Sepa',
  //               showIcon: true,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildPaymentOption({
  //   required String title,
  //   bool isSelected = false,
  //   bool showImage = false,
  //   bool showIcon = false,
  // }) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Row(
  //         children: [
  //           Container(
  //             width: 24,
  //             height: 24,
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               border: Border.all(
  //                 color: isSelected ? Color(0xFF333333) : Color(0xFFCEC6C5),
  //               ),
  //             ),
  //             child: isSelected
  //                 ? Center(
  //                     child: Container(
  //                       width: 10,
  //                       height: 10,
  //                       decoration: BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         color: Color(0xFF333333),
  //                       ),
  //                     ),
  //                   )
  //                 : null,
  //           ),
  //           const SizedBox(width: 8),
  //           Text(
  //             title,
  //             style: TextStyle(
  //               fontSize: 14,
  //               color: Color(0xFF333333),
  //               letterSpacing: 0.28,
  //             ),
  //           ),
  //         ],
  //       ),
  //       if (showImage)
  //         Container(
  //           width: 49,
  //           height: 24,
  //           color: Colors.grey[200],
  //         )
  //       else if (showIcon)
  //         Icon(
  //           Icons.payment,
  //           size: 24,
  //           color: Color(0xFF0B4A8E),
  //         ),
  //     ],
  //   );
  // }

  Widget _buildCourierTip() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add courier tip'.tr(),
              style: w400TextStyle(
                fontSize: 16.sw,
              ),
            ),
            Text(
              '100% of the tip goes to your courier'.tr(),
              style: w400TextStyle(
                fontSize: 14.sw,
                color: hexColor('#847D79'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12.sw,
          runSpacing: 12.sw,
          children: [
            _buildTipOption(0),
            _buildTipOption(5),
            _buildTipOption(10),
            _buildTipOption(15),
            _buildTipOption(20),
          ],
        ),
      ],
    );
  }

  Widget _buildTipOption(double amount) {
    bool isSelected = tip == amount;
    return GestureDetector(
      onTap: () {
        appHaptic();
        setState(() {
          tip = amount;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Color(0xFF74CA45) : Color(0xFFCEC6C5),
          ),
          color: Colors.white,
        ),
        child: Text(
          '+ ${currencyFormatted(amount, decimalDigits: 0)}',
          style: w500TextStyle(
            fontSize: 16.sw,
            height: 1,
            color: isSelected ? appColorPrimary : hexColor('#847D79'),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(16),
      padding: EdgeInsets.all(12),
      strokeWidth: .8,
      dashPattern: [8, 4],
      color: Color(0xFFCEC6C5),
      child: Column(
        spacing: 12.sw,
        children: [
          _buildSummaryRow('Subtotal', currencyFormatted(subtotal)),
          _buildSummaryRow(
              'Application fee', currencyFormatted(applicationFee)),
          _buildSummaryRow('Courier tip', currencyFormatted(tip),
              color: appColorPrimary),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  WidgetAppSVG('icon34',
                      height: 18.sw, color: hexColor('#F17228')),
                  const SizedBox(width: 8),
                  Text(
                    '\$0.50 off, more deals below',
                    style: w400TextStyle(
                      fontSize: 16.sw,
                      color: hexColor('#3C3836'),
                    ),
                  ),
                ],
              ),
              Text(
                '- ${currencyFormatted(discount)}',
                style: w500TextStyle(
                  fontSize: 16.sw,
                  color: hexColor('#F17228'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String amount, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: w400TextStyle(
            fontSize: 16.sw,
            color: hexColor('#3C3836'),
          ),
        ),
        Text(
          amount,
          style: w500TextStyle(
            fontSize: 16.sw,
            color: color ?? hexColor('#091230'),
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountSection() {
    return GestureDetector(
      onTap: () {
        appHaptic();
        appOpenBottomSheet(const WidgetSheetVouchers());
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: hexColor('#F9F8F6'),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                WidgetAppSVG('icon34',
                    height: 18.sw, color: hexColor('#F17228')),
                const SizedBox(width: 12),
                Text(
                  'Use a discount or promotion'.tr(),
                  style: w500TextStyle(
                    fontSize: 16.sw,
                    color: hexColor('#F17228'),
                  ),
                ),
              ],
            ),
            WidgetAppSVG('icon28', height: 18.sw, color: appColorText2),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCheckout(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, MediaQuery.of(context).padding.bottom + 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: Offset(17, 10),
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total'.tr(),
                  style: w500TextStyle(
                    fontSize: 18.sw,
                  ),
                ),
                Text(
                  currencyFormatted(total),
                  style: w500TextStyle(
                    fontSize: 24.sw,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Check out'.tr(),
                style: w500TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF74CA45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(120),
                ),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                minimumSize: Size(double.infinity, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.sw),
        Text(title, style: w600TextStyle(fontSize: 16.sw)),
        SizedBox(height: 8.sw),
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
