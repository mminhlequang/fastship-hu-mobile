// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app/src/presentation/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:network_resources/cart/models/models.dart';
import 'package:network_resources/network_resources.dart';
import 'package:network_resources/order/models/models.dart';
import 'package:network_resources/order/repo.dart';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_appbar.dart';
import 'package:app/src/utils/utils.dart';

import '../navigation/cubit/navigation_cubit.dart';
import 'widgets/widget_order_detail.dart';
import 'widgets/widget_rating.dart' show WidgetRating;

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final ScrollController _scrollController = ScrollController();
  List<OrderModel>? orders;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int offset = 0;
  final int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // Lắng nghe scroll để load more
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!isLoadingMore && hasMoreData) {
        _loadMoreOrders();
      }
    }
  }

  AppOrderProcessStatus? orderStatus;
  // Load trang đầu tiên
  void _fetchOrders() async {
    setState(() {
      orders = null;
      offset = 0;
      hasMoreData = true;
    });

    NetworkResponse response = await OrderRepo().getOrdersByUser({
      "process_status": orderStatus?.name,
      "offset": 0,
      "limit": itemsPerPage
    });

    if (response.isSuccess) {
      final List<OrderModel> fetchedOrders = response.data as List<OrderModel>;
      orders = fetchedOrders;
      hasMoreData = fetchedOrders.length == itemsPerPage;
    } else {
      orders = [];
      appShowSnackBar(
          context: context,
          msg: response.msg ??
              "Could not fetch your orders at the moment, please try again later",
          type: AppSnackBarType.error);
    }
    setState(() {});
  }

  // Load more khi scroll xuống cuối
  void _loadMoreOrders() async {
    if (isLoadingMore || !hasMoreData) return;

    setState(() {
      isLoadingMore = true;
    });

    final nextOffset = offset + 1;
    NetworkResponse response = await OrderRepo().getOrdersByUser({
      "process_status": orderStatus?.name,
      "offset": nextOffset * itemsPerPage,
      "limit": itemsPerPage
    });

    if (response.isSuccess) {
      final List<OrderModel> newOrders = response.data as List<OrderModel>;
      if (newOrders.isNotEmpty) {
        orders!.addAll(newOrders);
        offset = nextOffset;
        hasMoreData = newOrders.length == itemsPerPage;
      } else {
        hasMoreData = false;
      }
    } else {
      appShowSnackBar(
          context: context,
          msg: response.msg ?? "Could not load more orders",
          type: AppSnackBarType.error);
    }

    setState(() {
      isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          WidgetAppBar(
            showBackButton: false,
            title: 'My Orders'.tr(),
            actions: [
              WidgetOverlayActions(
                inkwellBorderRadius: 8.sw,
                childBuilder: (isOpen) => Container(
                  width: 40,
                  height: 36,
                  decoration: BoxDecoration(
                    color: appColorBackground3,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: WidgetAppSVG(
                      isOpen || orderStatus != null ? 'icon94' : 'icon95',
                      width: 24.sw,
                      height: 24.sw),
                ),
                builder: (child, size, childPosition, pointerPosition,
                    animationValue, hide) {
                  return Positioned(
                    top: childPosition.dy + size.height + 2,
                    right: 12,
                    child: Transform.scale(
                      scaleY: animationValue,
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: 4.sw),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        width: 160,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 12,
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                                WidgetInkWellTransparent(
                                  enableInkWell: false,
                                  onTap: () async {
                                    await hide();
                                    orderStatus = null;
                                    setState(() {});
                                    _fetchOrders();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    child: Row(
                                      children: [
                                        Text(
                                          "All".tr(),
                                          style: w400TextStyle(
                                            fontSize: 16.sw,
                                            color: orderStatus == null
                                                ? appColorPrimary
                                                : appColorText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ] +
                              [
                                AppOrderProcessStatus.pending,
                                AppOrderProcessStatus.completed,
                                AppOrderProcessStatus.cancelled
                              ]
                                  .map(
                                    (e) => WidgetInkWellTransparent(
                                      enableInkWell: false,
                                      onTap: () async {
                                        await hide();
                                        orderStatus = e;
                                        setState(() {});
                                        _fetchOrders();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        child: Row(
                                          children: [
                                            Text(
                                              e.friendlyName,
                                              style: w400TextStyle(
                                                fontSize: 16.sw,
                                                color: orderStatus == e
                                                    ? appColorPrimary
                                                    : appColorText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
          Expanded(
            child: orders == null ? _buildShimmerLoading() : _buildOrdersList(),
          ),
        ],
      ),
    );
  }

  // Widget shimmer loading
  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Hiển thị 5 shimmer cards
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildShimmerCard(),
        );
      },
    );
  }

  // Widget shimmer card
  Widget _buildShimmerCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F8F6),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 120,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 80,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Title shimmer
          Container(
            width: double.infinity,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),

          // Address shimmer
          Container(
            width: 200,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),

          // Delivery info card shimmer
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),

          // Buttons shimmer
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget orders list với pagination
  Widget _buildOrdersList() {
    if (orders!.isEmpty) {
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
              orderStatus == null
                  ? 'You don\'t have any orders at this time'.tr()
                  : 'You don\'t have any "${orderStatus?.friendlyName}"\norders at this time'
                      .tr(),
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
                text: 'Order Now'.tr(),
                borderRadius: 120,
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: orders!.length + (hasMoreData || isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Kiểm tra bounds để tránh lỗi RangeError
        if (index >= orders!.length) {
          // Nếu đang load more, hiển thị shimmer loading
          if (isLoadingMore) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildShimmerCard(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildShimmerCard(),
                ),
                SizedBox(
                  height: 120 + MediaQuery.of(context).padding.bottom,
                )
              ],
            );
          } else if (hasMoreData) {
            // Placeholder cho trigger load more
            return SizedBox(
              height: 120 + MediaQuery.of(context).padding.bottom,
            );
          } else {
            // Kết thúc list với padding bottom
            return SizedBox(
              height: 120 + MediaQuery.of(context).padding.bottom,
            );
          }
        }

        // Kiểm tra index hợp lệ trước khi truy cập orders
        if (index < 0 || index >= orders!.length) {
          return const SizedBox
              .shrink(); // Return empty widget nếu index không hợp lệ
        }

        // Hiển thị order card
        final order = orders![index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _OrderCard(m: order, refreshCallback: _fetchOrders),
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel m;
  final VoidCallback refreshCallback;

  const _OrderCard({
    super.key,
    required this.m,
    required this.refreshCallback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        appHaptic();
        pushWidget(
          child: WidgetOrderDetail(m: m),
        );
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 361),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F8F6),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with order ID and date/time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    m.code ?? '',
                    style: w400TextStyle(
                      color: appColorPrimaryOrange,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  m.timeOrder ?? '',
                  style: w400TextStyle(
                    color: const Color(0xFF3C3836),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Order details section
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Order title and address
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.store?.name ?? '',
                      style: w400TextStyle(
                        color: const Color(0xFF120F0F),
                        fontSize: 18,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      m.store?.address ?? '',
                      style: w400TextStyle(
                        color: const Color(0xFF847D79),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Delivery information card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Delivery person section
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              'Driver'.tr(),
                              style: w400TextStyle(
                                color: appColorText2,
                                fontSize: 12,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              m.deliveryTypeEnum == AppOrderDeliveryType.ship
                                  ? m.driver?.name ?? ''
                                  : 'You Pickup'.tr(),
                              textAlign: TextAlign.center,
                              style: w400TextStyle(
                                fontSize: 14,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Vertical divider
                      Container(
                        width: 1,
                        height: 40,
                        color: const Color(0xFFF1EFE9),
                      ),

                      // Order status section
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Text(
                              'Order Status'.tr(),
                              style: w400TextStyle(
                                color: appColorText2,
                                fontSize: 12,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              m.processStatus?.toUpperCase() ?? '',
                              textAlign: TextAlign.center,
                              style: w400TextStyle(
                                color: appColorPrimary,
                                fontSize: 14,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Vertical divider
                      Container(
                        width: 1,
                        height: 40,
                        color: const Color(0xFFF1EFE9),
                      ),

                      // Amount section
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              'Amount'.tr(),
                              style: w400TextStyle(
                                color: appColorText2,
                                fontSize: 12,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currencyFormatted(m.total ?? 0),
                              textAlign: TextAlign.center,
                              style: w500TextStyle(
                                color: appColorPrimaryOrange,
                                fontSize: 14,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (m.processStatusEnum == AppOrderProcessStatus.completed) ...[
                  const SizedBox(height: 16),

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
                              refreshCallback();
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
                                color: appColorPrimaryOrange.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  m.rating?.store?.star.toString() ?? "0.0",
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
          ],
        ),
      ),
    );
  }
}
