import 'dart:async';
import 'dart:convert';

import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:network_resources/enums.dart';
import 'package:network_resources/order/models/models.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vibration/vibration.dart';

import '../../../constants/app_constants.dart';
import '../models/socket_response.dart';

SocketController get socketController => findInstance<SocketController>();

class SocketController {
  IO.Socket? socket;
  Timer? _locationTimer;
  bool _isOnline = false;
  OrderModel? currentOrder;

  int? responseTimeout;
  DateTime? timestampOrderReceived;

  final ValueNotifier<AppOrderProcessStatus> orderStatus =
      ValueNotifier<AppOrderProcessStatus>(AppOrderProcessStatus.pending);
  final ValueNotifier<bool> socketConnected = ValueNotifier<bool>(false);
  final ValueNotifier<LatLng?> currentLocation = ValueNotifier<LatLng?>(null);

  // Callback cho việc cập nhật UI
  Function(OrderModel)? onNewOrder;
  Function(OrderModel)? onOrderCanceled;
  Function(OrderModel)? onOrderStatusUpdated;
  Function(bool)? onBlinkingChanged;
  Function()? onPlayNotification;

  bool get isOnline => _isOnline;

  init() {
    _initializeSocket();
    if (AppPrefs.instance.autoActiveOnlineStatus) {
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
        socket?.emit("joinRoom", "driver_${AppPrefs.instance.user?.id}");
      });

      socket?.onDisconnect((_) {
        debugPrint('Debug socket: Đã ngắt kết nối');
        socketConnected.value = false;
      });

      socket?.on('driver_new_order_request', (data) {
        debugPrint('Debug socket: Nhận đơn hàng mới');
        _handleNewOrder(data);
      });

      socket?.on('order_cancelled', (data) {
        debugPrint('Debug socket: Đơn hàng bị hủy');
        //TODO: Xử lý đơn hàng bị hủy
        // _handleOrderCanceled(data);
      }); 

      // Thêm xử lý event nhận phản hồi xác thực thành công
      socket?.on('authentication_success', (data) {
        debugPrint('Debug socket: Xác thực thành công');
        final socketResponse = _parseSocketResponse(data);

        if (socketResponse.isSuccess) {
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
          'driver_update_status', {'status': isOnline ? 'online' : 'offline'});
    } else {
      debugPrint(
          'Debug socket: Không thể gửi trạng thái vì socket chưa kết nối');
    }
  }

  void _startLocationUpdates() {
    debugPrint('Debug socket: Bắt đầu cập nhật vị trí');
    _locationTimer?.cancel();
    _locationTimer =
        Timer.periodic(const Duration(seconds: kDebugMode ? 60 : 30), (_) {
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
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 15),
        ),
      );
      currentLocation.value = LatLng(position.latitude, position.longitude);

      //TODO: remove later
      currentLocation.value = LatLng(47.495987, 19.0653861);

      debugPrint(
          'Debug socket: Đã lấy vị trí: ${position.latitude}, ${position.longitude}');

