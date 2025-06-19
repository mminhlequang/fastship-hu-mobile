import 'dart:async';
import 'dart:ui';

import 'package:app/src/presentation/socket_shell/controllers/socket_controller.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  FlutterBackgroundService? _backgroundService;
  bool _isServiceRunning = false;
  final _locationStreamController = StreamController<LatLng>.broadcast();

  Stream<LatLng> get locationStream => _locationStreamController.stream;

  Future<void> initialize() async {
    _backgroundService = FlutterBackgroundService();

    // Cấu hình notification cho background service
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'location_service_channel',
      'Location Service',
      description: 'This notification is used for the location service.',
      importance: Importance.low,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Cấu hình background service
    await _backgroundService?.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: 'location_service_channel',
        initialNotificationTitle: 'Location Service',
        initialNotificationContent: 'Tracking location in background',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );

    // Lắng nghe sự kiện location từ background service
    _backgroundService?.on('location_update').listen((event) {
      if (event != null &&
          event['latitude'] != null &&
          event['longitude'] != null) {
        final latLng = LatLng(
          event['latitude'] as double,
          event['longitude'] as double,
        );
        _locationStreamController.add(latLng);
      }
    });
  }

  // Callback khi service bắt đầu
  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    // Bắt đầu tracking location
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          await _updateLocation(service);
        }
      } else {
        await _updateLocation(service);
      }
    });
  }

  // Callback cho iOS background
  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    return true;
  }

  // Cập nhật vị trí và gửi lên server
  @pragma('vm:entry-point')
  static Future<void> _updateLocation(ServiceInstance service) async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      final latLng = LatLng(position.latitude, position.longitude);

      // Gửi vị trí qua event channel
      service.invoke('location_update', {
        'latitude': latLng.latitude,
        'longitude': latLng.longitude,
      });
    } catch (e) {
      print('Error updating location in background: $e');
    }
  }

  // Bắt đầu background service
  Future<void> startService() async {
    if (!_isServiceRunning) {
      await _backgroundService?.startService();
      _isServiceRunning = true;
    }
  }

  // Dừng background service
  Future<void> stopService() async {
    if (_isServiceRunning) {
      _backgroundService?.invoke('stopService');
      _isServiceRunning = false;
    }
  }

  // Kiểm tra service có đang chạy không
  bool get isServiceRunning => _isServiceRunning;

  void dispose() {
    _locationStreamController.close();
  }

  /// Check if location permission (always or when in use) is granted
  Future<bool> isLocationPermissionGranted() async {
    final whenInUseStatus = await Permission.locationWhenInUse.status;
    final alwaysStatus = await Permission.locationAlways.status;
    return whenInUseStatus.isGranted || alwaysStatus.isGranted;
  }
}
