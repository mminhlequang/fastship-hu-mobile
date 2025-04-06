import 'dart:async';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/utils/utils.dart';
import 'package:app/src/utils/app_map_utils.dart';
import 'package:app/src/utils/animated_polyline.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_core/internal_core.dart';
import 'package:latlong2/latlong.dart';
import 'package:network_resources/enums.dart';
import 'package:network_resources/order/models/models.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../socket_shell/controllers/socket_controller.dart';
import '../widgets/widget_app_map.dart';

class CheckoutTrackingScreen extends StatefulWidget {
  const CheckoutTrackingScreen({super.key});

  @override
  State<CheckoutTrackingScreen> createState() => _CheckoutTrackingScreenState();
}

class _CheckoutTrackingScreenState extends State<CheckoutTrackingScreen> {
  Completer<AnimatedMapController> mapController =
      Completer<AnimatedMapController>();
  final PanelController _panelController = PanelController();

  // ValueNotifier cho polylines
  final ValueNotifier<List<Polyline>> _polylinesNotifier =
      ValueNotifier<List<Polyline>>([]);

  // Controller cho LiveAnimatedPolyline
  LiveAnimatedPolyline? _polylineController;

  OrderModel get order => socketController.order!;
  String get polyline => order.shipPolyline ?? '';

  @override
  void dispose() {
    _polylinesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: socketController.orderStatus,
        builder: (context, value, child) {
          if (value == null) return SizedBox();
          OrderModel order = socketController.order!;
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    appHaptic();
                                    appContext.pop();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: WidgetAppSVG('icon40',
                                        width: 24, height: 24),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  value?.textNotification ?? 'Processing'.tr(),
                                  style: w400TextStyle(fontSize: 18.sw),
                                ),
                                const SizedBox(width: 12),
                                // SizedBox(
                                //   width: 20,
                                //   height: 20,
                                //   child: CircularProgressIndicator(
                                //     backgroundColor: Colors.grey[100],
                                //     color: appColorPrimaryOrange,
                                //   ),
                                // ),
                              ],
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                appHaptic();
                              },
                              child: Text(
                                'Cancel',
                                style: w400TextStyle(
                                  fontSize: 16,
                                  color: const Color(0xFFF17228),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ValueListenableBuilder(
                            valueListenable: socketController.driverLocation,
                            builder: (context, driverLocation, child) {
                              // Chuyển đổi chuỗi polyline thành danh sách điểm LatLng
                              List<LatLng> polylinePoints = [];
                              if (polyline.isNotEmpty) {
                                try {
                                  polylinePoints =
                                      AppMapUtils.decodePolyline(polyline);

                                  // Cập nhật polyline controller
                                  if (_polylineController == null &&
                                      polylinePoints.isNotEmpty) {
                                    _polylineController = LiveAnimatedPolyline(
                                      points: polylinePoints,
                                      polylinesNotifier: _polylinesNotifier,
                                      color: appColorPrimary,
                                      strokeWidth: 4.0,
                                      borderColor: Colors.white,
                                      borderStrokeWidth: 1.0,
                                    );
                                  }
                                } catch (e) {
                                  debugPrint('Error decoding polyline: $e');
                                }
                              }

                              return Stack(
                                children: [
                                  ValueListenableBuilder<List<Polyline>>(
                                      valueListenable: _polylinesNotifier,
                                      builder: (context, polylines, _) {
                                        return WidgetAppFlutterMapAnimation(
                                          mapController: mapController,
                                          initialCenter: LatLng(
                                            order.lat!,
                                            order.lng!,
                                          ),
                                          markers: [
                                            Marker(
                                              point: LatLng(
                                                order.store!.lat!,
                                                order.store!.lng!,
                                              ),
                                              width: 36.sw,
                                              height: 36.sw,
                                              child: WidgetAvatar(
                                                imageUrl:
                                                    order.store!.avatarImage,
                                                radius1: 18.sw,
                                                radius2: 18.sw - 2,
                                                radius3: 18.sw - 2,
                                                borderColor: Colors.white,
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
                                                  imageUrl:
                                                      order.driver!.avatar ??
                                                          '',
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
                                                duration: const Duration(
                                                    milliseconds: 2000),
                                                repeat: true,
                                                child: WidgetAppSVG(
                                                  'icon23',
                                                  width: 28,
                                                  height: 28,
                                                  color: appColorPrimary,
                                                ),
                                              ),
                                            ),
                                          ],
                                          polylines: polylines,
                                          initialZoom: 15,
                                          minZoom: 15,
                                          maxZoom: 19,
                                        );
                                      }),

                                  // Sử dụng controller nhưng không render
                                  if (_polylineController != null)
                                    _polylineController!,
                                ],
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
                    minHeight: 180.sw + MediaQuery.of(context).padding.bottom,
                    maxHeight: 380.sw + MediaQuery.of(context).padding.bottom,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    panel: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildProgressIndicator(value),
                          SizedBox(height: 12.sw),
                          _buildDriverInfo(order),
                          _buildAddressCard(order),
                          _buildOrderSummary(order),
                        ],
                      ),
                    ),
                    body: Container(),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildProgressIndicator(AppOrderProcessStatus status) {
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
                  Gap(4.sw),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          appHaptic();
                          //Cancel order
                        },
                        child: Container(
                          height: 48.sw,
                          width: 48.sw,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: hexColor('#F1EFE9'))),
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
                          child: WidgetAppSVG('icon45',
                              width: 24.sw, height: 24.sw),
                        ),
                      ),
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
          const SizedBox(height: 10),
          _buildAddressRow(
            icon: 'icon20',
            title: "Customer address".tr(),
            address: order.address ?? '',
          ),
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
            const Divider(color: Color(0xFFF1EFE9)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal'.tr(),
                    style: w400TextStyle(
                      fontSize: 16.sw,
                      color: const Color(0xFF3C3836),
                    ),
                  ),
                  Text(
                    '\$ 12,00', //TODO: change to order.totalPrice
                    style: w500TextStyle(fontSize: 16.sw),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF74CA45)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(120),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Order summary',
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      color: const Color(0xFF74CA45),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SvgPicture.string(
                    '''<svg width="25" height="24" viewBox="0 0 25 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                      <path d="M9.5 6L15.1464 11.6464C15.3417 11.8417 15.3417 12.1583 15.1464 12.3536L9.5 18" stroke="#74CA45" stroke-width="1.5" stroke-linecap="round"/>
                    </svg>''',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
