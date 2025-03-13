import 'dart:async';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/socket_shell/controllers/socket_controller.dart';
import 'package:app/src/presentation/widgets/slider_button.dart';
import 'package:app/src/presentation/widgets/widget_app_map.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:internal_core/internal_core.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<AnimatedMapController> mapController =
      Completer<AnimatedMapController>();

  @override
  void initState() {
    super.initState();
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
                      GestureDetector(
                        onTap: () {
                          context.push('/settings');
                        },
                        child: PhysicalModel(
                          elevation: 4,
                          shadowColor: Colors.black26,
                          color: Colors.white,
                          shape: BoxShape.circle,
                          child: Container(
                            width: 44.sw,
                            height: 44.sw,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.menu_rounded,
                              size: 28.sw,
                              color: appColorText,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push('/notifications');
                        },
                        child: PhysicalModel(
                          elevation: 4,
                          shadowColor: Colors.black26,
                          color: Colors.white,
                          shape: BoxShape.circle,
                          child: Container(
                            width: 44.sw,
                            height: 44.sw,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.notifications_outlined,
                              size: 28.sw,
                              color: appColorText,
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
                  padding: EdgeInsets.fromLTRB(16.sw, 16.sw, 16.sw,
                      16.sw + MediaQuery.paddingOf(context).bottom),
                  child: isOnline
                      ? SliderButton(
                          direction: DismissDirection.endToStart,
                          action: () async {
                            appHaptic();
                            socketController.setOnlineStatus(false);
                            setState(() {});
                            return true;
                          },

                          ///Put label over here
                          label: Text(
                            "Go offline".tr(),
                            style: w400TextStyle(fontSize: 20.sw),
                          ),
                          icon: Center(
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: hexColor('F58737'),
                              size: 32.sw,
                            ),
                          ),

                          ///Change All the color and size from here.
                          height: 56.sw,
                          buttonSize: 48.sw,
                          width: context.width - 40.sw,
                          radius: 12.sw,
                          alignLabel: Alignment.center,
                          buttonColor: Colors.white,
                          backgroundColor: hexColor('F58737'),
                          highlightedColor: hexColor('F58737'),
                          baseColor: Colors.white,
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
                            style: w400TextStyle(fontSize: 20.sw),
                          ),
                          icon: Center(
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: appColorPrimary,
                              size: 32.sw,
                            ),
                          ),

                          ///Change All the color and size from here.
                          height: 56.sw,
                          buttonSize: 48.sw,
                          width: context.width - 40.sw,
                          radius: 12.sw,
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
