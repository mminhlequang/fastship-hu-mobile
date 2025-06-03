import 'dart:async';

import 'package:app/src/utils/app_get.dart';
import 'package:flutter/material.dart';
import 'package:network_resources/order/models/models.dart';

import 'controllers/socket_controller.dart';

class SocketShellWrapper extends StatefulWidget {
  final Widget child;
  const SocketShellWrapper({super.key, required this.child});

  @override
  State<SocketShellWrapper> createState() => _SocketShellWrapperState();
}

class _SocketShellWrapperState extends State<SocketShellWrapper> {
  SocketController get _socketController => findInstance<SocketController>();
  bool _isBlinking = false;
  OrderModel? get _currentOrder => _socketController.currentOrder;

  // Controller để chơi âm thanh thông báo
  // final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initSocketController();
  }

  void _initSocketController() {
    _socketController.init();
    try {
      _socketController.onBlinkingChanged = (isBlinking) {
        setState(() {
          _isBlinking = isBlinking;
        });
      };

      _socketController.onPlayNotification = () {
        _playNotificationSound();
      };
    } catch (e) {
      debugPrint('Lỗi khi khởi tạo SocketController: $e');
    }
  }

  Future<void> _playNotificationSound() async {
    //TODO:
  }


  @override
  void dispose() {
    _socketController.dispose();
    // _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
