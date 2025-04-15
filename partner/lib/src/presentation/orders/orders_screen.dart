import 'package:app/src/base/bloc.dart';
import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:internal_core/setup/app_utils.dart';
import 'package:network_resources/enums.dart';
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
import 'package:internal_core/setup/app_textstyles.dart';
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
  Map<String, String> _mapParamByStatus = {};
  List<OrderModel> _orders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        _mapParamByStatus = switch (index) {
          0 => {"store_status": AppOrderStoreStatus.pending.name},
          1 => {"store_status": AppOrderStoreStatus.accepted.name},
          2 => {"store_status": AppOrderStoreStatus.completed.name},
          3 => {"store_status": AppOrderStoreStatus.rejected.name},
          _ => {},
        };
        _loadData();
      },
      tabs: ["New", "Processing", "Completed", "Canceled"],
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
        color = Colors.yellow;
        statusText = 'Pending';
        description = 'New order at ${order.timeOrder}';
      case AppOrderStoreStatus.accepted:
        color = Colors.green;
        statusText = 'Accepted';
        description = 'Order is being processed';
      case AppOrderStoreStatus.rejected:
        color = Colors.red;
        statusText = 'Rejected';
        description = 'Order is rejected';
      case AppOrderStoreStatus.completed:
        color = Colors.blue;
        statusText = 'Completed';
        description = 'Order is completed';
    }
    return GestureDetector(
      onTap: () {
        appHaptic();
        appContext.push('/detail-order', extra: order.id);
      },
      child: Container(
        padding: EdgeInsets.all(12.sw),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.sw),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '#${order.code}',
              style: w600TextStyle(fontSize: 16.sw, color: color),
            ),
            Gap(2.sw),
            Text(
              description,
              style: w400TextStyle(fontSize: 12.sw, color: grey1),
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
                  statusText ?? '',
                  style: w400TextStyle(
                    color: color,
                  ),
                ),
              ],
            ),
            _divider,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.items?.length} ${'items'.tr()}',
                  style: w400TextStyle(),
                ),
                Text(
                  '\$${order.total}',
                  style: w400TextStyle(),
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
