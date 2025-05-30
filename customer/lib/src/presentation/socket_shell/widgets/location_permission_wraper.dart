import 'dart:math';

import 'package:network_resources/network_resources.dart';
import 'package:app/src/base/cubit/location_cubit.dart';
import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/cart/widgets/widget_sheet_locations.dart';
import 'package:app/src/presentation/widgets/widget_search_place_builder.dart';
import 'package:app/src/presentation/widgets/widget_sheet_current_location.dart';
import 'package:app/src/utils/utils.dart';
import 'package:country_codes/country_codes.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
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
  late final int indexImage = Random().nextBool() ? 1 : 2;

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
  HereSearchResult? addressDetail;
  _checkGeolocation() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      ),
    );
    _currentLocation = LatLng(position.latitude, position.longitude);

    //TODO: remove later
    _currentLocation = LatLng(47.495986, 19.0653862);

    locationCubit.updateLocation(_currentLocation);

    // Nếu đã có vị trí hiện tại, sử dụng HERE API để lấy địa chỉ
    if (_currentLocation != null) {
      //try get country code from geocoding
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            _currentLocation!.latitude, _currentLocation!.longitude);
        if (placemarks.isNotEmpty) {
          // Tạo đối tượng HereSearchResult từ Placemark
          final placemark = placemarks.first;

          // Tạo đối tượng Address cho HereSearchResult
          final address = {
            "label":
                "${placemark.street}, ${placemark.locality}, ${placemark.country}",
            "countryCode": placemark.isoCountryCode,
            "countryName": placemark.country,
            "state": placemark.administrativeArea,
            "county": placemark.subAdministrativeArea,
            "city": placemark.locality,
            "district": placemark.subLocality,
            "street": placemark.street,
            "postalCode": placemark.postalCode,
          };

          // Tạo đối tượng HereSearchResult
          addressDetail = HereSearchResult(
            title: "${placemark.street}, ${placemark.locality}",
            id: "placemark-${DateTime.now().millisecondsSinceEpoch}",
            resultType: "placemark",
            address: HereAddress.fromJson(address),
            position: HerePosition(
                lat: _currentLocation!.latitude,
                lng: _currentLocation!.longitude),
          );

          appDebugPrint('Đã chuyển đổi Placemark thành HereSearchResult');
        }
      } catch (e) {
        appDebugPrint('Lỗi khi lấy địa chỉ: $e');
      }

      if (addressDetail == null) {
        try {
          // Sử dụng HERE API để lấy địa chỉ từ tọa độ
          final String apiKey = hereMapApiKey; // Thay thế bằng API key thực tế
          final double lat = _currentLocation!.latitude;
          final double lng = _currentLocation!.longitude;
          final String url =
              'https://revgeocode.search.hereapi.com/v1/revgeocode?at=$lat,$lng&lang=en&apiKey=$apiKey';

          final dio = Dio();
          final response = await dio.get(url);
          if (response.statusCode == 200) {
            final data = response.data;
            if (data['items'] != null && data['items'].isNotEmpty) {
              final address = data['items'][0]['address'];
              final String formattedAddress = address['label'] ?? '';
              appDebugPrint('Địa chỉ hiện tại: $formattedAddress');
              addressDetail = HereSearchResult.fromJson(data['items'][0]);
              if (addressDetail!.address?.countryCode?.length == 3) {
                addressDetail!.address?.countryCode =
                    convertAlpha3toAlpha2(addressDetail!.address!.countryCode!);
              }
            }
          } else {
            appDebugPrint('Không thể lấy địa chỉ: ${response.statusCode}');
          }
        } catch (e) {
          appDebugPrint('Lỗi khi lấy địa chỉ: $e');
        }
      }
      if (addressDetail != null) {
        locationCubit.updateAddressDetail(addressDetail);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('addressDetail: ${addressDetail?.address?.countryCode}');
    if (addressDetail != null &&
        addressDetail!.address?.countryCode?.toLowerCase() != "hu") {
      return Scaffold(
        backgroundColor: appColorBackground,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                WidgetAssetImage.png(
                  'image4',
                  width: double.infinity,
                ),
                const SizedBox(height: 24),
                Text(
                  'Location Restricted',
                  style: w500TextStyle(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'This application only operates within Hungary. Please ensure your location is set to Hungary to continue using the app.',
                  textAlign: TextAlign.center,
                  style: w400TextStyle(
                    fontSize: 16,
                    color: appColorText2,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    }
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
        child: WidgetAssetImage.png(
          'image$indexImage',
          fit: BoxFit.scaleDown,
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
                                .tr(),
                        type: AppSnackBarType.error);
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
          Gap(12),
          _buildActionButton(
            icon: 'icon53',
            alsoLoading: false,
            label: 'Add other location'.tr(),
            onTap: () {
              appOpenBottomSheet(WidgetSheetLocations());
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
    bool alsoLoading = true,
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
                if (_isLoading && alsoLoading)
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

String convertAlpha3toAlpha2(String alpha3Code) {
  final country = CountryCodes.detailsForLocale(
      Locale.fromSubtags(countryCode: alpha3Code));
  return country.alpha2Code!.toLowerCase();
}
