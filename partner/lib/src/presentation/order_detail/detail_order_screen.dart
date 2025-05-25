import 'dart:async';

import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_utils.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/network_resources.dart';
import 'package:network_resources/order/models/models.dart';
import 'package:network_resources/order/repo.dart';
import 'package:shimmer/shimmer.dart' as shimmer;

import '../socket_shell/controllers/socket_controller.dart';

class DetailOrderScreen extends StatefulWidget {
  final int id;
  const DetailOrderScreen({super.key, required this.id});

  @override
  State<DetailOrderScreen> createState() => _DetailOrderScreenState();
}

class _DetailOrderScreenState extends State<DetailOrderScreen> {
  bool isLoading = true;

  void _notifyToDriver() {
    isLoading = true;
    setState(() {});
    socketController.updateStoreStatus(widget.id, AppOrderStoreStatus.completed,
        onSuccess: () {
      appShowSnackBar(msg: 'Order ready to pick up'.tr());
      _fetchOrder();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchOrder();
  }

  OrderModel? order;
  Future<void> _fetchOrder() async {
    setState(() {
      isLoading = true;
    });
    final response = await OrderRepo().getOrderDetail({"id": widget.id});
    if (response.data != null) {
      if (mounted) {
        setState(() {
          order = response.data;
          isLoading = false;
        });
      }
    }
  }

  Widget _buildShimmer() {
    return shimmer.Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & stepper shimmer
            Gap(16.sw),
            Padding(
              padding: EdgeInsets.only(left: 16.sw),
              child: Container(
                width: 200.sw,
                height: 12.sw,
                color: Colors.white,
              ),
            ),
            Gap(4.sw),
            Padding(
              padding: EdgeInsets.only(left: 16.sw),
              child: Container(
                width: 100.sw,
                height: 16.sw,
                color: Colors.white,
              ),
            ),
            Gap(24.sw),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
              child: Container(
                height: 80.sw,
                color: Colors.white,
              ),
            ),
            Gap(16.sw),

            // Contact info shimmer
            AppDivider(
              color: grey8,
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
            ),
            Gap(14.sw),
            Padding(
              padding: EdgeInsets.only(left: 16.sw, right: 16.sw),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150.sw,
                    height: 16.sw,
                    color: Colors.white,
                  ),
                  Gap(2.sw),
                  Container(
                    width: 200.sw,
                    height: 14.sw,
                    color: Colors.white,
                  ),
                  Gap(24.sw),
                  Container(
                    width: 120.sw,
                    height: 16.sw,
                    color: Colors.white,
                  ),
                  Gap(2.sw),
                  Container(
                    width: 180.sw,
                    height: 14.sw,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Gap(16.sw),
            AppDivider(
              color: grey8,
              padding: EdgeInsets.symmetric(horizontal: 16.sw),
            ),

            // Order details shimmer
            Gap(16.sw),
            Padding(
              padding: EdgeInsets.only(left: 16.sw),
              child: Container(
                width: 100.sw,
                height: 16.sw,
                color: Colors.white,
              ),
            ),
            ListView.separated(
              padding: EdgeInsets.fromLTRB(16.sw, 8.sw, 16.sw, 4.sw),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => AppDivider(color: grey8),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.sw),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              height: 16.sw,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Container(
                                width: 20.sw,
                                height: 16.sw,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Container(
                                width: 40.sw,
                                height: 16.sw,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(2.sw),
                      Container(
                        width: 120.sw,
                        height: 12.sw,
                        color: Colors.white,
                      ),
                    ],
                  ),
                );
              },
            ),
            AppDivider(height: 5.sw, thickness: 5.sw),

