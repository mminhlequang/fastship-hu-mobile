import 'dart:async';

import 'package:app/src/utils/app_get.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_constants.dart'; 
import 'controllers/socket_controller.dart';
import 'widgets/order_action_widget.dart';
import 'widgets/order_notification_widget.dart';
import 'widgets/order_complete_widget.dart';
import 'widgets/order_canceled_widget.dart';

class SocketShellWrapper extends StatefulWidget {
  final Widget child;
  const SocketShellWrapper({super.key, required this.child});

  @override
  State<SocketShellWrapper> createState() => _SocketShellWrapperState();
}

class _SocketShellWrapperState extends State<SocketShellWrapper> {
  SocketController get _socketController => findInstance<SocketController>();
  bool _isBlinking = false;
  Map<String, dynamic>? get _currentOrder => _socketController.currentOrder;

  // Controller để chơi âm thanh thông báo
  final AudioPlayer _audioPlayer = AudioPlayer();

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

      _socketController.onOrderStatusChanged = (status) {
        setState(() {});
      };

      _socketController.onPlayNotification = () {
        _playNotificationSound();
      };

      // Thêm xử lý cho profile được cập nhật
      _socketController.onProfileUpdated = (profileData) {
        setState(() {
          // Có thể lưu profile vào state hoặc provider nếu cần
          debugPrint('Đã nhận profile: ${profileData['name']}');
        });
      };

      // Thêm xử lý cho wallet được cập nhật
      _socketController.onWalletUpdated = (walletData) {
        setState(() {
          // Có thể lưu wallet vào state hoặc provider nếu cần
          debugPrint('Đã nhận wallet: ${walletData['balance']}');
        });
      };
    } catch (e) {
      debugPrint('Lỗi khi khởi tạo SocketController: $e');
    }
  }

  Future<void> _playNotificationSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
    } catch (e) {
      print('Audio error: $e');
    }
  }

  Future<void> _callCustomer() async {
    if (_currentOrder != null && _currentOrder!['customer_phone'] != null) {
      final phoneNumber = _currentOrder!['customer_phone'];
      final Uri url = Uri.parse('tel:$phoneNumber');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }

  Future<void> _sendSms(String message) async {
    if (_currentOrder != null && _currentOrder!['customer_phone'] != null) {
      final phoneNumber = _currentOrder!['customer_phone'];
      final Uri url = Uri.parse('sms:$phoneNumber?body=$message');
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
    _audioPlayer.dispose();
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
          child: _buildOrderStatusWidget(),
        ),
      ],
    );
  }

  Widget _buildOrderStatusWidget() {
    switch (_socketController.orderStatus) {
      case DriverOrderStatus.waiting:
        return const SizedBox(); // Không hiển thị gì

      case DriverOrderStatus.newOrder:
        return OrderNotificationWidget(
          order: _currentOrder!,
          isBlinking: _isBlinking,
          onAccept: _socketController.acceptOrder,
          onReject: _socketController.rejectOrder,
        );

      case DriverOrderStatus.accepted:
        // Sau khi chấp nhận đơn hàng, hiển thị widget cho phép tài xế xác nhận đã lấy hàng
        return OrderActionWidget(
          order: _currentOrder!,
          onUpdateStatus: (status) {
            if (status == 'picked_up') {
              _socketController.pickOrder();
            } else {
              _socketController.updateOrderStatus(status);
            }
          },
          onComplete: _socketController.completeOrder,
          onCall: _callCustomer,
          onSendSms: _sendSms,
        );

      case DriverOrderStatus.picked:
        // Tài xế đã lấy hàng, hiển thị các tùy chọn cho việc giao hàng
        return OrderActionWidget(
          order: _currentOrder!,
          onUpdateStatus: (status) {
            if (status == 'arrived_at_customer') {
              _socketController.startDelivery();
            } else {
              _socketController.updateOrderStatus(status);
            }
          },
          onComplete: _socketController.completeOrder,
          onCall: _callCustomer,
          onSendSms: _sendSms,
        );

      case DriverOrderStatus.inProgress:
        return OrderActionWidget(
          order: _currentOrder!,
          onUpdateStatus: _socketController.updateOrderStatus,
          onComplete: _socketController.completeOrder,
          onCall: _callCustomer,
          onSendSms: _sendSms,
        );

      case DriverOrderStatus.completed:
        return OrderCompleteWidget(
          order: _currentOrder!,
          onClose: _socketController.closeOrderComplete,
        );

      case DriverOrderStatus.canceled:
        return OrderCanceledWidget(
          order: _currentOrder!,
          onClose: _socketController.closeOrderCanceled,
          onContactSupport: _contactSupport,
        );

      default:
        return const SizedBox(); // Fallback cho trường hợp không xác định
    }
  }
}

// Placeholder cho AudioPlayer. Trong dự án thực, bạn cần sử dụng thư viện thực
class AudioPlayer {
  Future<void> play(AssetSource source) async {
    // Giả lập phát nhạc
    print('Playing sound: ${source.path}');
  }

  void dispose() {
    // Giả lập giải phóng tài nguyên
  }
}

class AssetSource {
  final String path;

  AssetSource(this.path);
}
