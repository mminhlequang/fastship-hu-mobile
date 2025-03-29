import 'package:app/src/presentation/widgets/widget_location_blocked.dart';
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
    return WidgetLocationPermissionBlocked();
  }
}
