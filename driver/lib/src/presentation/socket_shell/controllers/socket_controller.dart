import 'dart:async';
import 'dart:convert';

import 'package:app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vibration/vibration.dart';

import '../../../constants/app_constants.dart';
import '../../../utils/app_prefs.dart';

enum OrderStatus {
  waiting, // 0
  newOrder, // 1
  inProgress, // 2
  completed, // 3
  canceled, // 4
}

SocketController get socketController => findInstance<SocketController>();

class SocketController {
  IO.Socket? socket;
  Timer? _locationTimer;
  bool _isOnline = false;
  Map<String, dynamic>? _currentOrder;
  OrderStatus _orderStatus = OrderStatus.waiting;
  final ValueNotifier<bool> socketConnected = ValueNotifier<bool>(false);

  // Callback cho việc cập nhật UI
  Function(Map<String, dynamic>)? onNewOrder;
  Function(Map<String, dynamic>)? onOrderCanceled;
  Function(Map<String, dynamic>)? onOrderStatusUpdated;
  Function(bool)? onBlinkingChanged;
  Function(OrderStatus)? onOrderStatusChanged;
  Function()? onPlayNotification;

  // Thêm callback cho phần profile và ví
  Function(Map<String, dynamic>)? onProfileUpdated;
  Function(Map<String, dynamic>)? onWalletUpdated;

  // Thêm biến lưu thông tin profile và wallet
  Map<String, dynamic>? _profile;
  Map<String, dynamic>? _wallet;

  Map<String, dynamic>? get profile => _profile;
  Map<String, dynamic>? get wallet => _wallet;

  bool get isOnline => _isOnline;
  OrderStatus get orderStatus => _orderStatus;
  Map<String, dynamic>? get currentOrder => _currentOrder;

  SocketController() {
    debugPrint('Debug socket: Khởi tạo SocketController');
    _initializeSocket();
    _checkOnlineStatus();
  }

  Future<void> _checkOnlineStatus() async {
    final bool savedStatus = AppPrefs.instance.isDriverOnline;
    debugPrint('Debug socket: Trạng thái online đã lưu: $savedStatus');
    if (savedStatus) {
      setOnlineStatus(true);
    }
  }

