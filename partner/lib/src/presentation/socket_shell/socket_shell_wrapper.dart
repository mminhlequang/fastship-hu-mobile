import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_colors.dart';
import '../../utils/app_prefs.dart';
import 'widgets/order_status_widget.dart';
import 'widgets/order_tracking_widget.dart';
import 'widgets/order_complete_widget.dart';
import 'widgets/order_canceled_widget.dart';

enum OrderStatus {
  accepted, // Đã nhận đơn
  delivery, // Đang giao
  completed, // Hoàn thành
  canceled, // Đã hủy
}

class SocketShellWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onOrderReceived;

  const SocketShellWrapper({
    Key? key,
    required this.child,
    this.onOrderReceived,
  }) : super(key: key);

  @override
  State<SocketShellWrapper> createState() => _SocketShellWrapperState();
}

class _SocketShellWrapperState extends State<SocketShellWrapper> {
  Map<String, dynamic>? _currentOrder;
  OrderStatus? _currentStatus;
  Map<String, dynamic>? _driverLocation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isOrderVisible = false;
  Timer? _notificationTimer;

  @override
  void initState() {
    super.initState();
    _setupSocketListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _notificationTimer?.cancel();
    super.dispose();
  } 

  Future<void> _setupSocketListeners() async {
    // TODO: Implement socket connection
    // Giả lập dữ liệu để test UI
    await Future.delayed(const Duration(seconds: 3));
    _simulateOrderData();
  }

  void _simulateOrderData() {
    final Map<String, dynamic> orderData = {
      'id': 'ORD123456',
      'restaurant': {
        'name': 'Phở Hà Nội',
        'address': '123 Lê Lợi, Q.1, TP.HCM',
        'phone': '0901234567'
      },
      'items': [
        {'name': 'Phở bò tái', 'quantity': 1, 'price': 45000},
        {'name': 'Chả giò', 'quantity': 2, 'price': 25000},
        {'name': 'Coca-Cola', 'quantity': 1, 'price': 15000},
      ],
      'total': 110000,
      'deliveryFee': 15000,
      'promocode': 25000,
      'finalTotal': 100000,
      'status': 'accepted',
      'estimatedTime': DateTime.now().add(const Duration(minutes: 30)).toIso8601String(),
      'driver': {
        'name': 'Nguyễn Văn A',
        'phone': '0901234567',
        'vehicle': 'Honda Wave',
        'licensePlate': '59-Y1 12345',
        'avatar': 'https://i.pravatar.cc/150?img=8'
      }
    };

    setState(() {
      _currentOrder = orderData;
      _currentStatus = OrderStatus.accepted;
      _isOrderVisible = true;
    });

    _playNotificationSound();

    // Giả lập cập nhật trạng thái
    Future.delayed(const Duration(seconds: 20), () {
      if (mounted) {
        setState(() {
          _currentStatus = OrderStatus.delivery;
          _driverLocation = {
            'lat': 10.7769,
            'lng': 106.7009,
            'address': 'Đang di chuyển trên đường Nguyễn Huệ'
          };
        });
        _playNotificationSound();
      }
    });

    Future.delayed(const Duration(seconds: 40), () {
      if (mounted) {
        setState(() {
          _currentStatus = OrderStatus.completed;
        });
        _playNotificationSound();
      }
    });
  }

  Future<void> _playNotificationSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
    } catch (e) {
      debugPrint('Error playing notification sound: $e');
    }
  }
 

  Future<void> _callDriver() async {
    if (_currentOrder != null && _currentOrder!['driver'] != null) {
      final phone = _currentOrder!['driver']['phone'];
      final Uri uri = Uri.parse('tel:$phone');

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

  Future<void> _contactSupport() async {
    final Uri uri = Uri.parse('tel:19001234');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _cancelOrder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy đơn hàng'),
        content: const Text('Bạn có chắc muốn hủy đơn hàng này không?'),
        actions: [
          TextButton(
            child: const Text('Không'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Có', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentStatus = OrderStatus.canceled;
              });
            },
          ),
        ],
      ),
    );
  }

  void _closeOrderView() {
    setState(() {
      _isOrderVisible = false;
      _currentOrder = null;
      _currentStatus = null;
      _driverLocation = null;
    });
  }

  void _rateOrder(double rating, String comment) {
    // TODO: Implement API call to submit rating
    _closeOrderView();
  }

  Widget _buildOrderStatusWidget() {
    if (!_isOrderVisible || _currentOrder == null || _currentStatus == null) {
      return const SizedBox.shrink();
    }

    switch (_currentStatus) {
      case OrderStatus.accepted:
        return OrderStatusWidget(
          order: _currentOrder!,
          status: 'Đơn hàng đã được nhận',
          onCancel: _cancelOrder,
        );

      case OrderStatus.delivery:
        return OrderTrackingWidget(
          order: _currentOrder!,
          status: 'Đang giao hàng',
          driverLocation: _driverLocation,
          onCallDriver: _callDriver,
        );

      case OrderStatus.completed:
        return OrderCompleteWidget(
          order: _currentOrder!,
          onClose: _closeOrderView,
          onRateOrder: (int rating, String? comment) {
            // _rateOrder(rating, comment);
          },
        );

      case OrderStatus.canceled:
        return OrderCanceledWidget(
          order: _currentOrder!,
          onClose: _closeOrderView,
          onContactSupport: _contactSupport,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main app content
        widget.child,

        // Order status overlay
        // if (_isOrderVisible && _currentOrder != null)
        //   Positioned(
        //     bottom: 0,
        //     left: 0,
        //     right: 0,
        //     child: Container(
        //       margin: const EdgeInsets.all(16),
        //       child: _buildOrderStatusWidget(),
        //     ),
        //   ),
      ],
    );
  }
}

// Placeholder cho AudioPlayer
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
