import 'dart:async';
import 'dart:convert';

import 'package:app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vibration/vibration.dart';

import '../../../constants/app_constants.dart';
import '../../../utils/app_prefs.dart';
import '../models/socket_response.dart';
import '../models/order_model.dart';

enum DriverOrderStatus {
  waiting, // Tài xế đang đợi đơn mới
  newOrder, // Có đơn mới gửi đến
  accepted, // Tài xế đã xác nhận nhận đơn
  picked, // Tài xế đã lấy đơn
  inProgress, // Tài xế đang di chuyển đến điểm giao
  completed, // Đơn hoàn thành
  canceled, // Đơn bị hủy
}

SocketController get socketController => findInstance<SocketController>();

class SocketController {
  IO.Socket? socket;
  Timer? _locationTimer;
  bool _isOnline = false;
  Map<String, dynamic>? _currentOrder;
  DriverOrderStatus _orderStatus = DriverOrderStatus.waiting;
  final ValueNotifier<bool> socketConnected = ValueNotifier<bool>(false);

  // Callback cho việc cập nhật UI
  Function(Map<String, dynamic>)? onNewOrder;
  Function(Map<String, dynamic>)? onOrderCanceled;
  Function(Map<String, dynamic>)? onOrderStatusUpdated;
  Function(bool)? onBlinkingChanged;
  Function(DriverOrderStatus)? onOrderStatusChanged;
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
  DriverOrderStatus get orderStatus => _orderStatus;
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
        final socketResponse = _parseSocketResponse(data);