            // Order summary shimmer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150.sw,
                        height: 16.sw,
                        color: Colors.white,
                      ),
                      Container(
                        width: 60.sw,
                        height: 16.sw,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Gap(8.sw),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 80.sw,
                        height: 14.sw,
                        color: Colors.white,
                      ),
                      Container(
                        width: 40.sw,
                        height: 14.sw,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Gap(4.sw),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 60.sw,
                        height: 14.sw,
                        color: Colors.white,
                      ),
                      Container(
                        width: 40.sw,
                        height: 14.sw,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Gap(16.sw),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 120.sw,
                        height: 16.sw,
                        color: Colors.white,
                      ),
                      Container(
                        width: 60.sw,
                        height: 16.sw,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppDivider(height: 5.sw, thickness: 5.sw),

            // Order info shimmer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  6,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: 4.sw),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100.sw,
                          height: 14.sw,
                          color: Colors.white,
                        ),
                        Container(
                          width: 120.sw,
                          height: 14.sw,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Order details'.tr())),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? _buildShimmer()
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// status & stepper
                        // if (!isCompleted) ...[
                        //   Gap(16.sw),
                        //   Padding(
                        //     padding: EdgeInsets.only(left: 16.sw),
                        //     child: Text(
                        //       '${'Expected delivery at'.tr()} 18:50',
                        //       style:
                        //           w400TextStyle(fontSize: 12.sw, color: grey10),
                        //     ),
                        //   ),
                        //   Gap(4.sw),
                        //   Padding(
                        //     padding: EdgeInsets.only(left: 16.sw),
                        //     child: Text(
                        //       'New order'.tr(),
                        //       style: w600TextStyle(color: grey10),
                        //     ),
                        //   ),
                        //   Padding(
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: 8.sw, vertical: 24.sw),
                        //     child:
                        //         WidgetAnimatedStepper(currentStep: currentStep),
                        //   ),
                        // ],

                        /// contact customer & driver
                        // if (currentStep < 1)
                        ...[
                          AppDivider(
                            color: grey8,
                            padding: EdgeInsets.symmetric(horizontal: 16.sw),
                          ),
                          Gap(14.sw),
                          Stack(
                            children: [
                              Container(
                                width: context.width,
                                padding:
                                    EdgeInsets.only(left: 30.sw, right: 16.sw),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order!.store?.name ?? '',
                                      style: w400TextStyle(),
                                    ),
                                    Gap(2.sw),
                                    Text(
                                      order!.store?.address ?? '',
                                      style: w400TextStyle(color: grey1),
                                    ),
                                    Gap(24.sw),
                                    Text(
                                      order!.customer?.name ?? '',
                                      style: w400TextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned.fill(
                                top: 5.sw,
                                left: 16.sw,
                                bottom: 5.sw,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 2.5.sw,
                                        backgroundColor: appColorPrimary,
                                      ),
                                      Expanded(
                                        child: DottedLine(
                                          direction: Axis.vertical,
                                          lineThickness: 1,
                                          dashLength: 4,
                                          dashColor: appColorPrimary,
                                        ),
                                      ),
                                      CircleAvatar(
                                        radius: 2.5.sw,
                                        backgroundColor: appColorPrimary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gap(2.sw),
                          Padding(
                            padding: EdgeInsets.only(left: 30.sw, right: 16.sw),
                            child: Text(
                              order!.deliveryTypeEnum ==
                                      AppOrderDeliveryType.ship
                                  ? order!.address ?? ""
                                  : 'Pickup at store',
                              style: w400TextStyle(color: grey1),
                            ),
                          ),
                          Gap(16.sw),
                          AppDivider(
                            color: grey8,
                            padding: EdgeInsets.symmetric(horizontal: 16.sw),
                          ),
                        ],
                        //  else
                        ...[
                          if (order!.customer != null) ...[
                            AppDivider(height: 5.sw, thickness: 5.sw),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.sw, vertical: 12.sw),
                              child: Row(
                                children: [
                                  WidgetAvatar.withoutBorder(
                                    imageUrl: order!.customer?.avatar ?? '',
                                    radius: 28.sw / 2,
                                  ),
                                  Gap(8.sw),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order!.customer?.name ?? '',
                                          style: w600TextStyle(fontSize: 12.sw),
                                        ),
                                        Gap(4.sw),
                                        Text(
                                          order!.customer?.phone ?? '',
                                          style: w400TextStyle(
                                              fontSize: 12.sw, color: grey1),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => makePhoneCall(
                                        order!.customer?.phone ?? ''),
                                    child:
                                        WidgetAppSVG('ic_call', width: 24.sw),
                                  ),
                                ],
                              ),
                            )
                          ],
                          if (order!.driver != null) ...[
                            AppDivider(height: 5.sw, thickness: 5.sw),
                            WidgetInkWellTransparent(
                              onTap: () {
                                appOpenBottomSheet(
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.sw, vertical: 32.sw),
                                    child: Row(
                                      children: [
                                        WidgetAvatar.withoutBorder(
                                          imageUrl: order!.driver?.avatar ?? '',
                                          radius: 20.sw,
                                        ),
                                        Gap(12.sw),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    order!.driver?.name ?? '',
                                                    style: w600TextStyle(
                                                        fontSize: 16.sw),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8.sw),
                                                    child: CircleAvatar(
                                                      radius: 2.sw,
                                                      backgroundColor:
                                                          appColorText,
                                                    ),
                                                  ),
                                                  Text(
                                                    '5.0',
                                                    style: w400TextStyle(
                                                        color: grey1),
                                                  ),
                                                  Gap(1.sw),
                                                  WidgetAppSVG('ic_star',
                                                      width: 16.sw),
                                                ],
                                              ),
                                              Gap(1.sw),
                                              Text(
                                                '75E-6GS',
                                                style:
                                                    w400TextStyle(color: grey1),
                                              ),
                                            ],
                                          ),
                                        ),
                                        WidgetRippleButton(
                                          onTap: () {
                                            // Todo:
                                          },
                                          color: grey8,
                                          borderSide: BorderSide(
                                              color: hexColor('#E0E0E0')),
                                          child: SizedBox(
                                            height: 32.sw,
                                            width: 32.sw,
                                            child: Center(
                                              child: WidgetAppSVG('ic_chat',
                                                  width: 20.sw),
                                            ),
                                          ),
                                        ),
                                        Gap(12.sw),
                                        WidgetRippleButton(
                                          onTap: () {
                                            // Todo:
                                          },
                                          color: appColorPrimary,
                                          child: SizedBox(
                                            height: 32.sw,
                                            width: 32.sw,
                                            child: Center(
                                              child: WidgetAppSVG('ic_call_2',
                                                  width: 20.sw),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              enableInkWell: false,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.sw, vertical: 12.sw),
                                child: Row(
                                  children: [
                                    WidgetAvatar.withoutBorder(
                                      imageUrl: order!.driver?.avatar ?? '',
                                      radius: 28.sw / 2,
                                    ),
                                    Gap(8.sw),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            order!.driver?.name ?? '',
                                            style:
                                                w600TextStyle(fontSize: 12.sw),
                                          ),
                                          Gap(4.sw),
                                          Text(
                                            order!.driver?.phone ?? '',
                                            style: w400TextStyle(
                                                fontSize: 12.sw, color: grey1),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => makePhoneCall(
                                          order!.driver?.phone ?? ''),
                                      child:
                                          WidgetAppSVG('ic_call', width: 24.sw),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          AppDivider(height: 5.sw, thickness: 5.sw),
                        ],

                        /// rating
                        // if (isCompleted) ...[
                        //   Padding(
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: 16.sw, vertical: 12.sw),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             RatingBarIndicator(
                        //               rating: 4,
                        //               itemBuilder: (context, index) =>
                        //                   WidgetAppSVG('ic_star'),
                        //               itemCount: 5,
                        //               itemSize: 16.sw,
                        //               direction: Axis.horizontal,
                        //               unratedColor: grey7,
                        //               itemPadding: EdgeInsets.zero,
                        //             ),
                        //             Text(
                        //               '24/02/2025 11:11',
                        //               style: w400TextStyle(
                        //                   fontSize: 12.sw, color: grey1),
                        //             ),
                        //           ],
                        //         ),
                        //         Gap(11.sw),
                        //         WidgetAppImage(
                        //           imageUrl:
                        //               'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/flat-white-3402c4f.jpg',
                        //           height: 72.sw,
                        //           width: 72.sw,
                        //         ),
                        //         Gap(8.sw),
                        //         Text(
                        //           'Đóng gói chưa tốt',
                        //           style: w600TextStyle(fontSize: 12.sw),
                        //         ),
                        //         Gap(2.sw),
                        //         Text(
                        //           'Khach comment Lorem ipsum dolor sit amet consec tetur. Duis vel libero sed rutrum.',
                        //           style: w400TextStyle(
                        //               fontSize: 12.sw, color: grey10),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        //   const AppDivider(),
                        //   WidgetInkWellTransparent(
                        //     onTap: () {
                        //       // Todo:
                        //     },
                        //     enableInkWell: false,
                        //     child: Padding(
                        //       padding: EdgeInsets.symmetric(vertical: 8.sw),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           const WidgetAppSVG('ic_reply'),
                        //           Gap(2.sw),
                        //           Text(
                        //             'Feedback'.tr(),
                        //             style: w400TextStyle(
                        //                 fontSize: 12.sw, color: grey10),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        //   AppDivider(height: 5.sw, thickness: 5.sw),
                        // ],
                        Gap(16.sw),
                        Padding(
                          padding: EdgeInsets.only(left: 16.sw),
                          child: Text(
                            'Order details'.tr(),
                            style: w600TextStyle(),
                          ),
                        ),
                        ListView.separated(
                          padding:
                              EdgeInsets.fromLTRB(16.sw, 8.sw, 16.sw, 4.sw),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: order!.items?.length ?? 0,
                          separatorBuilder: (context, index) =>
                              AppDivider(color: grey8),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.sw),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          order!.items?[index].product?.name ??
                                              '',
                                          style: w400TextStyle(),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            order!.items?[index].quantity
                                                    .toString() ??
                                                '',
                                            style: w400TextStyle(),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            currencyFormatted(
                                                order!.items?[index].price ??
                                                    0),
                                            style: w400TextStyle(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(2.sw),
                                  Text(
                                    'Size M. Less ice',
                                    style: w400TextStyle(
                                        fontSize: 12.sw, color: grey1),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        AppDivider(height: 5.sw, thickness: 5.sw),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.sw, vertical: 12.sw),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       'Total item price (original price)'.tr(),
                              //       style: w600TextStyle(),
                              //     ),
                              //     Text(
                              //       currencyFormatted(35),
                              //       style: w600TextStyle(),
                              //     ),
                              //   ],
                              // ),
                              // Gap(8.sw),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       'Discount'.tr(), // giảm giá
                              //       style: w400TextStyle(color: grey1),
                              //     ),
                              //     Text(
                              //       currencyFormatted(3),
                              //       style: w400TextStyle(color: grey1),
                              //     ),
                              //   ],
                              // ),
                              // Gap(4.sw),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       'Rebate'.tr(), // chiết khấu
                              //       style: w400TextStyle(color: grey1),
                              //     ),
                              //     Text(
                              //       currencyFormatted(2),
                              //       style: w400TextStyle(color: grey1),
                              //     ),
                              //   ],
                              // ),
                              // Gap(16.sw),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${'Total amount received'.tr()} (${order!.items?.length} ${'dishes'.tr()})',
                                    style: w600TextStyle(),
                                  ),
                                  Text(
                                    currencyFormatted(order!.total ?? 0),
                                    style: w600TextStyle(color: darkGreen),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        AppDivider(height: 5.sw, thickness: 5.sw),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.sw, vertical: 12.sw),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order code'.tr(),
                                    style: w400TextStyle(color: grey1),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        copyToClipboard('8765432345yu89'),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '8765432345yu89',
                                          style: w400TextStyle(color: blue1),
                                        ),
                                        Gap(4.sw),
                                        WidgetAppSVG('ic_copy',
                                            width: 16.sw, color: blue1),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Gap(4.sw),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order time'.tr(),
                                    style: w400TextStyle(color: grey1),
                                  ),
                                  Text(
                                    order!.timeOrder ?? '',
                                    style: w400TextStyle(color: grey1),
                                  ),
                                ],
                              ),
                              Gap(4.sw),
                              if (order!.deliveryTypeEnum ==
                                  AppOrderDeliveryType.ship) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Distance'.tr(),
                                      style: w400TextStyle(color: grey1),
                                    ),
                                    Text(
                                      '${order!.shipDistance}km',
                                      style: w400TextStyle(color: grey1),
                                    ),
                                  ],
                                ),
                                Gap(4.sw),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Estimated pick up time'.tr(),
                                      style: w400TextStyle(color: grey1),
                                    ),
                                    Text(
                                      order!.timePickupEstimate ?? '',
                                      style: w400TextStyle(color: grey1),
                                    ),
                                  ],
                                ),
                                Gap(4.sw),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Pick up time'.tr(),
                                      style: w400TextStyle(color: grey1),
                                    ),
                                    Text(
                                      order!.timePickup ?? '',
                                      style: w400TextStyle(color: grey1),
                                    ),
                                  ],
                                ),
                                if (order!.timeDelivery != null) ...[
                                  Gap(4.sw),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Delivery time'.tr(),
                                        style: w400TextStyle(color: grey1),
                                      ),
                                      Text(
                                        order!.timeDelivery ?? '',
                                        style: w400TextStyle(color: grey1),
                                      ),
                                    ],
                                  ),
                                ],
                              ] else ...[
                                Gap(4.sw),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Delivery time'.tr(),
                                      style: w400TextStyle(color: grey1),
                                    ),
                                    Text(
                                      order!.timeDelivery ?? '',
                                      style: w400TextStyle(color: grey1),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          if (order != null &&
              order!.processStatusEnum.index <
                  AppOrderProcessStatus.driverPicked.index) ...[
            const AppDivider(),
            Padding(
              padding: EdgeInsets.fromLTRB(
                16.sw,
                10.sw,
                16.sw,
                10.sw + context.mediaQueryPadding.bottom,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: WidgetRippleButton(
                      onTap: () {
                        // Todo:
                        appHaptic();
                      },
                      borderSide: BorderSide(color: appColorPrimary),
                      child: SizedBox(
                        height: 48.sw,
                        child: Center(
                          child: Text(
                            'Cancel order'.tr(),
                            style: w500TextStyle(
                                fontSize: 16.sw, color: appColorPrimary),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(10.sw),
                  if (order!.storeStatusEnum.index <
                      AppOrderStoreStatus.completed.index)
                    Expanded(
                      child: WidgetRippleButton(
                        onTap: _notifyToDriver,
                        color: appColorPrimary,
                        child: SizedBox(
                          height: 48.sw,
                          child: Center(
                            child: Text(
                              'Order ready'.tr(),
                              style: w500TextStyle(
                                  fontSize: 16.sw, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
