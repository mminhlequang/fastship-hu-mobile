import 'package:network_resources/network_resources.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:network_resources/order/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.order});

  final OrderModel order;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool isLate = false; // Late delivery
  bool isCanceled = false; // Order canceled
  int step = 1;
  int? selectedReason;

  String get stepText => switch (step) {
        1 => 'Arrived at pickup point'.tr(),
        2 => 'Picked up order'.tr(),
        3 => 'Delivered'.tr(),
        _ => 'Update image'.tr(),
      };

  Future<void> _onPhoneCall() async {
    launchUrl(Uri.parse('tel:${widget.order.phone!}'));
  }

  void _onChat() {
    launchUrl(Uri.parse('sms:${widget.order.phone!}'));
  }

  List<String> reasons = [
    'Recipient requested delivery later'.tr(),
    'Cannot contact recipient'.tr(),
    'Recipient wants to cancel order / change address'.tr(),
    'Personal business'.tr(),
    'Traffic jam'.tr(),
    'Other'.tr(),
  ];

  _onRefuse() {
    setState(() {
      selectedReason = null;
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 300),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.sw, 4.sw, 6.sw, 4.sw),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Refusal reason'.tr(),
                        style: w600TextStyle(fontSize: 16.sw, color: grey1),
                      ),
                      const CloseButton(),
                    ],
                  ),
                ),
                const AppDivider(),
                ...List.generate(
                  reasons.length,
                  (index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.sw),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.sw),
                            child: RadioListTile(
                              title: Text(
                                reasons[index],
                                style: w400TextStyle(fontSize: 16.sw),
                              ),
                              dense: true,
                              activeColor: appColorPrimary,
                              visualDensity: VisualDensity(horizontal: -4),
                              contentPadding: EdgeInsets.zero,
                              value: index,
                              groupValue: selectedReason,
                              onChanged: (value) {
                                setState(() {
                                  selectedReason = value;
                                });
                              },
                            ),
                          ),
                          if (index != reasons.length - 1) const AppDivider(),
                        ],
                      ),
                    );
                  },
                ),
                const AppDivider(),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.sw, 16.sw, 16.sw,
                      16.sw + context.mediaQueryPadding.bottom),
                  child: WidgetRippleButton(
                    onTap: selectedReason == null
                        ? null
                        : () {
                            // Todo: Handle refusal
                          },
                    color: selectedReason == null ? grey8 : appColorPrimary,
                    child: SizedBox(
                      height: 48.sw,
                      child: Center(
                        child: Text(
                          'Confirm'.tr(),
                          style: w500TextStyle(
                            fontSize: 16.sw,
                            color:
                                selectedReason == null ? grey1 : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Order Details'.tr())),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Order basic info section
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.sw, vertical: 12.sw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Info'.tr(),
                          style: w600TextStyle(fontSize: 16.sw),
                        ),
                        Gap(8.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order ID'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                            Text(
                              widget.order.id?.toString() ?? 'N/A',
                              style: w500TextStyle(),
                            ),
                          ],
                        ),
                        Gap(4.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order Time'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                            Text(
                              // Use a placeholder time since createdAt doesn't exist
                              DateFormat('dd/MM/yyyy HH:mm')
                                  .format(DateTime.now()),
                              style: w400TextStyle(),
                            ),
                          ],
                        ),
                        Gap(4.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Payment Method'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                            Text(
                              'Cash'.tr(), // Use default payment method
                              style: w400TextStyle(),
                            ),
                          ],
                        ),
                        Gap(8.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.sw, vertical: 4.sw),
                              decoration: BoxDecoration(
                                color: appColorPrimary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.sw),
                              ),
                              child: Text(
                                widget.order.processStatus ??
                                    'Order received'.tr(),
                                style: w400TextStyle(
                                    color: appColorPrimary, fontSize: 12.sw),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppDivider(
                      height: 5.sw, thickness: 5.sw, color: appColorBackground),

                  // Merchant info section
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.sw, vertical: 12.sw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Merchant Info'.tr(),
                          style: w600TextStyle(fontSize: 16.sw),
                        ),
                        Gap(8.sw),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.order.store?.name ??
                                        'Unknown Store'.tr(),
                                    style: w500TextStyle(fontSize: 16.sw),
                                  ),
                                  Gap(4.sw),
                                  Text(
                                    widget.order.store?.address ??
                                        'No address available'.tr(),
                                    style: w400TextStyle(color: grey1),
                                  ),
                                  if (widget.order.store?.phone != null) ...[
                                    Gap(4.sw),
                                    Text(
                                      '${'Phone'.tr()}: ${widget.order.store!.phone}',
                                      style: w400TextStyle(color: grey1),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Gap(12.sw),
                            WidgetRippleButton(
                              onTap: () {
                                // TODO: Implement store direction
                              },
                              radius: 99,
                              borderSide:
                                  BorderSide(color: hexColor('#E3E3E3')),
                              child: SizedBox(
                                height: 32.sw,
                                width: 32.sw,
                                child: Center(
                                  child: Icon(Icons.directions, size: 18.sw),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppDivider(
                      height: 5.sw, thickness: 5.sw, color: appColorBackground),

                  // Customer info section
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.sw, vertical: 12.sw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer Info'.tr(),
                          style: w600TextStyle(fontSize: 16.sw),
                        ),
                        Gap(8.sw),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.order.customer?.name ??
                                        'Unknown Customer'.tr(),
                                    style: w500TextStyle(fontSize: 16.sw),
                                  ),
                                  Gap(4.sw),
                                  Text(
                                    widget.order.address ??
                                        'No address available'.tr(),
                                    style: w400TextStyle(color: grey1),
                                  ),
                                  if (widget.order.phone != null) ...[
                                    Gap(4.sw),
                                    Text(
                                      '${'Phone'.tr()}: ${widget.order.phone}',
                                      style: w400TextStyle(color: grey1),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Gap(12.sw),
                            WidgetRippleButton(
                              onTap: () {
                                // TODO: Implement customer direction
                              },
                              radius: 99,
                              borderSide:
                                  BorderSide(color: hexColor('#E3E3E3')),
                              child: SizedBox(
                                height: 32.sw,
                                width: 32.sw,
                                child: Center(
                                  child: Icon(Icons.directions, size: 18.sw),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(12.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Distance'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                            Text(
                              widget.order.shipDistance != null
                                  ? distanceFormatted(
                                      widget.order.shipDistance!)
                                  : 'Unknown'.tr(),
                              style: w400TextStyle(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (!isCanceled) ...[
                    // Delivery timer section
                    // Container(
                    //   color: isLate
                    //       ? appColorError.withOpacity(0.05)
                    //       : darkGreen.withOpacity(0.05),
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: 16.sw, vertical: 12.sw),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Icon(Icons.access_time,
                    //           size: 18.sw,
                    //           color: isLate ? appColorError : darkGreen),
                    //       Gap(8.sw),
                    //       Text.rich(
                    //         isLate
                    //             ? TextSpan(
                    //                 text: 'Late'.tr(),
                    //                 style: w500TextStyle(color: appColorError),
                    //                 children: [
                    //                   TextSpan(
                    //                     text: ' 44 ${'minutes'.tr()}',
                    //                     style:
                    //                         w400TextStyle(color: appColorError),
                    //                   ),
                    //                 ],
                    //               )
                    //             : TextSpan(
                    //                 text: '44 ${'minutes'.tr()}',
                    //                 style: w500TextStyle(color: darkGreen),
                    //                 children: [
                    //                   TextSpan(
                    //                     text: ' ${'left to deliver'.tr()}',
                    //                     style:
                    //                         w400TextStyle(color: appColorText),
                    //                   ),
                    //                 ],
                    //               ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ] else
                    Container(
                      color: appColorBackground,
                      padding: EdgeInsets.symmetric(vertical: 12.sw),
                      child: Center(
                        child: Text(
                          'Order canceled'.tr(),
                          style: w500TextStyle(color: appColorError),
                        ),
                      ),
                    ),

                  AppDivider(
                      height: 5.sw, thickness: 5.sw, color: appColorBackground),

                  // Merchant notes section
                  if (widget.order.note != null &&
                      widget.order.note!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.sw, vertical: 12.sw),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Merchant Note'.tr(),
                            style: w600TextStyle(fontSize: 16.sw),
                          ),
                          Gap(8.sw),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.sw),
                            decoration: BoxDecoration(
                              color: appColorBackground,
                              borderRadius: BorderRadius.circular(8.sw),
                            ),
                            child: Text(
                              widget.order.note!,
                              style: w400TextStyle(),
                            ),
                          ),
                        ],
                      ),
                    ),

                  AppDivider(
                      height: 5.sw, thickness: 5.sw, color: appColorBackground),

                  // Order details section
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.sw, 12.sw, 16.sw, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Details'.tr(),
                          style: w600TextStyle(fontSize: 16.sw),
                        ),
                        Gap(8.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Items'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                            Text(
                              '${widget.order.items?.length ?? 0} ${'items'.tr()}',
                              style: w500TextStyle(),
                            ),
                          ],
                        ),
                        Gap(12.sw),
                        ...List.generate(
                          widget.order.items?.length ?? 0,
                          (index) {
                            final item = widget.order.items![index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12.sw),
                                  decoration: BoxDecoration(
                                    color: appColorBackground,
                                    borderRadius: BorderRadius.circular(8.sw),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 24.sw,
                                        width: 24.sw,
                                        decoration: BoxDecoration(
                                          color: appColorPrimary,
                                          borderRadius:
                                              BorderRadius.circular(4.sw),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: w500TextStyle(
                                              fontSize: 12.sw,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Gap(12.sw),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.product?.name ?? '',
                                              style: w500TextStyle(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Gap(12.sw),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'x${item.quantity ?? 1}',
                                            style:
                                                w500TextStyle(color: darkGreen),
                                          ),
                                          Text(
                                            currencyFormatted(item.price ?? 0),
                                            style:
                                                w400TextStyle(fontSize: 12.sw),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Gap(8.sw),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ),

                  AppDivider(
                      height: 5.sw, thickness: 5.sw, color: appColorBackground),

                  // Merchant bill section
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.sw, vertical: 12.sw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Merchant Bill'.tr(),
                          style: w600TextStyle(fontSize: 16.sw),
                        ),
                        Gap(12.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                            Text(
                              currencyFormatted(
                                  widget.order.subtotal ?? widget.order.total),
                              style: w400TextStyle(color: grey1),
                            ),
                          ],
                        ),
                        Gap(4.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Merchant Discount'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                            Text(
                              '- ${currencyFormatted(widget.order.discount)}',
                              style: w400TextStyle(color: appColorError),
                            ),
                          ],
                        ),
                        Gap(4.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Additional Fee'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                            Text(
                              currencyFormatted(
                                  0), // No additionalFee property available
                              style: w400TextStyle(color: grey1),
                            ),
                          ],
                        ),
                        Gap(12.sw),
                        const AppDivider(),
                        Gap(8.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pay to Merchant'.tr(),
                              style: w500TextStyle(),
                            ),
                            Text(
                              currencyFormatted(widget.order.subtotal),
                              style: w500TextStyle(color: darkGreen),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  AppDivider(
                      height: 5.sw, thickness: 5.sw, color: appColorBackground),

                  // Customer bill section
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.sw, vertical: 12.sw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer Bill'.tr(),
                          style: w600TextStyle(fontSize: 16.sw),
                        ),
                        Gap(12.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                            Text(
                              currencyFormatted(
                                  widget.order.subtotal ?? widget.order.total),
                              style: w400TextStyle(color: grey1),
                            ),
                          ],
                        ),
                        Gap(4.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery Fee'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                            Text(
                              currencyFormatted(widget.order.shipFee),
                              style: w400TextStyle(color: grey1),
                            ),
                          ],
                        ),
                        if (widget.order.discount != null &&
                            widget.order.discount! > 0) ...[
                          Gap(4.sw),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Discount'.tr(),
                                style: w400TextStyle(color: grey1),
                              ),
                              Text(
                                '- ${currencyFormatted(widget.order.discount)}',
                                style: w400TextStyle(color: appColorError),
                              ),
                            ],
                          ),
                        ],
                        Gap(12.sw),
                        const AppDivider(),
                        Gap(8.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Collect from Customer'.tr(),
                              style: w500TextStyle(),
                            ),
                            Text(
                              currencyFormatted(widget.order.total),
                              style: w500TextStyle(color: darkGreen),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  AppDivider(
                      height: 5.sw, thickness: 5.sw, color: appColorBackground),

                  // Driver earnings section
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.sw, vertical: 12.sw),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Driver Earnings'.tr(),
                          style: w600TextStyle(fontSize: 16.sw),
                        ),
                        Gap(12.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery Fee'.tr(),
                              style: w400TextStyle(color: grey1),
                            ),
                            Text(
                              currencyFormatted(widget.order.shipFee),
                              style: w400TextStyle(color: darkGreen),
                            ),
                          ],
                        ),
                        if (widget.order.tip != null &&
                            widget.order.tip! > 0) ...[
                          Gap(4.sw),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tip'.tr(),
                                style: w400TextStyle(color: grey1),
                              ),
                              Text(
                                currencyFormatted(widget.order.tip),
                                style: w400TextStyle(color: darkGreen),
                              ),
                            ],
                          ),
                        ],
                        Gap(12.sw),
                        const AppDivider(),
                        Gap(8.sw),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Earnings'.tr(),
                              style: w500TextStyle(),
                            ),
                            Text(
                              currencyFormatted((widget.order.shipFee ?? 0) +
                                  (widget.order.tip ?? 0)),
                              style: w500TextStyle(
                                  color: darkGreen, fontSize: 16.sw),
                            ),
                          ],
                        ),
                        Gap(32.sw),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppDivider(color: appColorBackground),
          IgnorePointer(
            ignoring: isCanceled,
            child: Opacity(
              opacity: isCanceled ? .5 : 1,
              child: Container(
                padding:
                    EdgeInsets.only(bottom: context.mediaQueryPadding.bottom),
                height: 60.sw + context.mediaQueryPadding.bottom,
                child: Row(
                  children: [
                    Expanded(
                      child: WidgetRippleButton(
                        onTap: _onPhoneCall,
                        radius: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, size: 20.sw, color: grey1),
                            Gap(6.sw),
                            Text(
                              'Phone call'.tr(),
                              style:
                                  w400TextStyle(fontSize: 12.sw, color: grey1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(width: 1.sw, color: appColorBackground),
                    Expanded(
                      child: WidgetRippleButton(
                        onTap: _onChat,
                        radius: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(Icons.message, size: 20.sw, color: grey1),
                                // Positioned(
                                //   top: -4.sw,
                                //   right: -6.sw,
                                //   child: Container(
                                //     height: 16.sw,
                                //     width: 16.sw,
                                //     decoration: BoxDecoration(
                                //       color: appColorPrimary,
                                //       border: Border.all(color: Colors.white),
                                //       shape: BoxShape.circle,
                                //     ),
                                //     child: Center(
                                //       child: Text(
                                //         '2',
                                //         style: w400TextStyle(
                                //           fontSize: 10.sw,
                                //           color: Colors.white,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            Gap(6.sw),
                            Text(
                              'Send message'.tr(),
                              style:
                                  w400TextStyle(fontSize: 12.sw, color: grey1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(width: 1.sw, color: appColorBackground),
                    Expanded(
                      child: WidgetRippleButton(
                        onTap: _onRefuse,
                        radius: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.close, size: 20.sw, color: grey1),
                            Gap(6.sw),
                            Text(
                              'Cancel order'.tr(),
                              style:
                                  w400TextStyle(fontSize: 12.sw, color: grey1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AppDivider(color: appColorBackground),
          // Delivery action button section commented out for now
          // IgnorePointer(
          //   ignoring: isCanceled,
          //   child: Container(...),
          // ),
        ],
      ),
    );
  }
}
