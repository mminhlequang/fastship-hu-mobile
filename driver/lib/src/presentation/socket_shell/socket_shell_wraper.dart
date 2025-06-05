import 'package:app/src/constants/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:permission_handler/permission_handler.dart';

import 'controllers/socket_controller.dart';

class SocketShellWrapper extends StatefulWidget {
  final Widget child;
  const SocketShellWrapper({super.key, required this.child});

  @override
  State<SocketShellWrapper> createState() => _SocketShellWrapperState();
}

class _SocketShellWrapperState extends State<SocketShellWrapper>
    with WidgetsBindingObserver {
  late Future<bool> _permissionCheckFuture;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _permissionCheckFuture = _checkLocationPermission(needShowDialog: false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    socketController.init();
    _permissionCheckFuture = _checkLocationPermission();
  }

  Future<bool> _checkLocationPermission({bool needShowDialog = true}) async {
    final status = await Permission.locationAlways.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      // Hiển thị dialog giải thích
      if (needShowDialog) {
        await _showPermissionExplanationDialog();
      }

      // Yêu cầu quyền
      final result = await Permission.locationAlways.request();
      if (result.isPermanentlyDenied) {
        openAppSettings();
      }
      return result.isGranted;
    }

    // if (status.isPermanentlyDenied) {
    //   openAppSettings();
    // }

    return status.isGranted;
  }

  Future<bool?> _showPermissionExplanationDialog() async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 300),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              16.sw, 40.sw, 16.sw, 24.sw + context.mediaQueryPadding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 36.sw,
                backgroundColor: hexColor('#74CA45').withValues(alpha: .25),
                child: WidgetAppSVG('ic_redirect'),
              ),
              Gap(32.sw),
              Text(
                'Allow Location Access'.tr(),
                style: w700TextStyle(fontSize: 20.sw),
              ),
              Gap(8.sw),
              Text(
                'You’ll need to give Fast Ship permission to always use your location to get notifications about order near you'
                    .tr(),
                style: w400TextStyle(fontSize: 16.sw),
                textAlign: TextAlign.center,
              ),
              Gap(32.sw),
              WidgetRippleButton(
                onTap: () => Navigator.pop(context, true),
                color: appColorPrimary,
                child: SizedBox(
                  height: 48.sw,
                  child: Center(
                    child: Text(
                      'Continue'.tr(),
                      style: w500TextStyle(
                        fontSize: 16.sw,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(8.sw),
              WidgetRippleButton(
                onTap: () {
                  openAppSettings();
                },
                borderSide: BorderSide(color: appColorPrimary),
                child: SizedBox(
                  height: 48.sw,
                  child: Center(
                    child: Text(
                      'Open settings'.tr(),
                      style: w500TextStyle(
                        fontSize: 16.sw,
                        color: appColorPrimary,
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    socketController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _permissionCheckFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(color: Colors.white);
        }

        final hasPermission = snapshot.data ?? false;

        if (hasPermission) {
          return widget.child;
        } else {
          return _buildPermissionDeniedScreen();
        }
      },
    );
  }

  Widget _buildPermissionDeniedScreen() {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 36.sw,
                  backgroundColor: hexColor('#74CA45').withValues(alpha: .25),
                  child: WidgetAppSVG('ic_redirect'),
                ),
                Gap(32.sw),
                Text(
                  'Your location'.tr(),
                  style: w700TextStyle(fontSize: 20.sw),
                ),
                Gap(8.sw),
                Text(
                  'To center the map on your current location, update your setting to "always" or "while using". Location permission is a critical requirement for this delivery app as it allows us to track your position, match you with nearby orders, and provide accurate navigation to customers.'
                      .tr(),
                  style: w400TextStyle(fontSize: 16.sw, height: 1.4),
                  textAlign: TextAlign.center,
                ),
                Gap(32.sw),
                WidgetRippleButton(
                  onTap: () async {
                    appHaptic();
                    await openAppSettings();
                    _permissionCheckFuture = _checkLocationPermission();
                  },
                  color: appColorPrimary,
                  child: SizedBox(
                    height: 48.sw,
                    child: Center(
                      child: Text(
                        'Go to settings'.tr(),
                        style: w500TextStyle(
                          fontSize: 16.sw,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