  void _initializeSocket() {
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

      socket?.on('new_order', (data) {
        debugPrint('Debug socket: Nhận đơn hàng mới');
        _handleNewOrder(data);
      });

      socket?.on('order_canceled', (data) {
        debugPrint('Debug socket: Đơn hàng bị hủy');
        _handleOrderCanceled(data);
      });

      socket?.on('order_status_updated', (data) {
        debugPrint('Debug socket: Trạng thái đơn hàng cập nhật');
        _handleOrderStatusUpdate(data);
      });

      // Thêm xử lý event nhận phản hồi xác thực thành công
      socket?.on('authentication_success', (data) {
        debugPrint('Debug socket: Xác thực thành công');
        final responseData = data is String ? jsonDecode(data) : data;

        // Lưu thông tin profile và wallet
        if (responseData['profile'] != null) {
          _profile = Map<String, dynamic>.from(responseData['profile']);
          onProfileUpdated?.call(_profile!);
          debugPrint('Debug socket: Đã nhận thông tin profile');
        }

        if (responseData['wallet'] != null) {
          _wallet = Map<String, dynamic>.from(responseData['wallet']);
          onWalletUpdated?.call(_wallet!);
          debugPrint('Debug socket: Đã nhận thông tin wallet');
        }

        // Khôi phục trạng thái online/offline
        if (_isOnline) {
          debugPrint('Debug socket: Khôi phục trạng thái online');
          _emitDriverStatus(true);
        }
      });

      // Thêm xử lý event lỗi xác thực
      socket?.on('authentication_error', (data) {
        final errorData = data is String ? jsonDecode(data) : data;
        debugPrint('Debug socket: Lỗi xác thực: ${errorData['message']}');
        // Có thể thêm xử lý khi xác thực thất bại
      });

      socket?.on('error', (data) {
        debugPrint('Debug socket: on error=$data');
      });

      

      socket?.connect();
      debugPrint('Debug socket: Đã gọi lệnh kết nối');
    } catch (e) {
      debugPrint('Debug socket: Lỗi kết nối socket: $e');
    }
  }

  void _authenticate() async {
    debugPrint('Debug socket: Bắt đầu xác thực');
    final token = await AppPrefs.instance.getNormalToken();
    debugPrint(
        'Debug socket: Đã lấy token: ${token != null ? 'có token' : 'không có token'}');
    if (token != null && socket?.connected == true) {
      debugPrint(
          'Debug socket: Gửi token xác thực với event authenticate_driver');
      socket?.emit('authenticate_driver', {'token': token});
    }
  }

  void setOnlineStatus(bool isOnline) {
    debugPrint('Debug socket: Đặt trạng thái online: $isOnline');
    _isOnline = isOnline;

    // Lưu trạng thái
    AppPrefs.instance.isDriverOnline = isOnline;

    // Gửi trạng thái lên server
    _emitDriverStatus(isOnline);

    // Quản lý timer vị trí
    if (isOnline) {
      _startLocationUpdates();
    } else {
      _stopLocationUpdates();
    }
  }

  void _emitDriverStatus(bool isOnline) {
    debugPrint(
        'Debug socket: Gửi trạng thái tài xế: ${isOnline ? 'online' : 'offline'}');
    if (socket?.connected == true) {
      socket?.emit(
          'driver_status_update', {'status': isOnline ? 'online' : 'offline'});

      // Thêm xử lý phản hồi từ server
      socket?.once('driver_status_updated', (data) {
        final responseData = data is String ? jsonDecode(data) : data;
        debugPrint(
            'Debug socket: Trạng thái đã được cập nhật: ${responseData['status']}');
      });
    } else {
      debugPrint(
          'Debug socket: Không thể gửi trạng thái vì socket chưa kết nối');
    }
  }

  void _startLocationUpdates() {
    debugPrint('Debug socket: Bắt đầu cập nhật vị trí');
    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      debugPrint('Debug socket: Timer cập nhật vị trí kích hoạt');
      _sendCurrentLocation();
    });

    // Gửi vị trí ngay lập tức
    _sendCurrentLocation();
  }

  void _stopLocationUpdates() {
    debugPrint('Debug socket: Dừng cập nhật vị trí');
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  Future<void> _sendCurrentLocation() async {
    debugPrint('Debug socket: Đang lấy vị trí hiện tại');
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      debugPrint(
          'Debug socket: Đã lấy vị trí: ${position.latitude}, ${position.longitude}');

      if (socket?.connected == true && _isOnline) {
        debugPrint('Debug socket: Gửi vị trí lên server');
        socket?.emit('update_location', {
          'latitude': position.latitude,
          'longitude': position.longitude,
        });

        // Đăng ký lắng nghe phản hồi từ server
        socket?.once('location_updated', (data) {
          final responseData = data is String ? jsonDecode(data) : data;
          debugPrint(
              'Debug socket: Vị trí đã được cập nhật: ${responseData['status']}');
          // Có thể thêm xử lý khi nhận được phản hồi thành công
        });
      } else {
        debugPrint(
            'Debug socket: Không thể gửi vị trí - socket: ${socket?.connected}, online: $_isOnline');
      }
    } catch (e) {
      debugPrint('Debug socket: Lỗi lấy vị trí: $e');
    }
  }

  void _handleNewOrder(dynamic data) {
    debugPrint('Debug socket: Xử lý đơn hàng mới');
    final orderData = data is String ? jsonDecode(data) : data;
    _currentOrder = Map<String, dynamic>.from(orderData);
    _orderStatus = OrderStatus.newOrder;
    debugPrint(
        'Debug socket: Thông tin đơn hàng mới: ${jsonEncode(_currentOrder)}');

    // Thông báo cho UI
    debugPrint('Debug socket: Gọi callback cập nhật trạng thái đơn hàng');
    onOrderStatusChanged?.call(_orderStatus);
    onNewOrder?.call(_currentOrder!);
    onPlayNotification?.call();

    // Bắt đầu nhấp nháy (thông qua callback)
    debugPrint('Debug socket: Bắt đầu hiệu ứng nhấp nháy');
    _startBlinking();

    // Rung điện thoại
    debugPrint('Debug socket: Kích hoạt rung');
    Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
  }

  void _handleOrderCanceled(dynamic data) {
    debugPrint('Debug socket: Xử lý đơn hàng bị hủy');
    if (_orderStatus == OrderStatus.inProgress) {
      final orderData = data is String ? jsonDecode(data) : data;
      _currentOrder = Map<String, dynamic>.from(orderData);
      _orderStatus = OrderStatus.canceled;
      debugPrint(
          'Debug socket: Thông tin đơn hàng bị hủy: ${jsonEncode(_currentOrder)}');

      // Thông báo cho UI
      debugPrint('Debug socket: Gọi callback cho đơn hàng bị hủy');
      onOrderStatusChanged?.call(_orderStatus);
      onOrderCanceled?.call(_currentOrder!);
      onPlayNotification?.call();

      // Rung điện thoại
      debugPrint('Debug socket: Kích hoạt rung cho đơn hủy');
      Vibration.vibrate(pattern: [300, 300, 300, 300]);
    } else {
      debugPrint(
          'Debug socket: Bỏ qua sự kiện hủy đơn vì trạng thái hiện tại không phải đang tiến hành: $_orderStatus');
    }
  }

  void _handleOrderStatusUpdate(dynamic data) {
    debugPrint('Debug socket: Xử lý cập nhật trạng thái đơn hàng');
    final orderData = data is String ? jsonDecode(data) : data;
    _currentOrder = Map<String, dynamic>.from(orderData);
    debugPrint(
        'Debug socket: Thông tin đơn hàng cập nhật: ${jsonEncode(_currentOrder)}');

    // Thông báo cho UI
    debugPrint('Debug socket: Gọi callback cập nhật trạng thái đơn hàng');
    onOrderStatusUpdated?.call(_currentOrder!);
  }

  // Xử lý nhấp nháy thông qua callback
  void _startBlinking() {
    debugPrint('Debug socket: Bắt đầu timer hiệu ứng nhấp nháy');
    bool isBlinking = false;
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      isBlinking = !isBlinking;
      onBlinkingChanged?.call(isBlinking);

      // Dừng nhấp nháy khi đơn hàng không còn ở trạng thái mới
      if (_orderStatus != OrderStatus.newOrder) {
        debugPrint(
            'Debug socket: Dừng hiệu ứng nhấp nháy vì trạng thái đơn hàng đã thay đổi');
        timer.cancel();
        onBlinkingChanged?.call(false);
      }
    });
  }

  void acceptOrder() {
    debugPrint('Debug socket: Chấp nhận đơn hàng');
    if (_currentOrder != null && socket?.connected == true) {
      debugPrint(
          'Debug socket: Gửi yêu cầu chấp nhận đơn hàng ID: ${_currentOrder!['id']}');
      socket?.emit('accept_order', {'order_id': _currentOrder!['id']});
      _orderStatus = OrderStatus.inProgress;
      onOrderStatusChanged?.call(_orderStatus);
    } else {
      debugPrint(
          'Debug socket: Không thể chấp nhận đơn - đơn hàng hiện tại: ${_currentOrder != null}, socket kết nối: ${socket?.connected}');
    }
  }

  void rejectOrder() {
    debugPrint('Debug socket: Từ chối đơn hàng');
    if (_currentOrder != null && socket?.connected == true) {
      debugPrint(
          'Debug socket: Gửi yêu cầu từ chối đơn hàng ID: ${_currentOrder!['id']}');
      socket?.emit('reject_order', {'order_id': _currentOrder!['id']});
      _orderStatus = OrderStatus.waiting;
      _currentOrder = null;
      onOrderStatusChanged?.call(_orderStatus);
    } else {
      debugPrint(
          'Debug socket: Không thể từ chối đơn - đơn hàng hiện tại: ${_currentOrder != null}, socket kết nối: ${socket?.connected}');
    }
  }

  void updateOrderStatus(String status) {
    debugPrint('Debug socket: Cập nhật trạng thái đơn hàng: $status');
    if (_currentOrder != null && socket?.connected == true) {
      debugPrint(
          'Debug socket: Gửi yêu cầu cập nhật trạng thái đơn hàng ID: ${_currentOrder!['id']} -> $status');
      socket?.emit('update_order_status', {
        'order_id': _currentOrder!['id'],
        'status': status,
      });
    } else {
      debugPrint(
          'Debug socket: Không thể cập nhật trạng thái - đơn hàng hiện tại: ${_currentOrder != null}, socket kết nối: ${socket?.connected}');
    }
  }

  void completeOrder() {
    debugPrint('Debug socket: Hoàn thành đơn hàng');
    if (_currentOrder != null && socket?.connected == true) {
      debugPrint(
          'Debug socket: Gửi yêu cầu hoàn thành đơn hàng ID: ${_currentOrder!['id']}');
      socket?.emit('complete_order', {'order_id': _currentOrder!['id']});
      _orderStatus = OrderStatus.completed;
      onOrderStatusChanged?.call(_orderStatus);
    } else {
      debugPrint(
          'Debug socket: Không thể hoàn thành đơn - đơn hàng hiện tại: ${_currentOrder != null}, socket kết nối: ${socket?.connected}');
    }
  }

  void closeOrderComplete() {
    debugPrint('Debug socket: Đóng đơn hàng đã hoàn thành');
    _orderStatus = OrderStatus.waiting;
    _currentOrder = null;
    onOrderStatusChanged?.call(_orderStatus);
  }

  void closeOrderCanceled() {
    debugPrint('Debug socket: Đóng đơn hàng đã hủy');
    _orderStatus = OrderStatus.waiting;
    _currentOrder = null;
    onOrderStatusChanged?.call(_orderStatus);
  }

  void dispose() {
    debugPrint('Debug socket: Hủy SocketController');
    socket?.disconnect();
    socket?.dispose();
    _locationTimer?.cancel();
    socketConnected.dispose();
  }
}
