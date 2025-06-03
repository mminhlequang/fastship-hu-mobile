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

class _DetailOrderScreenState extends State<DetailOrderScreen>
    with TickerProviderStateMixin {
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  OrderModel? order;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _fetchOrder();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _notifyToDriver() {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    socketController.updateStoreStatus(widget.id, AppOrderStoreStatus.completed,
        onSuccess: () {
      appShowSnackBar(
          msg: 'Order ready to pick up'.tr(), type: AppSnackBarType.success);
      _fetchOrder();
    });
  }

  Future<void> _fetchOrder() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      final response = await OrderRepo().getOrderDetail({"id": widget.id});

      if (!mounted) return;

      if (response.data != null) {
        setState(() {
          order = response.data;
          isLoading = false;
          hasError = false;
        });
        _animationController.forward();
      } else {
        throw Exception('Order not found');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = e.toString();
      });
    }
  }

  // Helper methods for order status display
  OrderStatusInfo _getStatusInfo(AppOrderStoreStatus status) {
    switch (status) {
      case AppOrderStoreStatus.pending:
        return OrderStatusInfo(
          color: orderStatusNew,
          text: 'Pending'.tr(),
          icon: Icons.access_time,
          description: 'Order is waiting for preparation',
        );
      case AppOrderStoreStatus.completed:
        return OrderStatusInfo(
          color: orderStatusCompleted,
          text: 'Completed'.tr(),
          icon: Icons.check_circle,
          description: 'Order has been completed successfully',
        );
      case AppOrderStoreStatus.rejected:
        return OrderStatusInfo(
          color: orderStatusCanceled,
          text: 'Rejected'.tr(),
          icon: Icons.cancel,
          description: 'Order has been rejected',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorBackground,
      appBar: AppBar(
        title: Text('Order details'.tr()),
        // backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            appHaptic();
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildBody(),
          ),
          if (!isLoading && !hasError && order != null) _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (hasError || order == null) {
      return _buildErrorState();
    }

    return _buildOrderContent();
  }

  Widget _buildLoadingState() {
    return _buildShimmer();
  }

  Widget _buildErrorState() {
    return Center(
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
            "Failed to load order details".tr(),
            style: w600TextStyle(fontSize: 18.sw),
          ),
          Gap(8.sw),
          Text(
            errorMessage.isNotEmpty ? errorMessage : "Please try again".tr(),
            style: w400TextStyle(color: grey1, fontSize: 14.sw),
            textAlign: TextAlign.center,
          ),
          Gap(24.sw),
          WidgetRippleButton(
            onTap: _fetchOrder,
            color: appColorPrimary,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.sw, vertical: 12.sw),
              child: Text(
                "Retry".tr(),
                style: w500TextStyle(color: Colors.white, fontSize: 14.sw),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: RefreshIndicator(
          onRefresh: _fetchOrder,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusSection(),
                _buildLocationSection(),
                _buildContactSection(),
                _buildOrderItemsSection(),
                _buildOrderSummarySection(),
                _buildOrderInfoSection(),
                Gap(100.sw), // Space for bottom actions
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    final statusInfo = _getStatusInfo(order!.storeStatusEnum);

    return Container(
      margin: EdgeInsets.all(16.sw),
      padding: EdgeInsets.all(20.sw),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusInfo.color.withOpacity(0.1),
            statusInfo.color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.sw),
        border: Border.all(color: statusInfo.color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.sw),
                decoration: BoxDecoration(
                  color: statusInfo.color,
                  borderRadius: BorderRadius.circular(12.sw),
                ),
                child: Icon(
                  statusInfo.icon,
                  color: Colors.white,
                  size: 24.sw,
                ),
              ),
              Gap(16.sw),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order!.code}',
                      style: w700TextStyle(
                          fontSize: 18.sw, color: statusInfo.color),
                    ),
                    Gap(4.sw),
                    Text(
                      statusInfo.description,
                      style: w400TextStyle(fontSize: 14.sw, color: grey1),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.sw, vertical: 8.sw),
                decoration: BoxDecoration(
                  color: statusInfo.color,
                  borderRadius: BorderRadius.circular(20.sw),
                ),
                child: Text(
                  statusInfo.text,
                  style: w600TextStyle(fontSize: 12.sw, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.sw),
      padding: EdgeInsets.all(20.sw),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.sw),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.sw,
            offset: Offset(0, 2.sw),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Information'.tr(),
            style: w600TextStyle(fontSize: 16.sw),
          ),
          Gap(16.sw),
          Stack(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 30.sw),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLocationItem(
                      title: 'Store'.tr(),
                      address: order!.store?.name ?? '',
                      subtitle: order!.store?.address ?? '',
                      isStore: true,
                    ),
                    Gap(24.sw),
                    _buildLocationItem(
                      title:
                          order!.deliveryTypeEnum == AppOrderDeliveryType.ship
                              ? 'Delivery Address'.tr()
                              : 'Pickup Location'.tr(),
                      address:
                          order!.deliveryTypeEnum == AppOrderDeliveryType.ship
                              ? (order!.address ?? "")
                              : 'Customer will pickup at store'.tr(),
                      subtitle: order!.customer?.name ?? '',
                      isStore: false,
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 2,
                top: 8.sw,
                bottom: 8.sw,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 4.sw,
                      backgroundColor: appColorPrimary,
                    ),
                    Expanded(
                      child: DottedLine(
                        direction: Axis.vertical,
                        lineThickness: 2,
                        dashLength: 4,
                        dashColor: appColorPrimary,
                      ),
                    ),
                    Icon(
                      order!.deliveryTypeEnum == AppOrderDeliveryType.ship
                          ? Icons.location_on
                          : Icons.store,
                      color: appColorPrimary,
                      size: 16.sw,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Additional delivery info for shipping orders
          if (order!.deliveryTypeEnum == AppOrderDeliveryType.ship) ...[
            Gap(20.sw),
            const Divider(),
            Gap(12.sw),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (order!.shipDistance != null)
                  _buildInfoChip(
                    icon: Icons.location_on_outlined,
                    label: 'Distance'.tr(),
                    value: '${order!.shipDistance}km',
                  ),
                if (order!.timePickupEstimate != null)
                  _buildInfoChip(
                    icon: Icons.access_time,
                    label: 'Est. Pickup'.tr(),
                    value: order!.timePickupEstimate!,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationItem({
    required String title,
    required String address,
    required String subtitle,
    required bool isStore,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: w600TextStyle(fontSize: 14.sw, color: appColorPrimary),
            ),
            Gap(8.sw),
            Icon(
              isStore ? Icons.store : Icons.person,
              size: 16.sw,
              color: appColorPrimary,
            ),
          ],
        ),
        Gap(4.sw),
        Text(
          address,
          style: w500TextStyle(fontSize: 14.sw),
        ),
        if (subtitle.isNotEmpty) ...[
          Gap(2.sw),
          Text(
            subtitle,
            style: w400TextStyle(fontSize: 12.sw, color: grey1),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sw, vertical: 8.sw),
      decoration: BoxDecoration(
        color: appColorPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.sw),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sw, color: appColorPrimary),
          Gap(4.sw),
          Text(
            label,
            style: w400TextStyle(fontSize: 10.sw, color: grey1),
          ),
          Text(
            value,
            style: w600TextStyle(fontSize: 12.sw, color: appColorPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    if (order!.customer == null && order!.driver == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(16.sw),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.sw),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.sw,
            offset: Offset(0, 2.sw),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.sw),
            child: Text(
              'Contact Information'.tr(),
              style: w600TextStyle(fontSize: 16.sw),
            ),
          ),
          if (order!.customer != null) ...[
            _buildContactItem(
              avatar: order!.customer?.avatar ?? '',
              name: order!.customer?.name ?? '',
              phone: order!.customer?.phone ?? '',
              role: 'Customer'.tr(),
              onCall: () => makePhoneCall(order!.customer?.phone ?? ''),
            ),
          ],
          if (order!.driver != null) ...[
            if (order!.customer != null) const Divider(),
            _buildContactItem(
              avatar: order!.driver?.avatar ?? '',
              name: order!.driver?.name ?? '',
              phone: order!.driver?.phone ?? '',
              role: 'Driver'.tr(),
              onCall: () => makePhoneCall(order!.driver?.phone ?? ''),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required String avatar,
    required String name,
    required String phone,
    required String role,
    required VoidCallback onCall,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sw, vertical: 12.sw),
      child: Row(
        children: [
          WidgetAvatar.withoutBorder(
            imageUrl: avatar,
            radius: 24.sw,
          ),
          Gap(12.sw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: w600TextStyle(fontSize: 14.sw),
                    ),
                    Gap(8.sw),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.sw, vertical: 2.sw),
                      decoration: BoxDecoration(
                        color: appColorPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.sw),
                      ),
                      child: Text(
                        role,
                        style: w500TextStyle(
                            fontSize: 10.sw, color: appColorPrimary),
                      ),
                    ),
                  ],
                ),
                Gap(4.sw),
                Text(
                  phone,
                  style: w400TextStyle(fontSize: 12.sw, color: grey1),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              appHaptic();
              onCall();
            },
            child: Container(
              padding: EdgeInsets.all(10.sw),
              decoration: BoxDecoration(
                color: appColorPrimary,
                borderRadius: BorderRadius.circular(12.sw),
              ),
              child: Icon(
                Icons.call,
                color: Colors.white,
                size: 18.sw,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsSection() {
    if (order!.items?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.sw),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.sw),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.sw,
            offset: Offset(0, 2.sw),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.sw),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Items'.tr(),
                  style: w600TextStyle(fontSize: 16.sw),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.sw, vertical: 6.sw),
                  decoration: BoxDecoration(
                    color: appColorPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.sw),
                  ),
                  child: Text(
                    '${order!.items?.length ?? 0} ${'items'.tr()}',
                    style:
                        w500TextStyle(fontSize: 12.sw, color: appColorPrimary),
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.sw),
            itemCount: order!.items?.length ?? 0,
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 8.sw),
              child: const Divider(),
            ),
            itemBuilder: (context, index) {
              final item = order!.items![index];
              return _buildOrderItem(item);
            },
          ),
          Gap(20.sw),
        ],
      ),
    );
  }

  Widget _buildOrderItem(dynamic item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.sw),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Container(
            width: 60.sw,
            height: 60.sw,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.sw),
              color: grey8,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.sw),
              child: item?.product?.image != null
                  ? WidgetAppImage(
                      imageUrl: item.product.image,
                      width: 60.sw,
                      height: 60.sw,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.fastfood,
                      color: grey1,
                      size: 24.sw,
                    ),
            ),
          ),
          Gap(12.sw),
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product?.name ?? '',
                  style: w600TextStyle(fontSize: 14.sw),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Gap(4.sw),
                if (item.product?.description != null) ...[
                  Text(
                    item.product!.description!,
                    style: w400TextStyle(fontSize: 12.sw, color: grey1),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(8.sw),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.sw, vertical: 4.sw),
                      decoration: BoxDecoration(
                        color: appColorPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.sw),
                      ),
                      child: Text(
                        'x${item.quantity ?? 0}',
                        style: w600TextStyle(
                            fontSize: 12.sw, color: appColorPrimary),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          currencyFormatted(item.price ?? 0),
                          style: w500TextStyle(fontSize: 12.sw, color: grey1),
                        ),
                        Text(
                          currencyFormatted(
                              (item.price ?? 0) * (item.quantity ?? 1)),
                          style:
                              w600TextStyle(fontSize: 14.sw, color: darkGreen),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummarySection() {
    return Container(
      margin: EdgeInsets.all(16.sw),
      padding: EdgeInsets.all(20.sw),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.sw),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.sw,
            offset: Offset(0, 2.sw),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary'.tr(),
            style: w600TextStyle(fontSize: 16.sw),
          ),
          Gap(16.sw),
          Container(
            padding: EdgeInsets.all(16.sw),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  darkGreen.withOpacity(0.1),
                  darkGreen.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.sw),
              border: Border.all(color: darkGreen.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount'.tr(),
                      style: w400TextStyle(fontSize: 14.sw, color: grey1),
                    ),
                    Text(
                      '${order!.items?.length ?? 0} ${'dishes'.tr()}',
                      style: w500TextStyle(fontSize: 12.sw, color: darkGreen),
                    ),
                  ],
                ),
                Text(
                  currencyFormatted(order!.total ?? 0),
                  style: w700TextStyle(fontSize: 20.sw, color: darkGreen),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfoSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.sw),
      padding: EdgeInsets.all(20.sw),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.sw),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.sw,
            offset: Offset(0, 2.sw),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Information'.tr(),
            style: w600TextStyle(fontSize: 16.sw),
          ),
          Gap(16.sw),
          _buildInfoRow(
            label: 'Order code'.tr(),
            value: order!.code ?? '',
            isCopiable: true,
          ),
          _buildInfoRow(
            label: 'Order time'.tr(),
            value: order!.timeOrder ?? '',
          ),
          if (order!.deliveryTypeEnum == AppOrderDeliveryType.ship) ...[
            if (order!.shipDistance != null)
              _buildInfoRow(
                label: 'Distance'.tr(),
                value: '${order!.shipDistance}km',
              ),
            if (order!.timePickupEstimate != null)
              _buildInfoRow(
                label: 'Estimated pick up time'.tr(),
                value: order!.timePickupEstimate!,
              ),
            if (order!.timePickup != null)
              _buildInfoRow(
                label: 'Pick up time'.tr(),
                value: order!.timePickup!,
              ),
            if (order!.timeDelivery != null)
              _buildInfoRow(
                label: 'Delivery time'.tr(),
                value: order!.timeDelivery!,
              ),
          ] else ...[
            if (order!.timeDelivery != null)
              _buildInfoRow(
                label: 'Pickup time'.tr(),
                value: order!.timeDelivery!,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    bool isCopiable = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sw),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: w400TextStyle(fontSize: 14.sw, color: grey1),
          ),
          GestureDetector(
            onTap: isCopiable
                ? () {
                    appHaptic();
                    copyToClipboard(value);
                  }
                : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: w500TextStyle(
                    fontSize: 14.sw,
                    color: isCopiable ? blue1 : appColorText,
                  ),
                ),
                if (isCopiable) ...[
                  Gap(4.sw),
                  Icon(
                    Icons.copy,
                    size: 16.sw,
                    color: blue1,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    final canMarkAsReady =
        order!.storeStatusEnum.index < AppOrderStoreStatus.completed.index &&
            order!.processStatusEnum.index <
                AppOrderProcessStatus.driverPicked.index;

    if (!canMarkAsReady) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.fromLTRB(
        16.sw,
        12.sw,
        16.sw,
        12.sw + context.mediaQueryPadding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.sw,
            offset: Offset(0, -2.sw),
          ),
        ],
      ),
      child: SafeArea(
        child: WidgetRippleButton(
          onTap: _notifyToDriver,
          color: appColorPrimary,
          child: Container(
            height: 48.sw,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 20.sw,
                      height: 20.sw,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Mark as Ready'.tr(),
                      style:
                          w600TextStyle(fontSize: 16.sw, color: Colors.white),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return shimmer.Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status section shimmer
            Container(
              margin: EdgeInsets.all(16.sw),
              padding: EdgeInsets.all(20.sw),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.sw),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.sw,
                    height: 48.sw,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.sw),
                    ),
                  ),
                  Gap(16.sw),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 200.sw,
                          height: 18.sw,
                          color: Colors.white,
                        ),
                        Gap(8.sw),
                        Container(
                          width: 150.sw,
                          height: 14.sw,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 80.sw,
                    height: 32.sw,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.sw),
                    ),
                  ),
                ],
              ),
            ),

            // Location section shimmer
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.sw),
              padding: EdgeInsets.all(20.sw),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.sw),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150.sw,
                    height: 16.sw,
                    color: Colors.white,
                  ),
                  Gap(16.sw),
                  Container(
                    height: 100.sw,
                    color: Colors.white,
                  ),
                ],
              ),
            ),

            Gap(16.sw),

            // Order items section shimmer
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.sw),
              padding: EdgeInsets.all(20.sw),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.sw),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100.sw,
                        height: 16.sw,
                        color: Colors.white,
                      ),
                      Container(
                        width: 60.sw,
                        height: 24.sw,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Gap(16.sw),
                  ...List.generate(
                      3,
                      (index) => Padding(
                            padding: EdgeInsets.only(bottom: 16.sw),
                            child: Row(
                              children: [
                                Container(
                                  width: 60.sw,
                                  height: 60.sw,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.sw),
                                  ),
                                ),
                                Gap(12.sw),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 16.sw,
                                        color: Colors.white,
                                      ),
                                      Gap(8.sw),
                                      Container(
                                        width: 100.sw,
                                        height: 14.sw,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class for order status information
class OrderStatusInfo {
  final Color color;
  final String text;
  final IconData icon;
  final String description;

  OrderStatusInfo({
    required this.color,
    required this.text,
    required this.icon,
    required this.description,
  });
}
