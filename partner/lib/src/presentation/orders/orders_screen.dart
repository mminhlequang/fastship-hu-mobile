import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:app/src/network_resources/order/models/order.dart';
import 'package:app/src/network_resources/order/repo.dart';
import 'package:app/src/presentation/widgets/widget_app_divider.dart';
import 'package:app/src/presentation/widgets/widget_app_tabbar.dart';
import 'package:app/src/presentation/widgets/widget_order_shimmer.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/setup/app_textstyles.dart';
import 'package:internal_core/widgets/widgets.dart';

enum OrderStatus {
  preOrder,
  newOrder,
  confirmed,
  completed,
  canceled;

  String get title => switch (this) {
        preOrder => 'Pre-order'.tr(),
        newOrder => 'New'.tr(),
        confirmed => 'Confirmed'.tr(),
        completed => 'Completed'.tr(),
        canceled => 'Canceled'.tr(),
      };

  String get apiStatus => switch (this) {
        preOrder => 'pre_order',
        newOrder => 'new',
        confirmed => 'confirmed',
        completed => 'completed',
        canceled => 'canceled',
      };
}

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final OrderRepo _orderRepo = OrderRepo();
  OrderStatus _currentStatus = OrderStatus.preOrder;
  bool _isLoading = true;
  List<OrderModel> _orders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
      final response = await _orderRepo.getOrders({
        'status': _currentStatus.apiStatus,
      });

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
      physics: const NeverScrollableScrollPhysics(),
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      onTap: (index) {
        setState(() {
          _currentStatus = OrderStatus.values[index];
        });
        _loadData();
      },
      tabs: OrderStatus.values.map((e) => e.title).toList(),
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
                    return WidgetRippleButton(
                      onTap: () =>
                          appContext.push('/detail-order', extra: order),
                      radius: 8.sw,
                      child: Padding(
                        padding: EdgeInsets.all(12.sw),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#${order.code}',
                              style: w600TextStyle(
                                  fontSize: 16.sw, color: appColorPrimary),
                            ),
                            Gap(2.sw),
                            Text(
                              '${'Delivery at'.tr()} ${order.deliveryTime}',
                              style:
                                  w400TextStyle(fontSize: 12.sw, color: grey1),
                            ),
                            Gap(16.sw),
                            Text(
                              order.store?.name ?? '',
                              style: w400TextStyle(),
                            ),
                            _divider,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Status'.tr(),
                                  style: w400TextStyle(),
                                ),
                                Text(
                                  order.status ?? '',
                                  style: w400TextStyle(),
                                ),
                              ],
                            ),
                            _divider,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${order.itemCount} ${'items'.tr()}',
                                  style: w400TextStyle(),
                                ),
                                Text(
                                  '\$${order.finalAmount}',
                                  style: w400TextStyle(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
  }

  Widget get _divider => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.sw),
        child: const AppDivider(),
      );
}
