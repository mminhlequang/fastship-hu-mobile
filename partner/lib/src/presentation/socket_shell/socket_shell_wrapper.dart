import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_colors.dart';
import '../../utils/app_prefs.dart';
import 'controllers/socket_controller.dart';
import 'widgets/order_status_widget.dart';
import 'widgets/order_tracking_widget.dart';
import 'widgets/order_complete_widget.dart';
import 'widgets/order_canceled_widget.dart';
 

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
    socketController.initializeSocket();
  }

  @override
  void dispose() {
    super.dispose();
    socketController.dispose();
  } 
 

  Future<void> _callDriver() async {
    // if (_currentOrder != null && _currentOrder!['driver'] != null) {
    //   final phone = _currentOrder!['driver']['phone'];
    //   final Uri uri = Uri.parse('tel:$phone');

    //   if (await canLaunchUrl(uri)) {
    //     await launchUrl(uri);
    //   }
    // }
  }

  Future<void> _contactSupport() async {
    final Uri uri = Uri.parse('tel:19001234');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _cancelOrder() {
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: const Text('Hủy đơn hàng'),
    //     content: const Text('Bạn có chắc muốn hủy đơn hàng này không?'),
    //     actions: [
    //       TextButton(
    //         child: const Text('Không'),
    //         onPressed: () => Navigator.pop(context),
    //       ),
    //       TextButton(
    //         child: const Text('Có', style: TextStyle(color: Colors.red)),
    //         onPressed: () {
    //           Navigator.pop(context);
    //           setState(() {
    //             _currentStatus = OrderStatus.canceled;
    //           });
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }

  void _closeOrderView() {
    // setState(() {
    //   _isOrderVisible = false;
    //   _currentOrder = null;
    //   _currentStatus = null;
    //   _driverLocation = null;
    // });
  }

  void _rateOrder(double rating, String comment) {
    // TODO: Implement API call to submit rating
    _closeOrderView();
  }

  // Widget _buildOrderStatusWidget() {
  //   if (!_isOrderVisible || _currentOrder == null || _currentStatus == null) {
  //     return const SizedBox.shrink();
  //   }

  //   switch (_currentStatus) {
  //     case OrderStatus.accepted:
  //       return OrderStatusWidget(
  //         order: _currentOrder!,
  //         status: 'Đơn hàng đã được nhận',
  //         onCancel: _cancelOrder,
  //       );

  //     case OrderStatus.delivery:
  //       return OrderTrackingWidget(
  //         order: _currentOrder!,
  //         status: 'Đang giao hàng',
  //         driverLocation: _driverLocation,
  //         onCallDriver: _callDriver,
  //       );

  //     case OrderStatus.completed:
  //       return OrderCompleteWidget(
  //         order: _currentOrder!,
  //         onClose: _closeOrderView,
  //         onRateOrder: (int rating, String? comment) {
  //           // _rateOrder(rating, comment);
  //         },
  //       );

  //     case OrderStatus.canceled:
  //       return OrderCanceledWidget(
  //         order: _currentOrder!,
  //         onClose: _closeOrderView,
  //         onContactSupport: _contactSupport,
  //       );

  //     default:
  //       return const SizedBox.shrink();
  //   }
  // }

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
 