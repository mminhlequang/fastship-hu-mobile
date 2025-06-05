import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:app/src/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:network_resources/cart/models/models.dart';
import 'package:network_resources/network_resources.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/order/models/models.dart';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:network_resources/order/repo.dart';
import 'package:app/src/presentation/widgets/widget_shimmer.dart';

import 'widget_rating.dart';

class WidgetOrderDetail extends StatefulWidget {
  final OrderModel m;
  const WidgetOrderDetail({super.key, required this.m});

  @override
  _WidgetOrderDetailState createState() => _WidgetOrderDetailState();
}

class _WidgetOrderDetailState extends State<WidgetOrderDetail> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  late OrderModel m = widget.m;

  bool isLoading = true;
  void _fetchData() async {
    setState(() {
      isLoading = true;
    });
    NetworkResponse response = await OrderRepo().getOrderDetail({
      'id': widget.m.id,
    });
    if (response.isSuccess) {
      m = response.data;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          WidgetAppBar(
            title: m.store?.name ?? "Order Detail".tr(),
            actions: [
              TextButton(
                onPressed: () {
                  appHaptic();
                  context.push('/help-center');
                },
                child: Text('Need help?'.tr(),
                    style: w400TextStyle(
                        fontSize: 16.sw, color: appColorPrimaryOrange)),
              ),
            ],
          ),
          Expanded(
            child: isLoading
                ? const WidgetShimmerOrderDetail()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        spacing: 24.sw,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOrderHeader(),
                          _buildDeliveryInfo(),
                          _buildOrderItems(),
                          _buildOrderSummary(),
                          // SizedBox(height: 20.sw),
                          if (m.processStatusEnum ==
                              AppOrderProcessStatus.completed) ...[
                            // const SizedBox(height: 16),

                            // Action buttons
                            Row(
                              children: [
                                // Review button hoặc Rating info
                                if (m.rating?.store?.star == null) ...[
                                  Expanded(
                                    child: WidgetButtonConfirm(
                                      height: 44,
                                      onPressed: () async {
                                        appHaptic();
                                        await pushWidget(
                                          child: WidgetRating(m: m),
                                        );
                                        // refreshCallback();
                                      },
                                      color: appColorPrimaryOrange,
                                      text: 'Review'.tr(),
                                      borderRadius: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                ] else ...[
                                  // Hiển thị rating info khi đã đánh giá
                                  Expanded(
                                    child: Container(
                                      height: 44,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9F8F6),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: appColorPrimaryOrange
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Rated:  '.tr(),
                                            style: w400TextStyle(
                                              fontSize: 14,
                                              color: appColorPrimaryOrange,
                                            ),
                                          ),
                                          WidgetAppSVG(
                                            'icon91',
                                            width: 16,
                                            height: 16,
                                            color: appColorPrimaryOrange,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            m.rating?.store?.star.toString() ??
                                                "0.0",
                                            style: w500TextStyle(
                                              fontSize: 14,
                                              color: appColorPrimaryOrange,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                ],
                                // Buy back button
                                Expanded(
                                  child: WidgetButtonConfirm(
                                    height: 44,
                                    color: appColorPrimary,
                                    onPressed: () {
                                      appHaptic();

                                      context.push(
                                        '/preview-order',
                                        extra: CartModel(
                                          previousOrderId: m.id,
                                          store: m.store,
                                          cartItems: m.items,
                                        ),
                                      );
                                    },
                                    text: 'Buy back'.tr(),
                                    borderRadius: 12,
                                  ),
                                ),
                              ],
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hexColor('#F9F8F6'),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Code'.tr(),
                style: w400TextStyle(
                  fontSize: 14.sw,
                  color: appColorText2,
                ),
              ),
              Text(
                m.code ?? '',
                style: w500TextStyle(
                  fontSize: 14.sw,
                  color: appColorPrimaryOrange,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.sw),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Time'.tr(),
                style: w400TextStyle(
                  fontSize: 14.sw,
                  color: appColorText2,
                ),
              ),
              Text(
                m.timeOrder ?? '',
                style: w500TextStyle(
                  fontSize: 14.sw,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.sw),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status'.tr(),
                style: w400TextStyle(
                  fontSize: 14.sw,
                  color: appColorText2,
                ),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.sw, vertical: 4.sw),
                decoration: BoxDecoration(
                  color: appColorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  m.processStatus?.toUpperCase() ?? '',
                  style: w500TextStyle(
                    fontSize: 12.sw,
                    color: appColorPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Information'.tr(),
          style: w500TextStyle(fontSize: 16.sw),
        ),
        SizedBox(height: 12.sw),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: hexColor('#F9F8F6'),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  WidgetAppSVG('icon20', width: 20.sw),
                  SizedBox(width: 8.sw),
                  Text(
                    m.deliveryType == 'pickup'
                        ? 'Pickup'.tr()
                        : 'Delivery'.tr(),
                    style: w500TextStyle(fontSize: 14.sw),
                  ),
                ],
              ),
              if (m.deliveryType != 'pickup' && m.address != null) ...[
                SizedBox(height: 8.sw),
                Text(
                  m.address ?? '',
                  style: w400TextStyle(
                    fontSize: 14.sw,
                    color: appColorText2,
                  ),
                ),
              ],
              if (m.deliveryType != 'pickup' && m.shipEstimateTime != null) ...[
                SizedBox(height: 8.sw),
                Row(
                  children: [
                    WidgetAppSVG('icon38',
                        width: 16.sw, color: appColorPrimaryOrange),
                    SizedBox(width: 8.sw),
                    Text(
                      'Estimated time: ${m.shipEstimateTime}',
                      style: w400TextStyle(
                        fontSize: 14.sw,
                        color: appColorPrimaryOrange,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Items'.tr(),
          style: w500TextStyle(fontSize: 16.sw),
        ),
        SizedBox(height: 12.sw),
        DottedBorder(
          options: RoundedRectDottedBorderOptions(
            radius: Radius.circular(16),
            padding: EdgeInsets.all(12),
            strokeWidth: .8,
            dashPattern: [8, 4],
            color: Color(0xFFCEC6C5),
          ),
          child: Column(
            spacing: 12.sw,
            children: m.items
                    ?.map((orderItem) => _buildOrderItem(orderItem))
                    .toList() ??
                [
                  Container(
                    padding: EdgeInsets.all(16.sw),
                    child: Text(
                      'No items found'.tr(),
                      style:
                          w400TextStyle(fontSize: 14.sw, color: appColorText2),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(CartItemModel orderItem) {
    // Xử lý dữ liệu order item từ OrderModel
    final productName = orderItem.product?.name ?? '';
    final quantity = orderItem.quantity ?? 1;
    final price = orderItem.product?.price ?? 0.0;
    final imageUrl = orderItem.product?.image ?? '';

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
              quantity.toString(),
              style: w500TextStyle(
                fontSize: 16.sw,
                height: 1,
              ),
            ),
          ),
          SizedBox(width: 12.sw),
          Expanded(
            child: Row(
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
                    imageUrl: imageUrl,
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
                        productName,
                        style: w500TextStyle(
                          fontSize: 14.sw,
                          color: Color(0xFF3C3836),
                        ),
                      ),
                      Gap(4.sw),
                      Text(
                        currencyFormatted(price.toDouble()),
                        style: w500TextStyle(
                          fontSize: 14.sw,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary'.tr(),
          style: w500TextStyle(fontSize: 16.sw),
        ),
        SizedBox(height: 12.sw),
        DottedBorder(
          options: RoundedRectDottedBorderOptions(
            radius: Radius.circular(16),
            padding: EdgeInsets.all(12),
            strokeWidth: .8,
            dashPattern: [8, 4],
            color: Color(0xFFCEC6C5),
          ),
          child: Column(
            spacing: 12.sw,
            children: [
              _buildSummaryRow(
                  'Subtotal'.tr(), currencyFormatted(m.subtotal ?? 0)),
              if ((m.shipFee ?? 0) > 0)
                _buildSummaryRow(
                    'Shipping Fee'.tr(), currencyFormatted(m.shipFee ?? 0)),
              if ((m.tip ?? 0) > 0)
                _buildSummaryRow('Tip'.tr(), currencyFormatted(m.tip ?? 0),
                    color: appColorPrimary),
              Divider(color: Color(0xFFCEC6C5)),
              _buildSummaryRow(
                'Total'.tr(),
                currencyFormatted(m.total ?? 0),
                isTotal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String title, String amount,
      {Color? color, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isTotal
              ? w600TextStyle(
                  fontSize: 16.sw,
                  color: Colors.black,
                )
              : w400TextStyle(
                  fontSize: 14.sw,
                  color: appColorText2,
                ),
        ),
        Text(
          amount,
          style: isTotal
              ? w600TextStyle(
                  fontSize: 18.sw,
                  color: color ?? Colors.black,
                )
              : w500TextStyle(
                  fontSize: 14.sw,
                  color: color ?? appColorText,
                ),
        ),
      ],
    );
  }
}
