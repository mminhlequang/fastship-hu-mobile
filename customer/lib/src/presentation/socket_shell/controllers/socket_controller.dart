import 'dart:async';
import 'dart:convert';

import 'package:app/src/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
 
import '../../../utils/app_prefs.dart';
import '../models/socket_response.dart';

enum CustomerOrderStatus {
  noOrder, // Không có đơn hàng
  pending, // Đơn hàng mới, đang tìm tài xế
  assigned, // Đã tìm được tài xế
  accepted, // Tài xế đã chấp nhận đơn
  picked, // Tài xế đã lấy hàng
  inProgress, // Tài xế đang giao hàng
  completed, // Đơn hàng hoàn thành
  cancelled, // Đơn hàng bị hủy
}

CustomerSocketController get socketController =>
    findInstance<CustomerSocketController>();

class CustomerSocketController {
  IO.Socket? socket;
  CustomerOrderStatus _orderStatus = CustomerOrderStatus.noOrder;
  Map<String, dynamic>? _currentOrder;
  Map<String, dynamic>? _driverLocation;
  Map<String, dynamic>? _driverInfo;

  // ValueNotifier để theo dõi trạng thái kết nối socket
  final ValueNotifier<bool> socketConnected = ValueNotifier<bool>(false);

  // Các callback để cập nhật UI
  Function(CustomerOrderStatus)? onOrderStatusChanged;
  Function(Map<String, dynamic>)? onOrderCreated;
  Function(Map<String, dynamic>)? onOrderUpdated;
  Function(Map<String, dynamic>)? onDriverAssigned;
  Function(Map<String, dynamic>)? onDriverLocationUpdated;
  Function()? onPlayNotification;

  // Getters
  CustomerOrderStatus get orderStatus => _orderStatus;
  Map<String, dynamic>? get currentOrder => _currentOrder;
  Map<String, dynamic>? get driverLocation => _driverLocation;
  Map<String, dynamic>? get driverInfo => _driverInfo;

   

  void initializeSocket() {
    try {
      debugPrint('Debug socket: Bắt đầu khởi tạo socket');
      socket = IO.io(
        socketIOUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableForceNew()
            .build(),
      );

      socket?.onConnect((_) {
        debugPrint('Debug socket: Đã kết nối thành công');
        socketConnected.value = true;
        _authenticate();
      });

      socket?.onDisconnect((_) {
        debugPrint('Debug socket: Đã ngắt kết nối');
        socketConnected.value = false;
      });

      // Xử lý khi đơn hàng được tạo
      socket?.on('order_created', (data) {
        debugPrint('Debug socket: Đơn hàng đã được tạo');
        _handleOrderCreated(data);
      });

      // Xử lý khi tài xế được gán cho đơn hàng
      socket?.on('driver_assigned', (data) {
        debugPrint('Debug socket: Tài xế đã được gán cho đơn hàng');
        _handleDriverAssigned(data);
      });

      // Xử lý khi tài xế cập nhật vị trí
      socket?.on('driver_location_updated', (data) {
        _handleDriverLocationUpdated(data);
      });

      // Xử lý khi trạng thái đơn hàng thay đổi
      socket?.on('order_status_updated', (data) {
        debugPrint('Debug socket: Trạng thái đơn hàng đã cập nhật');
        _handleOrderStatusUpdated(data);
      });

      // Xử lý khi đơn hàng bị hủy
      socket?.on('order_cancelled', (data) {
        debugPrint('Debug socket: Đơn hàng đã bị hủy');
        _handleOrderCancelled(data);
      });

      // Xử lý lỗi
      socket?.on('error', (data) {
        final socketResponse = _parseSocketResponse(data);
        debugPrint(
            'Debug socket: Lỗi: ${socketResponse.messageCode} - ${socketResponse.data != null ? socketResponse.data['message'] : ''}');
      });

      socket?.connect();
      debugPrint('Debug socket: Đã gọi lệnh kết nối');
    } catch (e) {
      debugPrint('Debug socket: Lỗi kết nối socket: $e');
    }
  }

