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
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

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
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      Map<String, dynamic> params = {
        'store_id': authCubit.storeId,
      };
      params.addAll(_mapParamByStatus);
      final response = await OrderRepo().getOrdersByStore(params);

      if (!mounted) return;

      if (response.data != null) {
        setState(() {
          _orders = response.data;
          _isLoading = false;
          _hasError = false;
        });
        _animationController.forward();
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
      debugPrint('Error loading orders: $e');
    }
  }

  // Helper methods for better status handling
  OrderStatusData _getOrderStatusData(AppOrderStoreStatus status) {
    switch (status) {
      case AppOrderStoreStatus.pending:
        return OrderStatusData(
          color: orderStatusNew,
          text: 'Pending'.tr(),
          icon: Icons.access_time,
          description: 'New order waiting for preparation',
        );
      case AppOrderStoreStatus.completed:
        return OrderStatusData(
          color: orderStatusCompleted,
          text: 'Completed'.tr(),
          icon: Icons.check_circle,
          description: 'Order has been completed successfully',
        );
      case AppOrderStoreStatus.rejected:
        return OrderStatusData(
          color: orderStatusCanceled,
          text: 'Rejected'.tr(),
          icon: Icons.cancel,
          description: 'Order has been rejected',
        );
    }
  }

  String _getTabTitle(int index) {
    switch (index) {
      case 0:
        return "New/Processing".tr();
      case 1:
        return "Completed".tr();
      case 2:
        return "Canceled".tr();
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorBackground,
      body: WidgetAppTabBar(
        tabController: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.center,
        indicatorColor: _tabController.index == 0
            ? orderStatusNew
            : _tabController.index == 1
                ? orderStatusCompleted
                : orderStatusCanceled,
        onTap: (index) {
          appHaptic();
          _animationController.reset();
          _loadData();
        },
        tabs: [
          _getTabTitle(0),
          _getTabTitle(1),
          _getTabTitle(2),
        ],
        tabColors: [
          orderStatusNew,
          orderStatusCompleted,
          orderStatusCanceled,
        ],
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_hasError) {
      return _buildErrorState();
    }

    if (_orders.isEmpty) {
      return _buildEmptyState();
    }

    return _buildOrdersList();
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
      itemCount: 5,
      separatorBuilder: (context, index) => Gap(12.sw),
      itemBuilder: (context, index) => const WidgetOrderShimmer(),
    );
  }

  Widget _buildErrorState() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.sw,
                color: orderStatusCanceled,
              ),
              Gap(16.sw),
              Text(
                "Something went wrong".tr(),
                style: w600TextStyle(fontSize: 18.sw),
              ),
              Gap(8.sw),
              Text(
                "Please pull down to refresh".tr(),
                style: w400TextStyle(color: grey1, fontSize: 14.sw),
                textAlign: TextAlign.center,
              ),
              Gap(24.sw),
              WidgetRippleButton(
                onTap: _loadData,
                color: appColorPrimary,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.sw, vertical: 12.sw),
                  child: Text(
                    "Try again".tr(),
                    style: w500TextStyle(color: Colors.white, fontSize: 14.sw),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const WidgetAppSVG('ic_empty_order'),
              Gap(24.sw),
              Text(
                "There's nothing here...yet".tr(),
                style: w600TextStyle(fontSize: 20.sw),
              ),
              Gap(8.sw),
              Text(
                "We'll let you know when you have new order".tr(),
                style: w400TextStyle(color: grey1, fontSize: 14.sw),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.sw, vertical: 12.sw),
          itemCount: _orders.length,
          separatorBuilder: (context, index) => Gap(12.sw),
          itemBuilder: (context, index) {
            final order = _orders[index];
            return _buildOrderItem(order, index);
          },
        ),
      ),
    );
  }

  Widget _buildOrderItem(OrderModel order, int index) {
    final statusData = _getOrderStatusData(order.storeStatusEnum);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () async {
          appHaptic();
          await appContext.push('/detail-order', extra: order.id);
          _loadData();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.sw),
            border: Border.all(color: grey8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8.sw,
                offset: Offset(0, 2.sw),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.sw),
            child: Column(
              children: [
                // Header với gradient background
                Container(
                  padding: EdgeInsets.all(16.sw),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        statusData.color.withOpacity(0.1),
                        statusData.color.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Order code và status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.sw),
                                decoration: BoxDecoration(
                                  color: statusData.color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8.sw),
                                ),
                                child: Icon(
                                  statusData.icon,
                                  size: 16.sw,
                                  color: statusData.color,
                                ),
                              ),
                              Gap(12.sw),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '#${order.code}',
                                    style: w600TextStyle(
                                        fontSize: 16.sw,
                                        color: statusData.color),
                                  ),
                                  Gap(2.sw),
                                  Text(
                                    'Order at ${order.timeOrder}',
                                    style: w400TextStyle(
                                        fontSize: 12.sw, color: grey1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.sw, vertical: 6.sw),
                            decoration: BoxDecoration(
                              color: statusData.color,
                              borderRadius: BorderRadius.circular(16.sw),
                            ),
                            child: Text(
                              statusData.text,
                              style: w500TextStyle(
                                  fontSize: 11.sw, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.all(16.sw),
                  child: Column(
                    children: [
                      // Customer info
                      if (order.customer?.name != null) ...[
                        _buildInfoRow(
                          icon: Icons.person_outline,
                          title: 'Customer'.tr(),
                          value: order.customer?.name ?? '',
                          color: grey1,
                        ),
                        Gap(12.sw),
                      ],

                      // Delivery type
                      _buildInfoRow(
                        icon:
                            order.deliveryTypeEnum == AppOrderDeliveryType.ship
                                ? Icons.delivery_dining
                                : Icons.store,
                        title: 'Delivery type'.tr(),
                        value:
                            order.deliveryTypeEnum == AppOrderDeliveryType.ship
                                ? 'Delivery'.tr()
                                : 'Pickup'.tr(),
                        color: statusData.color,
                      ),

                      // Distance for shipping orders
                      if (order.deliveryTypeEnum == AppOrderDeliveryType.ship &&
                          order.shipDistance != null &&
                          order.shipDistance! > 0) ...[
                        Gap(12.sw),
                        _buildInfoRow(
                          icon: Icons.location_on_outlined,
                          title: 'Distance'.tr(),
                          value: order.shipDistance != null
                              ? distanceFormatted(order.shipDistance!)
                              : 'Unknown'.tr(),
                          color: grey1,
                        ),
                      ],

                      // Pickup time for shipping orders
                      if (order.deliveryTypeEnum == AppOrderDeliveryType.ship &&
                          order.timePickupEstimate != null) ...[
                        Gap(12.sw),
                        _buildInfoRow(
                          icon: Icons.access_time,
                          title: 'Est. pickup'.tr(),
                          value: order.timePickupEstimate!,
                          color: grey1,
                        ),
                      ],

                      Gap(16.sw),

                      // Divider
                      Container(
                        height: 1.sw,
                        color: grey8,
                      ),

                      Gap(16.sw),

                      // Bottom row với items count và total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.sw, vertical: 4.sw),
                                decoration: BoxDecoration(
                                  color: appColorPrimary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.sw),
                                ),
                                child: Text(
                                  '${order.items?.length ?? 0} ${'items'.tr()}',
                                  style: w500TextStyle(
                                      fontSize: 12.sw, color: appColorPrimary),
                                ),
                              ),
                              Gap(8.sw),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.sw, vertical: 4.sw),
                                decoration: BoxDecoration(
                                  color: grey8,
                                  borderRadius: BorderRadius.circular(12.sw),
                                ),
                                child: Text(
                                  order.processStatusEnum.displayText,
                                  style: w400TextStyle(
                                      fontSize: 11.sw, color: grey1),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            currencyFormatted(order.total ?? 0),
                            style: w700TextStyle(
                                fontSize: 18.sw, color: darkGreen),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16.sw, color: color),
        Gap(8.sw),
        Text(
          '$title: ',
          style: w400TextStyle(fontSize: 13.sw, color: grey1),
        ),
        Expanded(
          child: Text(
            value,
            style: w500TextStyle(fontSize: 13.sw, color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Helper class for order status data
class OrderStatusData {
  final Color color;
  final String text;
  final IconData icon;
  final String description;

  OrderStatusData({
    required this.color,
    required this.text,
    required this.icon,
    required this.description,
  });
}

extension on AppOrderProcessStatus {
  String get displayText {
    switch (this) {
      case AppOrderProcessStatus.pending:
        return 'Pending'.tr();
      case AppOrderProcessStatus.findDriver:
        return 'Find driver'.tr();
      case AppOrderProcessStatus.driverAccepted:
        return 'Driver accepted'.tr();
      case AppOrderProcessStatus.storeAccepted:
        return 'Store accepted'.tr();
      case AppOrderProcessStatus.driverArrivedStore:
        return 'Driver arrived store'.tr();
      case AppOrderProcessStatus.driverPicked:
        return 'Driver picked'.tr();
      case AppOrderProcessStatus.driverArrivedDestination:
        return 'Driver arrived destination'.tr();
      case AppOrderProcessStatus.completed:
        return 'Completed'.tr();
      case AppOrderProcessStatus.cancelled:
        return 'Canceled'.tr();
    }
  }
}
