import 'dart:async';
import 'dart:convert';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/checkout/widgets/widget_rating_driver.dart';
import 'package:app/src/presentation/widgets/widget_dialog_notification.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
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

  OrderModel? currentOrder;

  final ValueNotifier<AppOrderProcessStatus?> orderStatus =
      ValueNotifier<AppOrderProcessStatus?>(null);
  final ValueNotifier<bool> socketConnected = ValueNotifier<bool>(false);
  final ValueNotifier<LatLng?> driverLocation = ValueNotifier<LatLng?>(null);

  // Các callback để cập nhật UI
  Function(AppOrderProcessStatus)? onOrderStatusChanged;

  void initializeSocket() {
    try {
      socket = IO.io(
        socketIOUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableForceNew()
            .build(),
      );

      socket?.onConnect((_) {
        debugPrint('Debug socket: connected');
        socketConnected.value = true;
        _authenticate();

        socket?.emit("joinRoom", "customer_${AppPrefs.instance.user?.id}");
      });

      socket?.onDisconnect((_) {
        debugPrint('Debug socket: Disconnected');
        socketConnected.value = false;
      });

      socket?.on('authentication_success', (data) {
        debugPrint('Debug socket: authentication_success: $data');
      });

      // Xử lý khi đơn hàng được tạo
      socket?.on('create_order_result', (data) {
        debugPrint('Debug socket: create_order_result: $data');
        _onCreateOrderResult(data);
      });

      // Xử lý khi trạng thái đơn hàng thay đổi
      socket?.on('order_status_updated', (data) async {
        debugPrint('[Debug socket] order_status_updated: $data');
        final socketResponse = _parseSocketResponse(data);
        if (socketResponse.isSuccess && socketResponse.data != null) {
          orderStatus.value = AppOrderProcessStatus.values
              .byName(socketResponse.data!['processStatus']);
          _refreshOrder();
        }
      });

      socket?.on('order_completed', (data) async {
        debugPrint('Debug socket: order_completed: $data');

        final socketResponse = _parseSocketResponse(data);
        if (socketResponse.isSuccess && socketResponse.data != null) {
          orderStatus.value = AppOrderProcessStatus.cancelled;

          appContext.pop();
          await appOpenDialog(WidgetDialogNotification(
              icon: 'icon58',
              title: "Driver Has Arrived!".tr(),
              message: "Enjoy your meal!\nSee you in the next order :)",
              buttonText: "Done".tr(),
              onPressed: () {
                appHaptic();
                appContext.pop();
              }));
          appOpenBottomSheet(WidgetRatingDriver());
        }
      });

      // Xử lý khi đơn hàng bị hủy
      socket?.on('order_cancelled', (data) async {
        debugPrint('Debug socket: order_cancelled: $data');

        final socketResponse = _parseSocketResponse(data);
        if (socketResponse.isSuccess && socketResponse.data != null) {
          orderStatus.value = AppOrderProcessStatus.values
              .byName(socketResponse.data!['processStatus']);

          appContext.pop();
          await appOpenDialog(WidgetDialogNotification(
              icon: 'icon60',
              title: "Order Cancelled!".tr(),
              message: "Your order has been cancelled.\nPlease try again.",
              buttonText: "Done".tr(),
              onPressed: () {
                appHaptic();
                appContext.pop();
              }));
        }
      });

      // Xử lý lỗi
      socket?.on('error', (data) {
        debugPrint('Debug socket: error: $data');
        final socketResponse = _parseSocketResponse(data);
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
      this.currentOrder = order;

      return await _createOrderCompleter.future;
    } else {
      //TODO: Handle no socket connection
      onNoSocketConnection();
    }
    return false;
  }

  void _onCreateOrderResult(dynamic data) async {
    final socketResponse = _parseSocketResponse(data);
    if (socketResponse.isSuccess && socketResponse.data != null) {
      AppFindDriverStatus findDriverStatus = AppFindDriverStatus.values
          .byName(socketResponse.data!['find_driver_status']);
      switch (findDriverStatus) {
        case AppFindDriverStatus.finding:
          break;
        case AppFindDriverStatus.availableDrivers:
          break;
        case AppFindDriverStatus.found:
          orderStatus.value = AppOrderProcessStatus.driverAccepted;
          socket?.on(
              'driver_${socketResponse.data!['driverInfo']?['profile']?['id']}',
              (data) {
            debugPrint(
                'Debug socket: driver_${socketResponse.data!['driverInfo']?['profile']?['id']}: $data');
          });
          await Future.delayed(Duration(seconds: 1));
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

  // Phương thức giải phóng tài nguyên
  void dispose() {
    debugPrint('Debug socket: Hủy CustomerSocketController');
    socket?.disconnect();
    socket?.dispose();
    socketConnected.dispose();
    driverLocation.dispose();
    orderStatus.dispose();
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
        await OrderRepo().getOrderDetail({'id': currentOrder?.id});

    if (response.isSuccess && response.data != null) {
      currentOrder = response.data!;
    }
  }

  void onNoSocketConnection() {
    debugPrint("debug socket: No socket connection");
  }
}

extension AppOrderProcessStatusExtension on AppOrderProcessStatus {
  String get textNotification {
    switch (this) {
      case AppOrderProcessStatus.pending:
        return "Pending";
      case AppOrderProcessStatus.findDriver:
        return "Finding driver";
      case AppOrderProcessStatus.driverAccepted:
        return "Driver accepted your order";
      case AppOrderProcessStatus.driverArrivedStore:
        return "Driver arrived at store";
      case AppOrderProcessStatus.driverPicked:
        return "Driver picked up";
      case AppOrderProcessStatus.driverArrivedDestination:
        return "Driver arrived at destination";
      case AppOrderProcessStatus.completed:
        return "Order completed";
      case AppOrderProcessStatus.cancelled:
        return "Order cancelled";
      default:
        return "Unknown";
    }
  }

  String get description {
    switch (this) {
      case AppOrderProcessStatus.driverAccepted:
        return "Driver accepted your order";
      case AppOrderProcessStatus.driverArrivedStore:
        return "Driver arrived at store, waiting to pick up";
      case AppOrderProcessStatus.driverPicked:
        return "Driver picked up your order";
      case AppOrderProcessStatus.driverArrivedDestination:
        return "Driver arrived at destination, waiting to deliver";
      case AppOrderProcessStatus.completed:
        return "Order completed";
      case AppOrderProcessStatus.cancelled:
        return "Order cancelled";
      default:
        return "Unknown";
    }
  }
}
