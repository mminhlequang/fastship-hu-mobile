import 'dart:async';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/home/widgets/order_states.dart';
import 'package:app/src/presentation/widgets/widget_hold_button.dart';
import 'package:app/src/utils/app_map_helper.dart';
import 'package:app/src/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_resources/auth/repo.dart';
import 'package:app/src/presentation/socket_shell/controllers/socket_controller.dart';
import 'package:app/src/presentation/widgets/widget_app_map.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_core/internal_core.dart';
import 'package:latlong2/latlong.dart';
import 'package:network_resources/network_resources.dart';
import 'package:network_resources/order/models/models.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../notifications/cubit/notification_cubit.dart';
import '../widgets/widget_blink.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SocketController get _socketController => findInstance<SocketController>();
  OrderModel? get _currentOrder => _socketController.currentOrder;

  Completer<AnimatedMapController> mapController =
      Completer<AnimatedMapController>();

  @override
  void initState() {
    super.initState();
    notificationCubit.fetchNotifications();
    _checkNotificationPermission().then((_) async {
      AuthRepo().updateDeviceToken(
          {'device_token': await FirebaseMessaging.instance.getToken()});
    });
  }

  // Future<void> _callCustomer() async {
  //   if (_currentOrder != null && _currentOrder!.customer?.phone != null) {
  //     final Uri url = Uri.parse('tel:${_currentOrder!.customer?.phone!}');
  //     if (await canLaunchUrl(url)) {
  //       await launchUrl(url);
  //     }
  //   }
  // }

  // Future<void> _sendSms(String message) async {
  //   if (_currentOrder != null && _currentOrder!.customer?.phone != null) {
  //     final Uri url =
  //         Uri.parse('sms:${_currentOrder!.customer?.phone}?body=$message');
  //     if (await canLaunchUrl(url)) {
  //       await launchUrl(url);
  //     }
  //   }
  // }

  // Future<void> _contactSupport() async {
  //   final Uri url = Uri.parse('tel:$supportPhoneNumber');
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   }
  // }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;

    if (status.isGranted) {
      return;
    }

    final bool? userResponse = await _showPermissionExplanationDialog();

    if (userResponse == true) {
      await Permission.notification.request();
    }
  }

  Future<bool?> _showPermissionExplanationDialog() async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 300),
      ),
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: 24.sw + context.mediaQueryPadding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 375 / 255,
                child: SizedBox(
                  width: context.width,
                  child: Image.asset(
                    assetpng('bg_noti_permission'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Gap(24.sw),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sw),
                child: Text(
                  'Don’t miss anything'.tr(),
                  style: w700TextStyle(fontSize: 20.sw),
                ),
              ),
              Gap(8.sw),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sw),
                child: Text(
                  'You will receive push notification from Fast Ship like News and Balance alert.'
                      .tr(),
                  style: w400TextStyle(fontSize: 16.sw),
                  textAlign: TextAlign.center,
                ),
              ),
              Gap(32.sw),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sw),
                child: WidgetRippleButton(
                  onTap: () => Navigator.pop(context, true),
                  color: appColorPrimary,
                  child: SizedBox(
                    height: 48.sw,
                    child: Center(
                      child: Text(
                        'Turn on Notification'.tr(),
                        style: w500TextStyle(
                          fontSize: 16.sw,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Gap(8.sw),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sw),
                child: WidgetRippleButton(
                  onTap: () => Navigator.pop(context, false),
                  borderSide: BorderSide(color: appColorPrimary),
                  child: SizedBox(
                    height: 48.sw,
                    child: Center(
                      child: Text(
                        'Not now'.tr(),
                        style: w500TextStyle(
                          fontSize: 16.sw,
                          color: appColorPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: socketController.orderStatus,
                      builder: (context, status, child) {
                        return ValueListenableBuilder(
                          valueListenable: socketController.currentLocation,
                          builder: (context, location, child) {
                            List<Marker> markers = [];
                            List<Polyline> polylines = [];
                            OrderModel? order = socketController.currentOrder;
                            if (location != null) {
                              markers.add(Marker(
                                point: location,
                                width: 44.sw,
                                height: 44.sw,
                                child: Center(
                                  child: AvatarGlow(
                                    glowColor: appColorPrimary,
                                    child: WidgetAppSVG(
                                      'motor',
                                      width: 44.sw,
                                      height: 44.sw,
                                    ),
                                  ),
                                ),
                              ));
                            }
                            if (status != AppOrderProcessStatus.pending) {
                              if (order != null) {
                                markers.addAll([
                                  Marker(
                                    point: LatLng(
                                      order.store!.lat!,
                                      order.store!.lng!,
                                    ),
                                    width: 44.sw,
                                    height: 44.sw,
                                    child: WidgetAvatar(
                                      imageUrl: order.store!.avatarImage,
                                      radius1: 22.sw,
                                      radius2: 22.sw - 2,
                                      radius3: 22.sw - 2,
                                      borderColor: Colors.white,
                                    ),
                                  ),
                                  if (order.lat != null && order.lng != null)
                                    Marker(
                                      point: LatLng(
                                        order.lat!,
                                        order.lng!,
                                      ),
                                      width: 44.sw,
                                      height: 44.sw,
                                      child: AvatarGlow(
                                        glowColor: appColorPrimary,
                                        duration:
                                            const Duration(milliseconds: 2000),
                                        repeat: true,
                                        child: WidgetAvatar(
                                          imageUrl: order.customer!.avatar,
                                          radius1: 22.sw,
                                          radius2: 22.sw - 2,
                                          radius3: 22.sw - 2,
                                          borderColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                ]);
                              }

                              if (socketController
                                      .currentOrder?.shipPolyline?.isNotEmpty ??
                                  false) {
                                try {
                                  List<LatLng> polylinePoints =
                                      FlexiblePolyline.decode(socketController
                                              .currentOrder!.shipPolyline!)
                                          .map((e) => LatLng(e.lat, e.lng))
                                          .toList();
                                  polylines.add(Polyline(
                                    points: polylinePoints,
                                    pattern: const StrokePattern.dotted(
                                      spacingFactor: 1.5,
                                      patternFit: PatternFit.scaleUp,
                                    ),
                                    color: appColorPrimary,
                                    strokeWidth: 6.0,
                                    borderColor: Colors.white,
                                    borderStrokeWidth: 1.0,
                                  ));
                                } catch (e) {
                                  debugPrint('Error decoding polyline: $e');
                                }
                              }
                            }

                            if (location != null) {
                              mapController.future.then((e) {
                                updateMapToBoundsLatLng(
                                    markers.map((e) => e.point).toList(), e);
                              });
                            }
                            return WidgetAppFlutterMapAnimation(
                              mapController: mapController,
                              initialCenter:
                                  location ?? LatLng(37.7749, -122.4194),
                              polylines: polylines,
                              markers: markers,
                            );
                          },
                        );
                      },
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      top: 20 + context.mediaQueryPadding.top,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WidgetRippleButton(
                            onTap: () => context.push('/settings'),
                            elevation: 12,
                            shadowColor: Colors.black54,
                            child: SizedBox(
                              height: 40.sw,
                              width: 40.sw,
                              child: Center(
                                child: WidgetAppSVG('ic_menu'),
                              ),
                            ),
                          ),
                          WidgetRippleButton(
                            onTap: () {
                              appHaptic();
                              context.push('/notifications');
                            },
                            elevation: 12,
                            shadowColor: Colors.black54,
                            child: SizedBox(
                              height: 40.sw,
                              width: 40.sw,
                              child: BlocBuilder<NotificationCubit,
                                      NotificationState>(
                                  bloc: notificationCubit,
                                  builder: (context, state) {
                                    return Center(
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          WidgetAppSVG('ic_bell'),
                                          if (state.items
                                              .any((e) => e.isRead == 0))
                                            Positioned(
                                              top: -6,
                                              right: -4,
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    4.sw,
                                                    2.53.sw,
                                                    4.sw,
                                                    0.47.sw),
                                                decoration: BoxDecoration(
                                                  color: hexColor('#F58737'),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.sw),
                                                  border: Border.all(
                                                      color: Colors.white),
                                                ),
                                                child: Text(
                                                  state.items
                                                              .where((e) =>
                                                                  e.isRead == 0)
                                                              .length >
                                                          5
                                                      ? '5+'
                                                      : state.items
                                                          .where((e) =>
                                                              e.isRead == 0)
                                                          .length
                                                          .toString(),
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 10.sw,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: socketController.socketConnected,
                  builder: (context, isConnected, child) {
                    bool isOnline = socketController.isOnline;
                    return Container(
                      key: ValueKey(isOnline),
                      width: context.width,
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(16.sw, 10.sw, 16.sw,
                          16.sw + MediaQuery.paddingOf(context).bottom),
                      child: HoldToConfirmButton(
                        key: ValueKey(isOnline),
                        onProgressCompleted: () async {
                          appHaptic();
                          socketController.setOnlineStatus(!isOnline);
                          setState(() {});
                        },
                        backgroundColor: !isOnline ? orange1 : appColorPrimary,
                        child: Center(
                          child: Row(
                            children: [
                              WidgetBlink(
                                builder: (color) => WidgetAppSVG(
                                  isOnline ? 'icon6' : 'icon7',
                                  width: 24.sw,
                                  color: color,
                                ),
                                color1: Colors.white.withValues(alpha: .2),
                                color2: Colors.white,
                              ),
                              Gap(8.sw),
                              Text(
                                isOnline
                                    ? 'You are online, hold to go offline'.tr()
                                    : 'You are offline, hold to go online'.tr(),
                                style: w500TextStyle(
                                  fontSize: 18.sw,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // highlightedColor: darkGreen,
                        // baseColor: Colors.white,
                        // shimmer: false,
                      ),
                    );
                  })
            ],
          ),
          // Trạng thái đơn hàng
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<AppOrderProcessStatus>(
              valueListenable: _socketController.orderStatus,
              builder: (context, value, child) {
                if (value == AppOrderProcessStatus.pending) {
                  return const SizedBox.shrink();
                }

                return WidgetOrderStates(
                  processStatus: value,
                  order: _currentOrder,
                  // onStatusChanged: _socketController.updateOrderStatus,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
