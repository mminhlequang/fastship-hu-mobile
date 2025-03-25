import 'dart:async';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/network_resources/auth/repo.dart';
import 'package:app/src/presentation/home/widgets/widget_animated_stepper.dart';
import 'package:app/src/presentation/socket_shell/controllers/socket_controller.dart';
import 'package:app/src/presentation/widgets/slider_button.dart';
import 'package:app/src/presentation/widgets/widget_app_divider.dart';
import 'package:app/src/presentation/widgets/widget_app_map.dart';
import 'package:app/src/utils/app_go_router.dart';
import 'package:app/src/utils/app_utils.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dotted_line/dotted_line.dart';
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
import 'package:permission_handler/permission_handler.dart';

enum DeliveryStatus {
  waitingToAccept,
  accepted,
  picked,
  delivery,
  delivered,
  completed;

  String get displayName => switch (this) {
        picked => 'Picked'.tr(),
        delivery => 'Delivery'.tr(),
        delivered => 'Delivered'.tr(),
        _ => 'Confirm order'.tr(),
      };

  double get value => switch (this) {
        accepted => -0.5,
        picked => 0.5,
        delivery => 1.5,
        _ => 2,
      };
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<AnimatedMapController> mapController = Completer<AnimatedMapController>();
  final ValueNotifier<int> _seconds = ValueNotifier(30);
  final ValueNotifier<DeliveryStatus> _status = ValueNotifier(DeliveryStatus.waitingToAccept);

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission().then((_) async {
      AuthRepo().updateDeviceToken({'device_token': await FirebaseMessaging.instance.getToken()});
    });
  }

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
          padding: EdgeInsets.only(bottom: 24.sw + context.mediaQueryPadding.bottom),
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

  DeliveryStatus get _nextStatus => switch (_status.value) {
        DeliveryStatus.accepted => DeliveryStatus.picked,
        DeliveryStatus.picked => DeliveryStatus.delivery,
        DeliveryStatus.delivery => DeliveryStatus.delivered,
        _ => DeliveryStatus.completed,
      };

  Timer? _timer;
  Future<void> _showNewOrder() async {
    _seconds.value = 30;
    _status.value = DeliveryStatus.waitingToAccept;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        _seconds.value = _seconds.value - 1;
        if (_seconds.value == 0) {
          _timer?.cancel();
          appContext.pop();
        }
      },
    );
    await appOpenBottomSheet(
      ValueListenableBuilder<DeliveryStatus>(
        valueListenable: _status,
        builder: (context, statusValue, child) {
          bool isWaitingToConfirm = statusValue == DeliveryStatus.waitingToAccept;
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    16.sw, 16.sw, 16.sw, 16.sw + context.mediaQueryPadding.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isWaitingToConfirm) ...[
                      Text(
                        'Earning'.tr(),
                        style: w400TextStyle(color: grey1),
                      ),
                      Gap(2.sw),
                      Text(
                        '\$15.00',
                        style: w600TextStyle(fontSize: 20.sw, color: darkGreen),
                      ),
                      Gap(12.sw),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Detail Status'.tr(),
                            style: w600TextStyle(fontSize: 16.sw),
                          ),
                          GestureDetector(
                            onTap: () {
                              appHaptic();
                              // Todo:
                            },
                            child: Text(
                              'View more'.tr(),
                              style: w400TextStyle(
                                color: grey1,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(24.sw),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.sw),
                        child: WidgetAnimatedStepper(currentStep: statusValue.value),
                      ),
                      Gap(33.sw),
                    ],
                    const AppDivider(),
                    Gap(16.sw),
                    Stack(
                      children: [
                        Container(
                          width: context.width,
                          padding: EdgeInsets.only(left: 24.sw),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gong Cha Bubble Tea',
                                style: w500TextStyle(fontSize: 16.sw),
                              ),
                              Gap(2.sw),
                              Text(
                                '41 Quang Trung, Ward 3, Go Vap District',
                                style: w400TextStyle(color: grey1),
                              ),
                              Gap(4.sw),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 4.sw, vertical: 2.sw),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(99),
                                  border: Border.all(color: grey9),
                                ),
                                child: Text(
                                  '1,2km',
                                  style: w400TextStyle(fontSize: 12.sw),
                                ),
                              ),
                              Gap(16.sw),
                              Text(
                                'Hai Dang',
                                style: w500TextStyle(fontSize: 16.sw),
                              ),
                            ],
                          ),
                        ),
                        Positioned.fill(
                          top: 6.sw,
                          left: 6.sw,
                          bottom: 5.sw,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                CircleAvatar(radius: 4.sw, backgroundColor: appColorText),
                                Expanded(
                                  child: DottedLine(
                                    direction: Axis.vertical,
                                    lineThickness: 1,
                                    dashLength: 4,
                                    dashColor: grey1,
                                  ),
                                ),
                                CircleAvatar(radius: 4.sw, backgroundColor: appColorText),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(2.sw),
                    Padding(
                      padding: EdgeInsets.only(left: 24.sw),
                      child: Text(
                        '41 Quang Trung, Ward 3, Go Vap District',
                        style: w400TextStyle(color: grey1),
                      ),
                    ),
                    Gap(4.sw),
                    Container(
                      margin: EdgeInsets.only(left: 24.sw),
                      padding: EdgeInsets.symmetric(horizontal: 4.sw, vertical: 2.sw),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: grey9),
                      ),
                      child: Text(
                        '1,2km',
                        style: w400TextStyle(fontSize: 12.sw),
                      ),
                    ),
                    Gap(20.sw),
                    isWaitingToConfirm
                        ? WidgetRippleButton(
                            onTap: () {
                              // Todo:
                              _timer?.cancel();
                              _status.value = DeliveryStatus.accepted;
                            },
                            color: appColorPrimary,
                            child: SizedBox(
                              height: 48.sw,
                              child: Center(
                                child: ValueListenableBuilder<int>(
                                  valueListenable: _seconds,
                                  builder: (context, value, child) {
                                    return Text(
                                      '${'Accept order'.tr()} (${value}s)',
                                      style: w500TextStyle(fontSize: 16.sw, color: Colors.white),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        : SliderButton(
                            action: () async {
                              _status.value = _nextStatus;
                              return false;
                            },
                            label: Text(
                              _nextStatus.displayName,
                              style: w500TextStyle(fontSize: 18.sw, color: Colors.white),
                            ),
                            icon: Center(
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: appColorPrimary,
                                size: 24.sw,
                              ),
                            ),
                            height: 48.sw,
                            buttonSize: 40.sw,
                            width: context.width,
                            radius: 99,
                            alignLabel: Alignment.center,
                            buttonColor: Colors.white,
                            backgroundColor: appColorPrimary,
                            highlightedColor: appColorPrimary,
                            baseColor: Colors.white,
                            shimmer: false,
                          ),
                  ],
                ),
              ),
              if (isWaitingToConfirm)
                Positioned(
                  right: 6.sw,
                  top: 4.sw,
                  child: const CloseButton(),
                ),
            ],
          );
        },
      ),
      isDismissible: false,
      boxShadow: [
        BoxShadow(
          offset: const Offset(4, 0),
          blurRadius: 8,
          spreadRadius: 4,
          color: Colors.black.withValues(alpha: .1),
        ),
      ],
    );
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ValueListenableBuilder(
                  valueListenable: socketController.currentLocation,
                  builder: (context, location, child) {
                    print('location: $location');
                    return WidgetAppFlutterMapAnimation(
                      mapController: mapController,
                      initialCenter: location ?? LatLng(37.7749, -122.4194),
                      markers: [
                        if (location != null)
                          Marker(
                            point: location,
                            width: 32.sw,
                            height: 32.sw,
                            child: Center(
                              child: AvatarGlow(
                                glowColor: appColorPrimary,
                                child: WidgetAppSVG(
                                  'motor',
                                  width: 28.sw,
                                  height: 28.sw,
                                ),
                              ),
                            ),
                          ),
                      ],
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
                        onTap: () => context.push('/notifications'),
                        elevation: 12,
                        shadowColor: Colors.black54,
                        child: SizedBox(
                          height: 40.sw,
                          width: 40.sw,
                          child: Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                WidgetAppSVG('ic_bell'),
                                Positioned(
                                  top: -6,
                                  right: -4,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(4.sw, 2.53.sw, 4.sw, 0.47.sw),
                                    decoration: BoxDecoration(
                                      color: hexColor('#F58737'),
                                      borderRadius: BorderRadius.circular(7.sw),
                                      border: Border.all(color: Colors.white),
                                    ),
                                    child: Text(
                                      '3',
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
                          ),
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
                  padding: EdgeInsets.fromLTRB(
                      16.sw, 10.sw, 16.sw, 16.sw + MediaQuery.paddingOf(context).bottom),
                  child: isOnline
                      ? SliderButton(
                          direction: DismissDirection.endToStart,
                          action: () async {
                            appHaptic();
                            socketController.setOnlineStatus(false);
                            setState(() {});
                            return true;
                          },
                          label: Text(
                            'Go offline'.tr(),
                            style: w500TextStyle(
                              fontSize: 18.sw,
                              color: darkGreen,
                            ),
                          ),
                          icon: Center(
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 24.sw,
                            ),
                          ),
                          height: 48.sw,
                          buttonSize: 40.sw,
                          width: context.width,
                          radius: 99.sw,
                          border: Border.all(color: appColorPrimary.withValues(alpha: .23)),
                          alignLabel: Alignment.center,
                          buttonColor: appColorPrimary,
                          backgroundColor: appColorPrimary.withValues(alpha: .2),
                          highlightedColor: darkGreen,
                          baseColor: Colors.white,
                          shimmer: false,
                        )
                      : SliderButton(
                          action: () async {
                            appHaptic();
                            socketController.setOnlineStatus(true);
                            setState(() {});
                            return true;
                          },

                          ///Put label over here
                          label: Text(
                            'Go online'.tr(),
                            style: w500TextStyle(
                              fontSize: 18.sw,
                              color: Colors.white,
                            ),
                          ),
                          icon: Center(
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: appColorPrimary,
                              size: 24.sw,
                            ),
                          ),

                          ///Change All the color and size from here.
                          height: 48.sw,
                          buttonSize: 40.sw,
                          width: context.width,
                          radius: 99.sw,
                          alignLabel: Alignment.center,
                          buttonColor: Colors.white,
                          backgroundColor: appColorPrimary,
                          highlightedColor: appColorPrimary,
                          baseColor: Colors.white,
                        ),
                );
              })
        ],
      ),
    );
  }
}
