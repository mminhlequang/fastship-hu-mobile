import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

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
      // Hiển thị dialog gợi ý mở cài đặt
      await _showOpenSettingsDialog();
      return false;
    }

    return false;
  }

  Future<bool?> _showPermissionExplanationDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.location_on, color: Colors.blue, size: 24),
            SizedBox(width: 8),
            Text('Quyền vị trí'),
          ],
        ),
        content: const Text(
          'Ứng dụng cần quyền truy cập vị trí để cập nhật vị trí của bạn và nhận đơn hàng gần đó. Nếu không có quyền này, ứng dụng sẽ không thể hoạt động đúng.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Từ chối'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Đồng ý'),
          ),
        ],
      ),
    );
  }

  Future<void> _showOpenSettingsDialog() async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quyền vị trí đã bị từ chối'),
        content: const Text(
          'Quyền vị trí là cực kỳ quan trọng để ứng dụng hoạt động. Bạn cần mở cài đặt để cấp quyền vị trí cho ứng dụng.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Mở cài đặt'),
          ),
        ],
      ),
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