      if (socket?.connected == true && _isOnline) {
        debugPrint('Debug socket: Gửi vị trí lên server');
        socket?.emit('driver_update_location', {
          'latitude': position.latitude,
          'longitude': position.longitude,
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
    final socketResponse = _parseSocketResponse(data);

    if (socketResponse.isSuccess && socketResponse.data != null) {
      // Chuyển đổi dữ liệu thành đối tượng Order
      // {
      //   order: order.getOrderData(),
      //   responseTimeout: 30, // Thời gian chờ phản hồi (giây)
      //   timestamp: new Date().toISOString()
      // }
      final driverNewOrder = DriverNewOrderModel.fromJson(socketResponse.data);
      currentOrder = driverNewOrder.order;
      responseTimeout = driverNewOrder.responseTimeout;
      timestampOrderReceived = DateTime.parse(driverNewOrder.timestamp!);
      orderStatus.value = AppOrderProcessStatus.findDriver;
      debugPrint(
          'Debug socket: Thông tin đơn hàng mới: ${jsonEncode(currentOrder)}');

      // Thông báo cho UI
      debugPrint('Debug socket: Gọi callback cập nhật trạng thái đơn hàng');
      onNewOrder?.call(currentOrder!);
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

  // void _handleOrderCanceled(dynamic data) {
  //   debugPrint('Debug socket: Xử lý đơn hàng bị hủy');
  //   if (_orderStatus == AppOrderProcessStatus.inProgress ||
  //       _orderStatus == AppOrderProcessStatus.accepted ||
  //       _orderStatus == AppOrderProcessStatus.picked) {
  //     final socketResponse = _parseSocketResponse(data);

  //     if (socketResponse.isSuccess && socketResponse.data != null) {
  //       // Chuẩn hóa dữ liệu đơn hàng
  //       final orderData = socketResponse.data is Map ? socketResponse.data : {};

  //       // Đảm bảo trường orderId tồn tại
  //       if (orderData['id'] != null && orderData['orderId'] == null) {
  //         orderData['orderId'] = orderData['id'];
  //       }

  //       currentOrder = Map<String, dynamic>.from(orderData);
  //       _orderStatus = AppOrderProcessStatus.canceled;
  //       debugPrint(
  //           'Debug socket: Thông tin đơn hàng bị hủy: ${jsonEncode(currentOrder)}');

  //       // Thông báo cho UI
  //       debugPrint('Debug socket: Gọi callback cho đơn hàng bị hủy');
  //       onOrderStatusChanged?.call(_orderStatus);
  //       onOrderCanceled?.call(currentOrder!);
  //       onPlayNotification?.call();

  //       // Rung điện thoại
  //       debugPrint('Debug socket: Kích hoạt rung cho đơn hủy');
  //       Vibration.vibrate(pattern: [300, 300, 300, 300]);
  //     } else {
  //       debugPrint(
  //           'Debug socket: Lỗi khi xử lý đơn hàng bị hủy: ${socketResponse.messageCode}');
  //     }
  //   } else {
  //     debugPrint(
  //         'Debug socket: Bỏ qua sự kiện hủy đơn vì trạng thái hiện tại không phải đang tiến hành: $_orderStatus');
  //   }
  // }

  // void _handleOrderStatusUpdate(dynamic data) {
  //   debugPrint('Debug socket: Xử lý cập nhật trạng thái đơn hàng');
  //   final socketResponse = _parseSocketResponse(data);

  //   if (socketResponse.isSuccess && socketResponse.data != null) {
  //     // Chuẩn hóa dữ liệu đơn hàng
  //     final orderData = socketResponse.data is Map ? socketResponse.data : {};

  //     // Đảm bảo trường orderId tồn tại
  //     if (orderData['id'] != null && orderData['orderId'] == null) {
  //       orderData['orderId'] = orderData['id'];
  //     }

  //     currentOrder = Map<String, dynamic>.from(orderData);

  //     // Cập nhật trạng thái UI dựa trên trạng thái đơn hàng từ server
  //     if (currentOrder!.containsKey('status')) {
  //       final orderStatus = currentOrder!['status'];
  //       switch (orderStatus) {
  //         case OrderStatus.accepted:
  //           _orderStatus = AppOrderProcessStatus.accepted;
  //           break;
  //         case OrderStatus.picked:
  //           _orderStatus = AppOrderProcessStatus.picked;
  //           break;
  //         case OrderStatus.inProgress:
  //           _orderStatus = AppOrderProcessStatus.inProgress;
  //           break;
  //         case OrderStatus.completed:
  //           _orderStatus = AppOrderProcessStatus.completed;
  //           break;
  //         case OrderStatus.cancelled:
  //           _orderStatus = AppOrderProcessStatus.canceled;
  //           break;
  //       }
  //       onOrderStatusChanged?.call(_orderStatus);
  //     }

  //     debugPrint(
  //         'Debug socket: Thông tin đơn hàng cập nhật: ${jsonEncode(currentOrder)}');

  //     // Thông báo cho UI
  //     debugPrint('Debug socket: Gọi callback cập nhật trạng thái đơn hàng');
  //     onOrderStatusUpdated?.call(currentOrder!);
  //   } else {
  //     debugPrint(
  //         'Debug socket: Lỗi khi cập nhật trạng thái đơn hàng: ${socketResponse.messageCode}');
  //   }
  // }

  // Xử lý nhấp nháy thông qua callback
  void _startBlinking() {
    debugPrint('Debug socket: Bắt đầu timer hiệu ứng nhấp nháy');
    bool isBlinking = false;
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      isBlinking = !isBlinking;
      onBlinkingChanged?.call(isBlinking);

      // Dừng nhấp nháy khi đơn hàng không còn ở trạng thái mới
      if (orderStatus != AppOrderProcessStatus.findDriver) {
        debugPrint(
            'Debug socket: Dừng hiệu ứng nhấp nháy vì trạng thái đơn hàng đã thay đổi');
        timer.cancel();
        onBlinkingChanged?.call(false);
      }
    });
  }

  void acceptOrder() {
    debugPrint('Debug socket: Chấp nhận đơn hàng');
    if (currentOrder != null && socket?.connected == true) {
      debugPrint(
          'Debug socket: Gửi yêu cầu chấp nhận đơn hàng ID: ${currentOrder!.id}');
      socket?.emit('driver_new_order_response', {
        'orderId': currentOrder!.id,
        'status': 'accepted',
      });

      // Lắng nghe phản hồi
      socket?.once('driver_new_order_response_confirmed', (data) {
        final socketResponse = _parseSocketResponse(data);
        if (socketResponse.isSuccess) {
          orderStatus.value = AppOrderProcessStatus.driverAccepted;
          // onOrderStatusChanged?.call(orderStatus);
          debugPrint('Debug socket: Đơn hàng đã được chấp nhận thành công');
        } else {
          debugPrint(
              'Debug socket: Lỗi khi chấp nhận đơn hàng: ${socketResponse.messageCode}');
        }
      });
    } else {
      debugPrint(
          'Debug socket: Không thể chấp nhận đơn - đơn hàng hiện tại: ${currentOrder != null}, socket kết nối: ${socket?.connected}');
    }
  }

  void rejectOrder() {
    debugPrint('Debug socket: Từ chối đơn hàng');
    if (currentOrder != null && socket?.connected == true) {
      debugPrint(
          'Debug socket: Gửi yêu cầu từ chối đơn hàng ID: ${currentOrder!.id}');
      socket?.emit('driver_new_order_response', {
        'orderId': currentOrder!.id,
        'status': 'rejected',
      });

      // Lắng nghe phản hồi
      socket?.once('order_response_confirmed', (data) {
        final socketResponse = _parseSocketResponse(data);
        if (socketResponse.isSuccess) {
          orderStatus.value = AppOrderProcessStatus.pending;
          currentOrder = null;
          // onOrderStatusChanged?.call(orderStatus);
          debugPrint('Debug socket: Đơn hàng đã được từ chối thành công');
        } else {
          debugPrint(
              'Debug socket: Lỗi khi từ chối đơn hàng: ${socketResponse.messageCode}');
        }
      });
    } else {
      debugPrint(
          'Debug socket: Không thể từ chối đơn - đơn hàng hiện tại: ${currentOrder != null}, socket kết nối: ${socket?.connected}');
    }
  }

  void updateOrderStatus(AppOrderProcessStatus status) {
    AppOrderProcessStatus currentStatus = orderStatus.value;
    if (currentOrder != null && socket?.connected == true) {
      debugPrint(
          'Debug socket: Gửi yêu cầu cập nhật trạng thái đơn hàng ID: ${currentOrder!.id} -> $status');
      orderStatus.value = status;

      if (status == AppOrderProcessStatus.completed) {
        // Gửi cập nhật lên server
        socket?.emit('complete_order', {
          'orderId': currentOrder!.id,
        });

        // Lắng nghe phản hồi
        socket?.once('order_completed_confirmation', (data) {
          final socketResponse = _parseSocketResponse(data);
          if (socketResponse.isSuccess) {
            debugPrint(
                'Debug socket: Trạng thái đơn hàng đã được hoàn thành thành công');

            currentOrder = null;

            Timer(const Duration(seconds: 5), () {
              orderStatus.value = AppOrderProcessStatus.pending;
            });
          } else {
            orderStatus.value = currentStatus;
            debugPrint(
                'Debug socket: Lỗi khi hoàn thành đơn hàng: ${socketResponse.messageCode}');
            appShowSnackBar(msg: 'Error when complete order'.tr());
          }
        });
      } else {
        // Gửi cập nhật lên server
        socket?.emit('update_order_status', {
          'orderId': currentOrder!.id,
          'processStatus': status.name,
        });

        // Lắng nghe phản hồi
        socket?.once('order_status_updated_confirmation', (data) {
          final socketResponse = _parseSocketResponse(data);
          if (socketResponse.isSuccess) {
            debugPrint(
                'Debug socket: Trạng thái đơn hàng đã được cập nhật thành công');
          } else {
            orderStatus.value = currentStatus;
            debugPrint(
                'Debug socket: Lỗi khi cập nhật trạng thái đơn hàng: ${socketResponse.messageCode}');
            appShowSnackBar(msg: 'Error when update order status'.tr());
          }
        });
      }
    } else {
      debugPrint(
          'Debug socket: Không thể cập nhật trạng thái - đơn hàng hiện tại: ${currentOrder != null}, socket kết nối: ${socket?.connected}');
    }
  }

  // Cập nhật phương thức để hủy đơn hàng
  void cancelOrder(String reason) {
    debugPrint('Debug socket: Hủy đơn hàng với lý do: $reason');

    if (currentOrder != null && socket?.connected == true) {
      debugPrint(
          'Debug socket: Gửi yêu cầu hủy đơn hàng ID: ${currentOrder!.id}');

      socket?.emit(
          'cancel_order', {'orderId': currentOrder!.id, 'reason': reason});

      // Lắng nghe phản hồi
      socket?.once('order_cancelled_confirmation', (data) {
        final socketResponse = _parseSocketResponse(data);
        if (socketResponse.isSuccess) {
          orderStatus.value = AppOrderProcessStatus.cancelled;
          // onOrderStatusChanged?.call(orderStatus);
          debugPrint('Debug socket: Đơn hàng đã được hủy thành công');
        } else {
          debugPrint(
              'Debug socket: Lỗi khi hủy đơn hàng: ${socketResponse.messageCode}');
        }
      });
    } else {
      debugPrint(
          'Debug socket: Không thể hủy đơn hàng - đơn hàng hiện tại: ${currentOrder != null}, socket kết nối: ${socket?.connected}');
    }
  }

  void dispose() {
    debugPrint('Debug socket: Hủy SocketController');
    socket?.disconnect();
    socket?.dispose();
    _locationTimer?.cancel();
    orderStatus.dispose();
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
