import 'dart:async';

import 'package:app/src/base/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'controllers/socket_controller.dart';

class SocketShellWrapper extends StatefulWidget {
  final Widget child;

  const SocketShellWrapper({
    super.key,
    required this.child,
  });

  @override
  State<SocketShellWrapper> createState() => _SocketShellWrapperState();
}

class _SocketShellWrapperState extends State<SocketShellWrapper> {
  @override
  void initState() {
    super.initState();
    if (authCubit.isLoggedIn) {
      socketController.initializeSocket();
    }
    _checkNotificationPermission();
  }

  @override
  void dispose() {
    super.dispose();
    socketController.dispose();
  }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      _showNotificationPermissionDialog();
    }
  }

  void _showNotificationPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thông báo'),
        content: const Text(
            'Ứng dụng cần quyền thông báo để gửi cập nhật về đơn hàng của bạn.'),
        actions: [
          TextButton(
            child: const Text('Để sau'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Cài đặt'),
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
