import 'dart:async';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_dialog_notification.dart';
import 'package:app/src/utils/app_map_helper.dart';
import 'package:app/src/utils/utils.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:latlong2/latlong.dart';
import 'package:network_resources/cart/models/models.dart';
import 'package:network_resources/network_resources.dart';
import 'package:network_resources/order/models/models.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../socket_shell/controllers/socket_controller.dart';
import '../widgets/widget_app_map.dart';
import '../widgets/widget_appbar.dart';

class CheckoutTrackingScreen extends StatefulWidget {
  final OrderModel? order;
  const CheckoutTrackingScreen({super.key, this.order});

  @override
  State<CheckoutTrackingScreen> createState() => _CheckoutTrackingScreenState();
}

class _CheckoutTrackingScreenState extends State<CheckoutTrackingScreen> {
  Completer<AnimatedMapController> mapController =
      Completer<AnimatedMapController>();

  final ScrollController _scrollController = ScrollController();
  final PanelController _panelController = PanelController();

  // ValueNotifier cho polylines
  final ValueNotifier<List<Polyline>> _polylinesNotifier =
      ValueNotifier<List<Polyline>>([]);

  OrderModel? get currentOrder => widget.order ?? socketController.currentOrder;
  bool get isPickup =>
      currentOrder?.deliveryTypeEnum == AppOrderDeliveryType.pickup;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < 0) {
        _panelController.close();
      } else if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent) {
        _panelController.open();
      }
    });
  }

  @override
  void dispose() {
    _polylinesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: socketController.statusStore,
        builder: (context, statusStore, child) {
          return ValueListenableBuilder(
              valueListenable: socketController.orderStatus,
              builder: (context, processStatus, child) {
                if (currentOrder == null) return SizedBox();
                OrderModel order = currentOrder!;
                return Scaffold(
                  body: Stack(
                    children: [
                      Column(
                        children: [
                          WidgetAppBar(
                            title: 'Order Tracking'.tr(),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  appHaptic();
                                  context.push('/help-center');
                                },
                                child: Text('Need help?'.tr(),
                                    style: w400TextStyle(
                                        fontSize: 16.sw,
                                        color: appColorPrimaryOrange)),
                              ),
                            ],
                          ),
                          Expanded(
                            child: ValueListenableBuilder(
                                valueListenable:
                                    socketController.driverLocation,
                                builder: (context, driverLocation, child) {
                                  // Chuyển đổi chuỗi polyline thành danh sách điểm LatLng
                                  List<LatLng> polylinePoints = [];
                                  if (order.shipPolyline?.isNotEmpty ?? false) {
                                    try {
                                      polylinePoints = FlexiblePolyline.decode(
                                              order.shipPolyline!)
                                          .map((e) => LatLng(e.lat, e.lng))
                                          .toList();
                                    } catch (e) {
                                      debugPrint('Error decoding polyline: $e');
                                    }
                                  }

                                  List<Marker> markers = [
                                    Marker(
                                      point: LatLng(
                                        order.store!.lat!,
                                        order.store!.lng!,
                                      ),
                                      width: 36.sw,
                                      height: 36.sw,
                                      child: AvatarGlow(
                                        glowColor: appColorPrimary,
                                        duration:
                                            const Duration(milliseconds: 2000),
                                        repeat: true,
                                        child: WidgetAvatar(
                                          imageUrl: order.store!.avatarImage,
                                          radius1: 18.sw,
                                          radius2: 18.sw - 2,
                                          radius3: 18.sw - 2,
                                          borderColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                    if (order.driver != null &&
                                        driverLocation != null)
                                      Marker(
                                        point: LatLng(
                                          driverLocation.latitude,
                                          driverLocation.longitude,
                                        ),
                                        width: 36.sw,
                                        height: 36.sw,
                                        child: WidgetAvatar(
                                          imageUrl: order.driver!.avatar ?? '',
                                          radius1: 18.sw,
                                          radius2: 18.sw - 2,
                                          radius3: 18.sw - 2,
                                          borderColor: Colors.white,
                                        ),
                                      ),
                                    Marker(
                                      point: LatLng(
                                        order.lat!,
                                        order.lng!,
                                      ),
                                      width: 36,
                                      height: 36,
                                      child: AvatarGlow(
                                        glowColor: appColorPrimary,
                                        duration:
                                            const Duration(milliseconds: 2000),
                                        repeat: true,
                                        child: WidgetAvatar(
                                          imageUrl: order.customer!.avatar,
                                          radius1: 18.sw,
                                          radius2: 18.sw - 2,
                                          radius3: 18.sw - 2,
                                          borderColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ];

                                  mapController.future.then((controller) {
                                    updateMapToBoundsLatLng(
                                      markers.map((e) => e.point).toList(),
                                      controller,
                                    );
                                  });

                                  return WidgetAppFlutterMapAnimation(
                                    mapController: mapController,
                                    initialCenter: LatLng(
                                      order.lat!,
                                      order.lng!,
                                    ),
                                    markers: markers,
                                    polylines: [
                                      if (!isPickup)
                                        Polyline(
                                          pattern: const StrokePattern.dotted(
                                            spacingFactor: 1.5,
                                            patternFit: PatternFit.scaleUp,
                                          ),
                                          color: appColorPrimary,
                                          strokeWidth: 6.0,
                                          borderColor: Colors.white,
                                          borderStrokeWidth: 1.0,
                                          points: polylinePoints,
                                        )
                                    ],
                                    initialZoom: 14,
                                  );
                                }),
                          ),
                        ],
                      ),
                      SlidingUpPanel(
                        controller: _panelController,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, -4),
                          ),
                        ],
                        minHeight:
                            320.sw + MediaQuery.of(context).padding.bottom,
                        maxHeight:
                            580.sw + MediaQuery.of(context).padding.bottom,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        panel: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              if (isPickup) ...[
                                _buildStoreStatus(statusStore ??
                                    AppOrderStoreStatus.accepted),
                              ] else ...[
                                _buildProcessStatus(processStatus ??
                                    AppOrderProcessStatus.pending),
                              ],
                              SizedBox(height: 12.sw),
                              if (!isPickup) ...[
                                _buildDriverInfo(order),
                              ],
                              _buildAddressCard(order),
                              _buildOrderSummary(order),
                              SizedBox(
                                  height: 40 +
                                      MediaQuery.of(context).viewInsets.bottom),
                            ],
                          ),
                        ),
                        body: Container(),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  Widget _buildProcessStatus(AppOrderProcessStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: hexColor('#F1EFE9')),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.sw),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProgressIcon(
                  'icon51',
                  isActive: status.index >=
                      AppOrderProcessStatus.driverAccepted.index,
                ),
                Container(
                  width: 60,
                  height: 2,
                  color: status.index >=
                          AppOrderProcessStatus.driverArrivedStore.index
                      ? appColorPrimary
                      : const Color(0xFFCEC6C5),
                ),
                _buildProgressIcon(
                  'icon54',
                  isActive:
                      status.index >= AppOrderProcessStatus.driverPicked.index,
                ),
                Container(
                  width: 60,
                  height: 2,
                  color: status.index >=
                          AppOrderProcessStatus.driverArrivedDestination.index
                      ? appColorPrimary
                      : const Color(0xFFCEC6C5),
                ),
                _buildProgressIcon(
                  'icon55',
                  isActive: status.index >=
                      AppOrderProcessStatus.driverArrivedDestination.index,
                ),
                Container(
                  width: 60,
                  height: 2,
                  color: status.index >= AppOrderProcessStatus.completed.index
                      ? appColorPrimary
                      : const Color(0xFFCEC6C5),
                ),
                _buildProgressIcon(
                  'icon61',
                  isActive:
                      status.index >= AppOrderProcessStatus.completed.index,
                ),
              ],
            ),
          ),
          Text(
            status.description.tr(),
            style: w400TextStyle(fontSize: 16.sw, color: hexColor('#847D79')),
          ),
          Gap(10.sw),
        ],
      ),
    );
  }

  Widget _buildStoreStatus(AppOrderStoreStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: hexColor('#F1EFE9')),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.sw),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProgressIcon(
                  'icon51',
                  isActive: true,
                ),
                Container(
                  width: 60,
                  height: 2,
                  color: true ? appColorPrimary : const Color(0xFFCEC6C5),
                ),
                _buildProgressIcon(
                  'icon54',
                  isActive: true,
                ),
                Container(
                  width: 60,
                  height: 2,
                  color: status.index >= AppOrderProcessStatus.completed.index
                      ? appColorPrimary
                      : const Color(0xFFCEC6C5),
                ),
                _buildProgressIcon(
                  'icon61',
                  isActive:
                      status.index >= AppOrderProcessStatus.completed.index,
                ),
              ],
            ),
          ),
          Text(
            'Store is being processed'.tr(),
            style: w400TextStyle(fontSize: 16.sw, color: hexColor('#847D79')),
          ),
          Gap(10.sw),
        ],
      ),
    );
  }

  Widget _buildProgressIcon(String icon, {required bool isActive}) {
    return WidgetAppSVG(
      icon,
      width: 24.sw,
      height: 24.sw,
      color: isActive ? appColorPrimary : const Color(0xFFCEC6C5),
    );
  }

  Widget _buildDriverInfo(OrderModel order) {
    if (order.driver == null) return SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(16),
        padding: EdgeInsets.all(12),
        strokeWidth: .8,
        dashPattern: [8, 4],
        color: Color(0xFFCEC6C5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                WidgetAvatar.withoutBorder(
                  imageUrl: order.driver?.avatar ?? '',
                  radius: 86.sw / 2,
                ),
              ],
            ),
            Gap(16.sw),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.driver?.name ?? '',
                    style:
                        w600TextStyle(fontSize: 20.sw, color: appColorPrimary),
                  ),
                  Gap(4.sw),
                  Text(
                    order.driver?.phone ?? "",
                    style: w400TextStyle(
                        fontSize: 14.sw, color: hexColor('#847D79')),
                  ),
                  Gap(8.sw),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          appHaptic();
                          final r = await appContext.push('/cancel-order');
                          if (r is String) {
                            socketController.cancelOrder(r);
                            context.pop();

                            appOpenDialog(
                              WidgetDialogNotification(
                                icon: 'icon60',
                                title:
                                    "We're so sad about your cancellation".tr(),
                                message:
                                    "We will continue to improve our service & satisfy you on the next order.",
                                buttonText: "Done".tr(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 48.sw,
                          width: 48.sw,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: hexColor('#F1EFE9'))),
                          alignment: Alignment.center,
                          child: WidgetAppSVG('icon49',
                              width: 24.sw, height: 24.sw),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          appHaptic();
                          launchUrl(Uri.parse('sms:${order.driver?.phone}'));
                        },
                        child: Container(
                          height: 48.sw,
                          width: 48.sw,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: hexColor('#F1EFE9'))),
                          alignment: Alignment.center,
                          child: WidgetAppSVG('icon46',
                              width: 24.sw, height: 24.sw),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          appHaptic();
                          launchUrl(Uri.parse('tel:${order.driver?.phone}'));
                        },
                        child: Container(
                          height: 48.sw,
                          width: 48.sw,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: hexColor('#F1EFE9'))),
                          alignment: Alignment.center,
                          child: WidgetAppSVG('icon45',
                              width: 24.sw, height: 24.sw),
                        ),
                      ),
                      Gap(4.sw),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(OrderModel order) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF74CA45)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildAddressRow(
            icon: 'icon32',
            title: order.store?.name ?? '',
            address: order.store?.address ?? '',
          ),
          if (!isPickup) ...[
            const SizedBox(height: 10),
            _buildAddressRow(
              icon: 'icon20',
              title: "Customer address".tr(),
              address: order.address ?? '',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddressRow({
    required String icon,
    required String title,
    required String address,
  }) {
    return Row(
      children: [
        WidgetAppSVG(
          icon,
          width: 20,
          height: 20,
          color: appColorPrimaryOrange,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: w400TextStyle(fontSize: 16.sw),
              ),
              const SizedBox(height: 4),
              Text(
                address,
                style: w400TextStyle(fontSize: 14.sw),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(OrderModel order) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(16),
        padding: EdgeInsets.all(12),
        strokeWidth: .8,
        dashPattern: [8, 4],
        color: Color(0xFFCEC6C5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                WidgetAvatar.withoutBorder(
                  imageUrl: order.store?.avatarImage ?? '',
                  radius: 12,
                ),
                const SizedBox(width: 8),
                Text(
                  order.store?.name ?? '',
                  style: w400TextStyle(fontSize: 16.sw),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Divider(color: Color(0xFFF1EFE9)),
            ),
            Text(
              'Order items'.tr(),
              style: w500TextStyle(fontSize: 16.sw),
            ),
            Gap(8.sw),
            ...order.items
                    ?.map((cartItem) => _buildOrderItem(cartItem))
                    .toList() ??
                [],
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Divider(color: Color(0xFFF1EFE9)),
            ),
            _buildSummaryRow('Subtotal', currencyFormatted(order.subtotal)),
            _buildSummaryRow(
                'Application fee', currencyFormatted(order.applicationFee)),
            _buildSummaryRow('Courier tip', currencyFormatted(order.tip),
                color: appColorPrimary),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      WidgetAppSVG('icon34',
                          height: 18.sw, color: hexColor('#F17228')),
                      const SizedBox(width: 8),
                      Text(
                        currencyFormatted(1000) + ' off, more deals below',
                        style: w400TextStyle(
                          fontSize: 16.sw,
                          color: hexColor('#3C3836'),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '- ${currencyFormatted(order.discount)}',
                    style: w500TextStyle(
                      fontSize: 16.sw,
                      color: hexColor('#F17228'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: const Divider(color: Color(0xFFF1EFE9)),
            ),
            _buildSummaryRow('Total', currencyFormatted(order.total)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String amount, {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
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
      ),
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
                        imageUrl: cartItem.product?.image ?? '',
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
                            cartItem.product?.name ?? "",
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
                                              .product!.price! *
                                          cartItem.quantity! +
                                      cartItem.variations!.fold(
                                              0,
                                              (sum, variation) =>
                                                  sum +
                                                  variation.price!.toInt()) *
                                          cartItem.quantity!),
                                  style: w500TextStyle(
                                    fontSize: 14.sw,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      " (${currencyFormatted(cartItem.product!.price!)} x ${cartItem.quantity} + ${currencyFormatted(cartItem.variations!.fold(0, (sum, variation) => sum + variation.price!.toInt()) * cartItem.quantity!)})",
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
                ...cartItem.product!.variations!.map((e) => _buildMenuSection(
                      e.name ?? '',
                      e.values?.map(
                            (e) {
                              bool isSelected = cartItem.variations!
                                  .any((element) => element.id == e.id);
                              return GestureDetector(
                                onTap: () {
                                  if (isSelected) {
                                    cartItem.variations!.removeWhere(
                                        (element) => element.id == e.id);
                                  } else {
                                    cartItem.variations!.removeWhere(
                                        (element) =>
                                            element.parentId == e.parentId);
                                    cartItem.variations!.add(e);
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
