import 'dart:async';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/socket_shell/controllers/socket_controller.dart';
import 'package:app/src/presentation/widgets/slider_button.dart';
import 'package:app/src/presentation/widgets/widget_app_map.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_core/internal_core.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<AnimatedMapController> mapController = Completer<AnimatedMapController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkNotificationPermission());
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
              Container(
                height: 255.sw,
                color: hexColor('#EFF0F4'),
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
                  border: Border.all(color: appColorPrimary),
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
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                WidgetAppFlutterMapAnimation(
                  mapController: mapController,
                  initialCenter: LatLng(37.7749, -122.4194),
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
                            "Go offline".tr(),
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
                            "Go online".tr(),
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
