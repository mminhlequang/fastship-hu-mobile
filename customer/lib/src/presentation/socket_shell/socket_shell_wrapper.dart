import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'controllers/socket_controller.dart';
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

  const SocketShellWrapper({
    super.key,
    required this.child,
  });

  @override
  State<SocketShellWrapper> createState() => _SocketShellWrapperState();
}

class _SocketShellWrapperState extends State<SocketShellWrapper> {
  Map<String, dynamic>? _currentOrder;
  OrderStatus? _currentStatus;
  Map<String, dynamic>? _driverLocation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isOrderVisible = false;
  bool _isMinimized = false;
  Timer? _notificationTimer;

  @override
  void initState() {
    super.initState();
    _setupSocketListeners();
    _checkNotificationPermission();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _notificationTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      _showNotificationPermissionDialog();
    }
  }

  Future<void> _setupSocketListeners() async {
    socketController.initializeSocket();
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
      'estimatedTime':
          DateTime.now().add(const Duration(minutes: 30)).toIso8601String(),
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
    // try {
    //   await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
    // } catch (e) {
    //   debugPrint('Error playing notification sound: $e');
    // }
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

  void _toggleMinimize() {
    setState(() {
      _isMinimized = !_isMinimized;
    });
  }

  Widget _buildMinimizedWidget() {
    if (_currentOrder == null || _currentStatus == null)
      return const SizedBox.shrink();

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleMinimize,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getStatusIcon(),
                color: _getStatusColor(),
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                _getStatusText(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon() {
    switch (_currentStatus) {
      case OrderStatus.accepted:
        return Icons.check_circle;
      case OrderStatus.delivery:
        return Icons.delivery_dining;
      case OrderStatus.completed:
        return Icons.check_circle_outline;
      case OrderStatus.canceled:
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor() {
    switch (_currentStatus) {
      case OrderStatus.accepted:
        return Colors.orange;
      case OrderStatus.delivery:
        return Colors.blue;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.canceled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (_currentStatus) {
      case OrderStatus.accepted:
        return 'Đã nhận đơn';
      case OrderStatus.delivery:
        return 'Đang giao';
      case OrderStatus.completed:
        return 'Hoàn thành';
      case OrderStatus.canceled:
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
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
        widget.child,

        // Order status overlay
        if (_isOrderVisible && _currentOrder != null)
          Positioned(
            bottom: 16 + MediaQuery.paddingOf(context).bottom,
            left: 16,
            right: 16,
            child: _isMinimized
                ? Align(
                    alignment: Alignment.centerRight,
                    child: _buildMinimizedWidget(),
                  )
                : Material(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.minimize,
                              color: Colors.grey[600],
                            ),
                            onPressed: _toggleMinimize,
                          ),
                        ),
                        _buildOrderStatusWidget(),
                      ],
                    ),
                  ),
          ),
      ],
    );
  }
}