        if (socketResponse.isSuccess) {
          // Lưu thông tin profile và wallet
          if (socketResponse.data != null &&
              socketResponse.data['profile'] != null) {
            _profile =
                Map<String, dynamic>.from(socketResponse.data['profile']);
            onProfileUpdated?.call(_profile!);
            debugPrint('Debug socket: Đã nhận thông tin profile');
          }

          if (socketResponse.data != null &&
              socketResponse.data['wallet'] != null) {
            _wallet = Map<String, dynamic>.from(socketResponse.data['wallet']);
            onWalletUpdated?.call(_wallet!);
            debugPrint('Debug socket: Đã nhận thông tin wallet');
          }

          // Khôi phục trạng thái online/offline
          if (_isOnline) {
            debugPrint('Debug socket: Khôi phục trạng thái online');
            _emitDriverStatus(true);
          }
        } else {
          debugPrint(
              'Debug socket: Xác thực không thành công: ${socketResponse.messageCode}');
        }
      });

      // Thêm xử lý event lỗi xác thực
      socket?.on('authentication_error', (data) {
        final socketResponse = _parseSocketResponse(data);
        debugPrint(
            'Debug socket: Lỗi xác thực: ${socketResponse.messageCode} - ${socketResponse.data != null ? socketResponse.data['message'] : ''}');
        // Có thể thêm xử lý khi xác thực thất bại
      });

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
        final socketResponse = _parseSocketResponse(data);
        if (socketResponse.isSuccess) {
          debugPrint(
              'Debug socket: Trạng thái đã được cập nhật: ${socketResponse.data?['status']}');
        } else {
          debugPrint(
              'Debug socket: Lỗi cập nhật trạng thái: ${socketResponse.messageCode}');
        }
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
          final socketResponse = _parseSocketResponse(data);
          if (socketResponse.isSuccess) {
            debugPrint('Debug socket: Vị trí đã được cập nhật thành công');
          } else {
            debugPrint(
                'Debug socket: Lỗi cập nhật vị trí: ${socketResponse.messageCode}');
          }
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
    final socketResponse = _parseSocketResponse(data);

    if (socketResponse.isSuccess && socketResponse.data != null) {
      // Chuyển đổi dữ liệu thành đối tượng Order
      final orderData = socketResponse.data is Map ? socketResponse.data : {};

      // Đảm bảo trường orderId tồn tại
      if (orderData['id'] != null && orderData['orderId'] == null) {
        orderData['orderId'] = orderData['id'];
      }

      _currentOrder = Map<String, dynamic>.from(orderData);
      _orderStatus = DriverOrderStatus.newOrder;
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
    } else {
      debugPrint(
          'Debug socket: Lỗi khi nhận đơn hàng mới: ${socketResponse.messageCode}');
    }
  }

  void _handleOrderCanceled(dynamic data) {
    debugPrint('Debug socket: Xử lý đơn hàng bị hủy');
    if (_orderStatus == DriverOrderStatus.inProgress ||
        _orderStatus == DriverOrderStatus.accepted ||
        _orderStatus == DriverOrderStatus.picked) {
      final socketResponse = _parseSocketResponse(data);

      if (socketResponse.isSuccess && socketResponse.data != null) {
        // Chuẩn hóa dữ liệu đơn hàng
        final orderData = socketResponse.data is Map ? socketResponse.data : {};

        // Đảm bảo trường orderId tồn tại
        if (orderData['id'] != null && orderData['orderId'] == null) {
          orderData['orderId'] = orderData['id'];
        }

        _currentOrder = Map<String, dynamic>.from(orderData);
        _orderStatus = DriverOrderStatus.canceled;
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
            'Debug socket: Lỗi khi xử lý đơn hàng bị hủy: ${socketResponse.messageCode}');
      }
    } else {
      debugPrint(
          'Debug socket: Bỏ qua sự kiện hủy đơn vì trạng thái hiện tại không phải đang tiến hành: $_orderStatus');
    }
  }

  void _handleOrderStatusUpdate(dynamic data) {
    debugPrint('Debug socket: Xử lý cập nhật trạng thái đơn hàng');
    final socketResponse = _parseSocketResponse(data);

    if (socketResponse.isSuccess && socketResponse.data != null) {
      // Chuẩn hóa dữ liệu đơn hàng
      final orderData = socketResponse.data is Map ? socketResponse.data : {};

      // Đảm bảo trường orderId tồn tại
      if (orderData['id'] != null && orderData['orderId'] == null) {
        orderData['orderId'] = orderData['id'];
      }

      _currentOrder = Map<String, dynamic>.from(orderData);

      // Cập nhật trạng thái UI dựa trên trạng thái đơn hàng từ server
      if (_currentOrder!.containsKey('status')) {
        final orderStatus = _currentOrder!['status'];
        switch (orderStatus) {
          case OrderStatus.accepted:
            _orderStatus = DriverOrderStatus.accepted;
            break;
          case OrderStatus.picked:
            _orderStatus = DriverOrderStatus.picked;
            break;
          case OrderStatus.inProgress:
            _orderStatus = DriverOrderStatus.inProgress;
            break;
          case OrderStatus.completed:
            _orderStatus = DriverOrderStatus.completed;
            break;
          case OrderStatus.cancelled:
            _orderStatus = DriverOrderStatus.canceled;
            break;
        }
        onOrderStatusChanged?.call(_orderStatus);
      }

      debugPrint(
          'Debug socket: Thông tin đơn hàng cập nhật: ${jsonEncode(_currentOrder)}');

      // Thông báo cho UI
      debugPrint('Debug socket: Gọi callback cập nhật trạng thái đơn hàng');
      onOrderStatusUpdated?.call(_currentOrder!);
    } else {
      debugPrint(
          'Debug socket: Lỗi khi cập nhật trạng thái đơn hàng: ${socketResponse.messageCode}');
    }
  }

  // Xử lý nhấp nháy thông qua callback
  void _startBlinking() {
    debugPrint('Debug socket: Bắt đầu timer hiệu ứng nhấp nháy');
    bool isBlinking = false;
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      isBlinking = !isBlinking;
      onBlinkingChanged?.call(isBlinking);

      // Dừng nhấp nháy khi đơn hàng không còn ở trạng thái mới
      if (_orderStatus != DriverOrderStatus.newOrder) {
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
          'Debug socket: Gửi yêu cầu chấp nhận đơn hàng ID: ${_currentOrder!['orderId']}');
      socket?.emit('accept_order', {'order_id': _currentOrder!['orderId']});

      // Lắng nghe phản hồi
      socket?.once('order_response_confirmed', (data) {
        final socketResponse = _parseSocketResponse(data);
        if (socketResponse.isSuccess) {
          _orderStatus = DriverOrderStatus.accepted;
          onOrderStatusChanged?.call(_orderStatus);
          debugPrint('Debug socket: Đơn hàng đã được chấp nhận thành công');
        } else {
          debugPrint(
              'Debug socket: Lỗi khi chấp nhận đơn hàng: ${socketResponse.messageCode}');
        }
      });
    } else {
      debugPrint(
          'Debug socket: Không thể chấp nhận đơn - đơn hàng hiện tại: ${_currentOrder != null}, socket kết nối: ${socket?.connected}');
    }
  }

  void rejectOrder() {
    debugPrint('Debug socket: Từ chối đơn hàng');
    if (_currentOrder != null && socket?.connected == true) {
      debugPrint(
          'Debug socket: Gửi yêu cầu từ chối đơn hàng ID: ${_currentOrder!['orderId']}');
      socket?.emit('reject_order', {'order_id': _currentOrder!['orderId']});

      // Lắng nghe phản hồi
      socket?.once('order_response_confirmed', (data) {
        final socketResponse = _parseSocketResponse(data);
        if (socketResponse.isSuccess) {
          _orderStatus = DriverOrderStatus.waiting;
          _currentOrder = null;
          onOrderStatusChanged?.call(_orderStatus);
          debugPrint('Debug socket: Đơn hàng đã được từ chối thành công');
        } else {
          debugPrint(
              'Debug socket: Lỗi khi từ chối đơn hàng: ${socketResponse.messageCode}');
        }
      });
    } else {
      debugPrint(
          'Debug socket: Không thể từ chối đơn - đơn hàng hiện tại: ${_currentOrder != null}, socket kết nối: ${socket?.connected}');
    }
  }

  void updateOrderStatus(String status) {
    debugPrint('Debug socket: Cập nhật trạng thái đơn hàng: $status');
    if (_currentOrder != null && socket?.connected == true) {
      debugPrint(
          'Debug socket: Gửi yêu cầu cập nhật trạng thái đơn hàng ID: ${_currentOrder!['orderId']} -> $status');

      // Cập nhật trạng thái UI trước khi gửi lên server
      switch (status) {
        case OrderStatus.picked:
          _orderStatus = DriverOrderStatus.picked;
          break;
        case OrderStatus.inProgress:
          _orderStatus = DriverOrderStatus.inProgress;
          break;
        case OrderStatus.completed:
          _orderStatus = DriverOrderStatus.completed;
          break;
        case OrderStatus.cancelled:
          _orderStatus = DriverOrderStatus.canceled;
          break;
      }

      // Thông báo cho UI
      onOrderStatusChanged?.call(_orderStatus);

      // Gửi cập nhật lên server
      socket?.emit('update_order_status', {
        'order_id': _currentOrder!['orderId'],
        'status': status,
      });

      // Lắng nghe phản hồi
      socket?.once('order_status_updated_confirmation', (data) {
        final socketResponse = _parseSocketResponse(data);
        if (socketResponse.isSuccess) {
          debugPrint(
              'Debug socket: Trạng thái đơn hàng đã được cập nhật thành công');
        } else {
          debugPrint(
              'Debug socket: Lỗi khi cập nhật trạng thái đơn hàng: ${socketResponse.messageCode}');
        }
      });
    } else {
      debugPrint(
          'Debug socket: Không thể cập nhật trạng thái - đơn hàng hiện tại: ${_currentOrder != null}, socket kết nối: ${socket?.connected}');
    }
  }

  // Phương thức mới cho trạng thái pickOrder
  void pickOrder() {
    debugPrint('Debug socket: Tài xế lấy đơn hàng');
    updateOrderStatus(OrderStatus.picked);
  }

  // Phương thức mới cho trạng thái startDelivery
  void startDelivery() {
    debugPrint('Debug socket: Tài xế bắt đầu giao hàng');
    updateOrderStatus(OrderStatus.inProgress);
  }

  // Phương thức cập nhật để hoàn thành đơn hàng
  void completeOrder() {
    debugPrint('Debug socket: Hoàn thành đơn hàng');
    if (_currentOrder != null && socket?.connected == true) {
      debugPrint(
          'Debug socket: Gửi yêu cầu hoàn thành đơn hàng ID: ${_currentOrder!['orderId']}');

      socket?.emit('complete_order', {'order_id': _currentOrder!['orderId']});

      // Lắng nghe phản hồi
      socket?.once('order_status_updated_confirmation', (data) {
        final socketResponse = _parseSocketResponse(data);
        if (socketResponse.isSuccess) {
          _orderStatus = DriverOrderStatus.completed;
          onOrderStatusChanged?.call(_orderStatus);
          debugPrint('Debug socket: Đơn hàng đã được hoàn thành thành công');
        } else {
          debugPrint(
              'Debug socket: Lỗi khi hoàn thành đơn hàng: ${socketResponse.messageCode}');
        }
      });
    } else {
      debugPrint(
          'Debug socket: Không thể hoàn thành đơn - đơn hàng hiện tại: ${_currentOrder != null}, socket kết nối: ${socket?.connected}');
    }
  }

  // Cập nhật phương thức để hủy đơn hàng
  void cancelOrder(String reason) {
    debugPrint('Debug socket: Hủy đơn hàng với lý do: $reason');
    if (_currentOrder != null && socket?.connected == true) {
      debugPrint(
          'Debug socket: Gửi yêu cầu hủy đơn hàng ID: ${_currentOrder!['orderId']}');

      socket?.emit('cancel_order',
          {'order_id': _currentOrder!['orderId'], 'reason': reason});

      // Lắng nghe phản hồi
      socket?.once('order_cancelled_confirmation', (data) {
        final socketResponse = _parseSocketResponse(data);
        if (socketResponse.isSuccess) {
          _orderStatus = DriverOrderStatus.canceled;
          onOrderStatusChanged?.call(_orderStatus);
          debugPrint('Debug socket: Đơn hàng đã được hủy thành công');
        } else {
          debugPrint(
              'Debug socket: Lỗi khi hủy đơn hàng: ${socketResponse.messageCode}');
        }
      });
    } else {
      debugPrint(
          'Debug socket: Không thể hủy đơn hàng - đơn hàng hiện tại: ${_currentOrder != null}, socket kết nối: ${socket?.connected}');
    }
  }

  void closeOrderComplete() {
    debugPrint('Debug socket: Đóng đơn hàng đã hoàn thành');
    _orderStatus = DriverOrderStatus.waiting;
    _currentOrder = null;
    onOrderStatusChanged?.call(_orderStatus);
  }

  void closeOrderCanceled() {
    debugPrint('Debug socket: Đóng đơn hàng đã hủy');
    _orderStatus = DriverOrderStatus.waiting;
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

  // Phương thức trợ giúp phân tích phản hồi từ socket
  SocketResponse _parseSocketResponse(dynamic data) {
    try {
      final Map<String, dynamic> jsonData =
          data is String ? jsonDecode(data) : Map<String, dynamic>.from(data);
      return SocketResponse.fromJson(jsonData);
    } catch (e) {
      debugPrint('Debug socket: Lỗi phân tích dữ liệu socket: $e');
      // Trả về phản hồi mặc định trong trường hợp có lỗi
      return SocketResponse(
        isSuccess: false,
        timestamp: DateTime.now().toIso8601String(),
        messageCode: 'PARSE_ERROR',
        data: {'message': 'Lỗi phân tích dữ liệu', 'original': data},
      );
    }
  }
}
