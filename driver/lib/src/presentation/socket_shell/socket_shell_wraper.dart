import 'dart:async';

import 'package:app/src/presentation/widgets/widget_loader.dart';
import 'package:app/src/utils/app_get.dart';
import 'package:flutter/material.dart';
import 'package:network_resources/network_resources.dart';
import 'package:network_resources/order/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_constants.dart';
import 'controllers/socket_controller.dart';
import 'widgets/order_states.dart';

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

  Future<void> _callCustomer() async {
    if (_currentOrder != null && _currentOrder!.customer?.phone != null) {
      final Uri url = Uri.parse('tel:${_currentOrder!.customer?.phone!}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }

  Future<void> _sendSms(String message) async {
    if (_currentOrder != null && _currentOrder!.customer?.phone != null) {
      final Uri url =
          Uri.parse('sms:${_currentOrder!.customer?.phone}?body=$message');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }

  Future<void> _contactSupport() async {
    final Uri url = Uri.parse('tel:$supportPhoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  void dispose() {
    _socketController.dispose();
    // _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        // Online/Offline switch
        // Positioned(
        //   top: MediaQuery.of(context).padding.top + 10,
        //   right: 10,
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(20),
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.black.withOpacity(0.1),
        //           blurRadius: 5,
        //           spreadRadius: 1,
        //         ),
        //       ],
        //     ),
        //     child: Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Text(
        //           _isOnline ? 'Online' : 'Offline',
        //           style: TextStyle(
        //             color: _isOnline ? Colors.green : Colors.red,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //         const SizedBox(width: 8),
        //         Switch(
        //           value: _isOnline,
        //           onChanged: _setOnlineStatus,
        //           activeColor: Colors.green,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        // Trạng thái đơn hàng
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ValueListenableBuilder<AppOrderProcessStatus>(
            valueListenable: _socketController.orderStatus,
            builder: (context, value, child) {
              if (value == AppOrderProcessStatus.pending) {
                return const SizedBox.shrink();
              }

              return WidgetOrderStates(
                processStatus: value,
                order: _currentOrder,
                // onStatusChanged: _socketController.updateOrderStatus,
              );
            },
          ),
        ),
        // ValueListenableBuilder<bool>(
        //   valueListenable: _socketController.socketConnected,
        //   builder: (context, value, child) {
        //     return !value
        //         ? Container(
        //             color: Colors.black.withOpacity(0.1),
        //             child: const WidgetAppLoader(),
        //           )
        //         : const SizedBox.shrink();
        //   },
        // ),
      ],
    );
  }
}
