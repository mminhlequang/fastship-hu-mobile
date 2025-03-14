import 'package:app/src/constants/app_colors.dart';
import 'package:app/src/constants/app_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionWrapper extends StatefulWidget {
  final Widget child;
  const LocationPermissionWrapper({super.key, required this.child});

  @override
  State<LocationPermissionWrapper> createState() =>
      _LocationPermissionWrapperState();
}

class _LocationPermissionWrapperState extends State<LocationPermissionWrapper> {
  late Future<bool> _permissionCheckFuture;

  @override
  void initState() {
    super.initState();
    _permissionCheckFuture = _checkLocationPermission();
  }

  Future<bool> _checkLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      // Hiển thị dialog giải thích
      final bool? userResponse = await _showPermissionExplanationDialog();

      if (userResponse == true) {
        // Yêu cầu quyền
        final result = await Permission.locationWhenInUse.request();
        print('Debug socket: Kết quả yêu cầu quyền: $result');
        return result.isGranted;
      }

      return false;
    }

    if (status.isPermanentlyDenied) {
      await _showOpenSettingsDialog();
      return false;
    }

    return false;
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
                'You’ll need to give Fast Ship permissiom to always use your location to get notifications about order near you'
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
            ],
          ),
        );
      },
    );
  }

  Future<void> _showOpenSettingsDialog() async {
    await showModalBottomSheet(
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
                'Your location'.tr(),
                style: w700TextStyle(fontSize: 20.sw),
              ),
              Gap(8.sw),
              Text(
                'To center the map on your current location, update your setting to “always” or “while using”.'
                    .tr(),
                style: w400TextStyle(fontSize: 16.sw),
                textAlign: TextAlign.center,
              ),
              Gap(32.sw),
              WidgetRippleButton(
                onTap: () {
                  Navigator.pop(context);
                  openAppSettings();
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
              Gap(8.sw),
              WidgetRippleButton(
                onTap: () => Navigator.pop(context),
                borderSide: BorderSide(color: appColorPrimary),
                child: SizedBox(
                  height: 48.sw,
                  child: Center(
                    child: Text(
                      'No, thanks'.tr(),
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
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _permissionCheckFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()));
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_off,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              const Text(
                'Quyền vị trí bị từ chối',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Ứng dụng cần quyền truy cập vị trí để hoạt động chính xác. Vị trí của bạn được sử dụng để nhận đơn hàng gần đó và theo dõi hành trình giao hàng.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  await openAppSettings();
                  // Kiểm tra lại quyền sau khi người dùng quay lại từ cài đặt
                  setState(() {
                    _permissionCheckFuture = _checkLocationPermission();
                  });
                },
                icon: const Icon(Icons.settings),
                label: const Text('Mở cài đặt hệ thống'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _permissionCheckFuture = _checkLocationPermission();
                  });
                },
                child: const Text('Kiểm tra lại quyền'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