  // Xác thực người dùng
  void _authenticate() async {
    debugPrint('Debug socket: Bắt đầu xác thực');
    final customerId = await AppPrefs.instance.user?.id;
    debugPrint(
        'Debug socket: Đã lấy customerId: ${customerId != null ? 'có id' : 'không có id'}');

    if (customerId != null && socket?.connected == true) {
      debugPrint('Debug socket: Gửi customerId xác thực');
      socket?.emit('authenticate_customer', {'customerId': customerId});
    }
  }

  // Tạo đơn hàng mới
  void createOrder(Map<String, dynamic> orderData) {
    if (socket?.connected == true) {
      debugPrint('Debug socket: Tạo đơn hàng mới');
      socket?.emit('create_order', orderData);
    } else {
      debugPrint('Debug socket: Không thể tạo đơn hàng - socket chưa kết nối');
    }
  }

  // Hủy đơn hàng
  void cancelOrder({String? reason}) {
    if (_currentOrder != null && socket?.connected == true) {
      debugPrint('Debug socket: Hủy đơn hàng ${_currentOrder!['orderId']}');

      final Map<String, dynamic> data = {
        'order_id': _currentOrder!['orderId'],
      };

      if (reason != null) {
        data['reason'] = reason;
      }

      socket?.emit('cancel_order', data);
    } else {
      debugPrint(
          'Debug socket: Không thể hủy đơn hàng - không có đơn hoặc socket chưa kết nối');
    }
  }

  // Đánh giá đơn hàng
  void rateOrder(int rating, {String? comment}) {
    if (_currentOrder != null && socket?.connected == true) {
      debugPrint(
          'Debug socket: Đánh giá đơn hàng ${_currentOrder!['orderId']} - $rating sao');

      final Map<String, dynamic> data = {
        'order_id': _currentOrder!['orderId'],
        'rating': rating,
      };

      if (comment != null) {
        data['comment'] = comment;
      }

      socket?.emit('rate_order', data);
    }
  }

  // Đóng đơn hàng đã hoàn thành
  void closeOrderComplete() {
    _orderStatus = CustomerOrderStatus.noOrder;
    _currentOrder = null;
    _driverLocation = null;
    _driverInfo = null;
    onOrderStatusChanged?.call(_orderStatus);
  }

  // Đóng đơn hàng đã hủy
  void closeOrderCanceled() {
    _orderStatus = CustomerOrderStatus.noOrder;
    _currentOrder = null;
    _driverLocation = null;
    _driverInfo = null;
    onOrderStatusChanged?.call(_orderStatus);
  }

  // Xử lý khi đơn hàng được tạo
  void _handleOrderCreated(dynamic data) {
    final socketResponse = _parseSocketResponse(data);

    if (socketResponse.isSuccess && socketResponse.data != null) {
      _currentOrder = Map<String, dynamic>.from(socketResponse.data);
      _orderStatus = CustomerOrderStatus.pending;

      debugPrint(
          'Debug socket: Đơn hàng mới đã được tạo: ${jsonEncode(_currentOrder)}');

      onOrderStatusChanged?.call(_orderStatus);
      onOrderCreated?.call(_currentOrder!);
      onPlayNotification?.call();
    } else {
      debugPrint(
          'Debug socket: Lỗi khi tạo đơn hàng: ${socketResponse.messageCode}');
    }
  }

  // Xử lý khi tài xế được gán cho đơn hàng
  void _handleDriverAssigned(dynamic data) {
    final socketResponse = _parseSocketResponse(data);

    if (socketResponse.isSuccess && socketResponse.data != null) {
      // Cập nhật thông tin đơn hàng và tài xế
      _currentOrder = Map<String, dynamic>.from(socketResponse.data);
      _driverInfo = socketResponse.data['driver'];
      _orderStatus = CustomerOrderStatus.assigned;

      debugPrint(
          'Debug socket: Tài xế đã được gán cho đơn hàng: ${jsonEncode(_driverInfo)}');

      onOrderStatusChanged?.call(_orderStatus);
      onDriverAssigned?.call(_driverInfo!);
      onPlayNotification?.call();
    } else {
      debugPrint(
          'Debug socket: Lỗi khi gán tài xế: ${socketResponse.messageCode}');
    }
  }

