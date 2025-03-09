import 'dart:async';

import 'package:app/src/utils/app_get.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/app_constants.dart';
import '../../utils/app_utils.dart';
import 'controllers/socket_controller.dart';
import 'widgets/order_action_widget.dart';
import 'widgets/order_notification_widget.dart';
import 'widgets/order_complete_widget.dart';
import 'widgets/order_canceled_widget.dart';

class SocketShellWraper extends StatefulWidget {
  final Widget child;
  const SocketShellWraper({super.key, required this.child});

  @override
  State<SocketShellWraper> createState() => _SocketShellWraperState();
}

class _SocketShellWraperState extends State<SocketShellWraper> {
  SocketController get _socketController => findInstance<SocketController>();
  bool _isBlinking = false;
  Map<String, dynamic>? get _currentOrder => _socketController.currentOrder;
  OrderStatus? _currentStatus;

  // Controller để chơi âm thanh thông báo
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initSocketController();
    _checkPermissions();
  }

  // Kiểm tra và yêu cầu các quyền cần thiết
  Future<void> _checkPermissions() async {
    // Kiểm tra quyền thông báo
    await _checkNotificationPermission();
  }

  // Kiểm tra và yêu cầu quyền thông báo
  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;

    if (status.isDenied) {
      // Hiển thị dialog tùy chỉnh giải thích lý do cần quyền thông báo
      await appOpenDialog(
        _buildPermissionDialog(
          title: 'Quyền thông báo',
          content:
              'Ứng dụng cần quyền gửi thông báo để bạn không bỏ lỡ đơn hàng mới và cập nhật quan trọng.',
          iconData: Icons.notifications,
          iconColor: Colors.orange,
        ),
      );

      // Nếu người dùng đồng ý, hiển thị dialog hệ thống
      await Permission.notification.request();

      // Kiểm tra xem người dùng đã cấp quyền chưa
      final newStatus = await Permission.notification.status;
      if (newStatus.isPermanentlyDenied) {
        // Người dùng đã từ chối vĩnh viễn, gợi ý mở cài đặt
        await _showOpenSettingsDialog('Quyền thông báo đã bị từ chối vĩnh viễn',
            'Vui lòng mở cài đặt để cấp quyền thông báo cho ứng dụng.');
      }
    }
  }

  // Hiển thị dialog gợi ý mở cài đặt
  Future<void> _showOpenSettingsDialog(String title, String content) async {
    await appOpenDialog(
      AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Để sau'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
              openAppSettings();
            },
            child: const Text('Mở cài đặt'),
          ),
        ],
      ),
    );
  }

  // Xây dựng dialog quyền tùy chỉnh
  Widget _buildPermissionDialog({
    required String title,
    required String content,
    required IconData iconData,
    required Color iconColor,
  }) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(iconData, color: iconColor, size: 24),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: Text(content),
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
    );
  }

  void _initSocketController() {
    try {
      _socketController.onBlinkingChanged = (isBlinking) {
        setState(() {
          _isBlinking = isBlinking;
        });
      };

      _socketController.onOrderStatusChanged = (status) {
        setState(() {
          _currentStatus = status;
        });
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
      case OrderStatus.waiting:
        return const SizedBox(); // Không hiển thị gì

      case OrderStatus.newOrder:
        return OrderNotificationWidget(
          order: _currentOrder!,
          isBlinking: _isBlinking,
          onAccept: _socketController.acceptOrder,
          onReject: _socketController.rejectOrder,
        );

      case OrderStatus.inProgress:
        return OrderActionWidget(
          order: _currentOrder!,
          onUpdateStatus: _socketController.updateOrderStatus,
          onComplete: _socketController.completeOrder,
          onCall: _callCustomer,
          onSendSms: _sendSms,
        );

      case OrderStatus.completed:
        return OrderCompleteWidget(
          order: _currentOrder!,
          onClose: _socketController.closeOrderComplete,
        );

      case OrderStatus.canceled:
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
