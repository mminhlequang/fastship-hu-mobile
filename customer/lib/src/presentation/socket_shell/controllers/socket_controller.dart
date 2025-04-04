import 'dart:async';
import 'dart:convert';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:internal_network/network_resources/model/model.dart';
import 'package:latlong2/latlong.dart';
import 'package:network_resources/enums.dart';
import 'package:network_resources/order/models/models.dart';
import 'package:network_resources/order/repo.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/socket_response.dart';

CustomerSocketController get socketController =>
    findInstance<CustomerSocketController>();

class CustomerSocketController {
  IO.Socket? socket;

  OrderModel? order;

  // ValueNotifier để theo dõi trạng thái kết nối socket
  final ValueNotifier<bool> socketConnected = ValueNotifier<bool>(false);
  final ValueNotifier<LatLng?> driverLocation = ValueNotifier<LatLng?>(null);

  // Các callback để cập nhật UI
  Function(AppOrderProcessStatus)? onOrderStatusChanged;

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

        socket?.emit("joinRoom", "customer_${AppPrefs.instance.user?.id}");
      });

      socket?.onDisconnect((_) {
        debugPrint('Debug socket: Đã ngắt kết nối');
        socketConnected.value = false;
      });

      socket?.on('authentication_success', (data) {
        debugPrint('Debug socket: Đã xác thực');
        appShowSnackBar(
          context: appContext,
          msg: "Authentication success",
          type: AppSnackBarType.notitfication,
        );
      });

      // Xử lý khi đơn hàng được tạo
      socket?.on('create_order_result', (data) {
        _onCreateOrderResult(data);
        appShowSnackBar(
          context: appContext,
          msg: "create_order_result: $data",
          type: AppSnackBarType.notitfication,
        );
      });

      // Xử lý khi trạng thái đơn hàng thay đổi
      socket?.on('order_status_updated', (data) {
        debugPrint('Debug socket: Trạng thái đơn hàng đã cập nhật');
        appShowSnackBar(
          context: appContext,
          msg: "order_status_updated: $data",
          type: AppSnackBarType.notitfication,
        );
      });

      // Xử lý khi đơn hàng bị hủy
      socket?.on('order_cancelled', (data) {
        debugPrint('Debug socket: Đơn hàng đã bị hủy');
        appShowSnackBar(
          context: appContext,
          msg: "order_cancelled: $data",
          type: AppSnackBarType.notitfication,
        );
      });

      // Xử lý lỗi
      socket?.on('error', (data) {
        final socketResponse = _parseSocketResponse(data);
        debugPrint(
            'Debug socket: Lỗi: ${socketResponse.messageCode} - ${socketResponse.data != null ? socketResponse.data['message'] : ''}');
        appShowSnackBar(
          context: appContext,
          msg:
              "error: ${socketResponse.messageCode} - ${socketResponse.data != null ? socketResponse.data['message'] : ''}",
          type: AppSnackBarType.notitfication,
        );
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
    if (socket?.connected == true) {
      debugPrint('Debug socket: Gửi token xác thực');
      socket?.emit('authenticate_customer',
          {'token': await AppPrefs.instance.getNormalToken()});
    }
  }

  // Tạo đơn hàng mới
  late Completer<bool> _createOrderCompleter;
  Future<bool> createOrder(OrderModel order) async {
    _createOrderCompleter = Completer<bool>();

    if (socket?.connected == true) {
      socket?.emit('create_order', order.toJson());
      this.order = order;

      return await _createOrderCompleter.future;
    } else {
      //TODO: Handle no socket connection
      onNoSocketConnection();
    }
    return false;
  }

  void _onCreateOrderResult(dynamic data) async {
    final socketResponse = _parseSocketResponse(data);
    print('Debug socket: create_order_result: ${socketResponse.data}');
    if (socketResponse.isSuccess && socketResponse.data != null) {
      AppFindDriverStatus findDriverStatus = AppFindDriverStatus.values
          .byName(socketResponse.data!['find_driver_status']);
      switch (findDriverStatus) {
        case AppFindDriverStatus.finding:
          break;
        case AppFindDriverStatus.availableDrivers:
          break;
        case AppFindDriverStatus.found:
          await _refreshOrder();
          if (!_createOrderCompleter.isCompleted) {
            _createOrderCompleter.complete(true);
          }
          break;
        case AppFindDriverStatus.noDriver:
        case AppFindDriverStatus.error:
          if (!_createOrderCompleter.isCompleted) {
            _createOrderCompleter.complete(false);
          }
          break;
      }
    }
  }

  // Phương thức giải phóng tài nguyên
  void dispose() {
    debugPrint('Debug socket: Hủy CustomerSocketController');
    socket?.disconnect();
    socket?.dispose();
    socketConnected.dispose();
    driverLocation.dispose();
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

  _refreshOrder() async {
    NetworkResponse response =
        await OrderRepo().getOrderDetail({'id': order?.id});

    if (response.isSuccess && response.data != null) {
      order = response.data!;
    }
  }

  void onNoSocketConnection() {
    debugPrint("debug socket: No socket connection");
  }
}
