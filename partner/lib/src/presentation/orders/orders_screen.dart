import 'package:app/src/base/bloc.dart';
import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:internal_core/internal_core.dart';
import 'package:network_resources/network_resources.dart';
import 'package:network_resources/order/models/order.dart';
import 'package:network_resources/order/repo.dart';
import 'package:app/src/presentation/widgets/widget_app_divider.dart';
import 'package:app/src/presentation/widgets/widget_app_tabbar.dart';
import 'package:app/src/presentation/widgets/widget_order_shimmer.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_core/widgets/widgets.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isLoading = true;
  Map<String, String> get _mapParamByStatus => switch (_tabController.index) {
        0 => {"store_status": AppOrderStoreStatus.pending.name},
        1 => {"store_status": AppOrderStoreStatus.completed.name},
        2 => {"store_status": AppOrderStoreStatus.rejected.name},
        _ => {},
      };
  List<OrderModel> _orders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> params = {
        'store_id': authCubit.storeId,
      };
      params.addAll(_mapParamByStatus);
      final response = await OrderRepo().getOrdersByStore(params);

      if (response.data != null) {
        setState(() {
          _orders = response.data;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WidgetAppTabBar(
      tabController: _tabController,
      // physics: const NeverScrollableScrollPhysics(),
      isScrollable: true,
      tabAlignment: TabAlignment.center,
      onTap: (index) {
        setState(() {});

        _loadData();
      },

      tabs: ["New/Processing", "Completed", "Canceled"],
      tabColors: [
        orderStatusNew,
        // orderStatusProcessing,
        orderStatusCompleted,
        orderStatusCanceled,
      ],
      body: _ordersByStatus,
    );
  }

  Widget get _ordersByStatus {
    return _isLoading
        ? ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
            itemCount: 3,
            separatorBuilder: (context, index) => Gap(8.sw),
            itemBuilder: (context, index) => const WidgetOrderShimmer(),
          )
        : _orders.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const WidgetAppSVG('ic_empty_order'),
                  Gap(16.sw),
                  Text(
                    "There's nothing here...yet".tr(),
                    style: w500TextStyle(fontSize: 18.sw),
                  ),
                  Gap(4.sw),
                  Text(
                    "We'll let you know when you have new order".tr(),
                    style: w400TextStyle(color: grey1),
                  ),
                ],
              )
            : RefreshIndicator(
                onRefresh: _loadData,
                child: ListView.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
                  itemCount: _orders.length,
                  separatorBuilder: (context, index) => Gap(8.sw),
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    return _buildItem(order);
                  },
                ),
              );
  }

  Widget _buildItem(OrderModel order) {
    Color? color;
    String? statusText;
    String? description;

    switch (order.storeStatusEnum) {
      case AppOrderStoreStatus.pending:
        color = orderStatusNew;
        statusText = 'Pending';
        description = 'Order at ${order.timeOrder}';
      // case AppOrderStoreStatus.accepted:
      //   color = orderStatusProcessing;
      //   statusText = 'Accepted';
      //   description = 'Order is being processed';
      case AppOrderStoreStatus.rejected:
        color = orderStatusCanceled;
        statusText = 'Rejected';
        description = 'Order is rejected';
      case AppOrderStoreStatus.completed:
        color = orderStatusCompleted;
        statusText = 'Completed';
        description = 'Order is completed';
    }
    return GestureDetector(
      onTap: () async {
        appHaptic();
        await appContext.push('/detail-order', extra: order.id);
        _loadData();
      },
      child: Container(
        padding: EdgeInsets.all(12.sw),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.sw),
          border: Border.all(color: grey8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header với order code và status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${order.code}',
                  style: w600TextStyle(fontSize: 16.sw, color: color),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.sw, vertical: 4.sw),
                  decoration: BoxDecoration(
                    color: color?.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.sw),
                    border: Border.all(color: color ?? Colors.grey),
                  ),
                  child: Text(
                    statusText ?? '',
                    style: w500TextStyle(fontSize: 10.sw, color: color),
                  ),
                ),
              ],
            ),
            Gap(2.sw),
            Text(
              description,
              style: w400TextStyle(fontSize: 12.sw, color: grey1),
            ),
            Gap(12.sw),

            // Customer info
            if (order.customer?.name != null) ...[
              Row(
                children: [
                  Icon(Icons.person_outline, size: 16.sw, color: grey1),
                  Gap(6.sw),
                  Expanded(
                    child: Text(
                      order.customer?.name ?? '',
                      style: w400TextStyle(fontSize: 13.sw),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Gap(8.sw),
            ],

            // Delivery info for shipping orders
            if (order.deliveryTypeEnum == AppOrderDeliveryType.ship &&
                order.timePickupEstimate != null) ...[
              Row(
                children: [
                  Icon(Icons.access_time, size: 16.sw, color: grey1),
                  Gap(6.sw),
                  Expanded(
                    child: Text(
                      'Est. pickup: ${order.timePickupEstimate}',
                      style: w400TextStyle(fontSize: 13.sw, color: grey1),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Gap(8.sw),
            ],

            // Distance for shipping orders
            if (order.deliveryTypeEnum == AppOrderDeliveryType.ship &&
                order.shipDistance != null &&
                order.shipDistance! > 0) ...[
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16.sw, color: grey1),
                  Gap(6.sw),
                  Text(
                    '${order.shipDistance}km',
                    style: w400TextStyle(fontSize: 13.sw, color: grey1),
                  ),
                ],
              ),
              Gap(8.sw),
            ],

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery type'.tr(),
                  style: w400TextStyle(),
                ),
                Row(
                  children: [
                    Icon(
                      order.deliveryTypeEnum == AppOrderDeliveryType.ship
                          ? Icons.delivery_dining
                          : Icons.store,
                      size: 16.sw,
                      color: color,
                    ),
                    Gap(4.sw),
                    Text(
                      order.deliveryTypeEnum == AppOrderDeliveryType.ship
                          ? 'Delivery'
                          : 'Pickup',
                      style: w400TextStyle(color: color),
                    ),
                  ],
                ),
              ],
            ),
            _divider,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Processing status'.tr(),
                  style: w400TextStyle(),
                ),
                Text(
                  order.processStatusEnum.name,
                  style: w400TextStyle(color: color),
                ),
              ],
            ),
            _divider,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.items?.length ?? 0} ${'items'.tr()}',
                  style: w400TextStyle(),
                ),
                Text(
                  currencyFormatted(order.total ?? 0),
                  style: w600TextStyle(fontSize: 16.sw, color: darkGreen),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get _divider => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.sw),
        child: const AppDivider(),
      );
}