  // Xử lý khi tài xế cập nhật vị trí
  void _handleDriverLocationUpdated(dynamic data) {
    final socketResponse = _parseSocketResponse(data);

    if (socketResponse.isSuccess && socketResponse.data != null) {
      _driverLocation = Map<String, dynamic>.from(socketResponse.data);

      debugPrint(
          'Debug socket: Vị trí tài xế đã cập nhật: ${jsonEncode(_driverLocation)}');

      onDriverLocationUpdated?.call(_driverLocation!);
    }
  }

  // Xử lý khi trạng thái đơn hàng thay đổi
  void _handleOrderStatusUpdated(dynamic data) {
    final socketResponse = _parseSocketResponse(data);

    if (socketResponse.isSuccess && socketResponse.data != null) {
      _currentOrder = Map<String, dynamic>.from(socketResponse.data);

      // Cập nhật trạng thái dựa trên dữ liệu nhận được
      final String orderStatus = _currentOrder!['status'] ?? '';

      switch (orderStatus) {
        case 'accepted':
          _orderStatus = CustomerOrderStatus.accepted;
          break;
        case 'picked':
          _orderStatus = CustomerOrderStatus.picked;
          break;
        case 'in_progress':
          _orderStatus = CustomerOrderStatus.inProgress;
          break;
        case 'completed':
          _orderStatus = CustomerOrderStatus.completed;
          break;
        case 'cancelled':
          _orderStatus = CustomerOrderStatus.cancelled;
          break;
      }

      debugPrint('Debug socket: Cập nhật trạng thái đơn hàng: $orderStatus');

      onOrderStatusChanged?.call(_orderStatus);
      onOrderUpdated?.call(_currentOrder!);
      onPlayNotification?.call();
    } else {
      debugPrint(
          'Debug socket: Lỗi khi cập nhật trạng thái đơn hàng: ${socketResponse.messageCode}');
    }
  }

  // Xử lý khi đơn hàng bị hủy
  void _handleOrderCancelled(dynamic data) {
    final socketResponse = _parseSocketResponse(data);

    if (socketResponse.isSuccess && socketResponse.data != null) {
      _currentOrder = Map<String, dynamic>.from(socketResponse.data);
      _orderStatus = CustomerOrderStatus.cancelled;

      debugPrint(
          'Debug socket: Đơn hàng đã bị hủy: ${jsonEncode(_currentOrder)}');

      onOrderStatusChanged?.call(_orderStatus);
      onOrderUpdated?.call(_currentOrder!);
      onPlayNotification?.call();
    } else {
      debugPrint(
          'Debug socket: Lỗi khi hủy đơn hàng: ${socketResponse.messageCode}');
    }
  }

  // Phương thức giải phóng tài nguyên
  void dispose() {
    debugPrint('Debug socket: Hủy CustomerSocketController');
    socket?.disconnect();
    socket?.dispose();
    socketConnected.dispose();
  }

  // Phương thức trợ giúp phân tích phản hồi từ socket
  SocketResponse _parseSocketResponse(dynamic data) {
    try {
      final Map<String, dynamic> jsonData =
          data is String ? jsonDecode(data) : Map<String, dynamic>.from(data);
      return SocketResponse.fromJson(jsonData);
    } catch (e) {
      debugPrint('Debug socket: Lỗi phân tích dữ liệu socket: $e');
      return SocketResponse(
        isSuccess: false,
        timestamp: DateTime.now().toIso8601String(),
        messageCode: 'PARSE_ERROR',
        data: {'message': 'Lỗi phân tích dữ liệu', 'original': data},
      );
    }
  }
}

// Function helper for DI
CustomerSocketController findInstance<T>() {
  // This is a temporary implementation. You should replace this with your actual DI implementation
  return CustomerSocketController();
}
