import 'package:app/src/base/cubit/location_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/widgets/widget_sheet_current_location.dart';
import 'package:app/src/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internal_core/internal_core.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/socket_controller.dart';

class LocationPermissionWrapper extends StatefulWidget {
  final Widget child;
  const LocationPermissionWrapper({super.key, required this.child});

  @override
  State<LocationPermissionWrapper> createState() =>
      _LocationPermissionWrapperState();
}

class _LocationPermissionWrapperState extends State<LocationPermissionWrapper> {
  PermissionStatus? _permissionStatus;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Permission.locationWhenInUse.status.then((value) async {
      _permissionStatus = value;
      if (value.isGranted) {
        await _checkGeolocation();
      }
      _isLoading = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  LatLng? _currentLocation;
  _checkGeolocation() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      ),
    );
    _currentLocation = LatLng(position.latitude, position.longitude);
    locationCubit.updateLocation(_currentLocation);
    // Nếu đã có vị trí hiện tại, sử dụng HERE API để lấy địa chỉ
    if (_currentLocation != null) {
      try {
        // Sử dụng HERE API để lấy địa chỉ từ tọa độ
        final String apiKey = hereMapApiKey; // Thay thế bằng API key thực tế
        final double lat = _currentLocation!.latitude;
        final double lng = _currentLocation!.longitude;
        final String url =
            'https://revgeocode.search.hereapi.com/v1/revgeocode?at=$lat,$lng&apiKey=$apiKey';

        final dio = Dio();
        final response = await dio.get(url);
        if (response.statusCode == 200) {
          final data = response.data;
          if (data['items'] != null && data['items'].isNotEmpty) {
            final address = data['items'][0]['address'];
            final String formattedAddress = address['label'] ?? '';
            appDebugPrint('Địa chỉ hiện tại: $formattedAddress');
            locationCubit.updateFormattedAddress(formattedAddress);
          }
        } else {
          appDebugPrint('Không thể lấy địa chỉ: ${response.statusCode}');
        }
      } catch (e) {
        appDebugPrint('Lỗi khi lấy địa chỉ: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionStatus?.isGranted == true) return widget.child;
    return Scaffold(
      backgroundColor: appColorBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              _buildLogo(),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        _buildHeader(),
                        const SizedBox(height: 40),
                        _buildLocationImage(),
                        const SizedBox(height: 40),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: WidgetAppSVG(
        "ic_logo_text",
        width: 165.sw,
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Find store and item\nnear you ?'.tr(),
          style: w600TextStyle(
            fontSize: 32.sw,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Please enter your address to find top\nrestaurants and stores in your area.'
              .tr(),
          style: w400TextStyle(
            fontSize: 16.sw,
            color: appColorText2,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLocationImage() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 361),
      child: AspectRatio(
        aspectRatio: 361 / 193,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: WidgetAppSVG(
            'icon18', //TODO: need png
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 361),
      child: Column(
        children: [
          _buildActionButton(
            icon: 'icon9',
            label: _permissionStatus != PermissionStatus.permanentlyDenied
                ? 'Use current location'
                : 'Open settings',
            onTap: () async {
              if (_permissionStatus != PermissionStatus.permanentlyDenied) {
                final result = await Permission.locationWhenInUse.request();
                if (result.isGranted) {
                  setState(() {
                    _isLoading = true;
                  });
                  await _checkGeolocation();
                  _isLoading = false;
                  if (_currentLocation != null) {
                    await appOpenBottomSheet(
                        WidgetSheetCurrentLocation(latlng: _currentLocation!));
                  } else {
                    appShowSnackBar(
                        msg:
                            "We couldn't get your location, please try again later!"
                                .tr());
                  }
                  setState(() {
                    _permissionStatus = result;
                  });
                } else {
                  setState(() {
                    _permissionStatus = result;
                  });
                }
              } else {
                openAppSettings();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 52.sw,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFDEDEDE)),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoading)
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: appColorPrimary,
                      strokeCap: StrokeCap.round,
                      backgroundColor: Colors.grey[200],
                    ),
                  )
                else
                  WidgetAppSVG(
                    icon,
                    width: 24,
                    height: 24,
                  ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: w400TextStyle(
                    fontSize: 18.sw,
                    height: 1.2,
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
