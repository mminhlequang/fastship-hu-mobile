import 'package:app/src/utils/utils.dart';
import 'package:network_resources/network_resources.dart';
import 'dart:convert';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/presentation/socket_shell/models/socket_response.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

CustomerSocketController get socketController =>
    findInstance<CustomerSocketController>();

class CustomerSocketController {
  IO.Socket? socket;

  final ValueNotifier<bool> socketConnected = ValueNotifier<bool>(false);

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
        // _onCreateOrderResult(data);
      });

      // Xử lý khi trạng thái đơn hàng thay đổi từ driver
      socket?.on('order_status_updated', (data) async {
        debugPrint('[Debug socket] order_status_updated: $data');
        // final socketResponse = _parseSocketResponse(data);
        // if (socketResponse.isSuccess && socketResponse.data != null) {
        //   orderStatus.value = AppOrderProcessStatus.values
        //       .byName(socketResponse.data!['processStatus']);
        //   statusStore.value = AppOrderStoreStatus.values
        //       .byName(socketResponse.data!['storeStatus']);
        //   _refreshOrder();
        // }
      });

      socket?.on('order_completed', (data) async {
        debugPrint('Debug socket: order_completed: $data');

        // final socketResponse = _parseSocketResponse(data);
        // if (socketResponse.isSuccess && socketResponse.data != null) {
        //   orderStatus.value = AppOrderProcessStatus.cancelled;

        //   appContext.pop();
        //   await appOpenDialog(WidgetDialogNotification(
        //       iconPng: 'image3',
        //       title: "Driver Has Arrived!".tr(),
        //       message: "Enjoy your meal!\nSee you in the next order :)",
        //       buttonText: "Done".tr(),
        //       onPressed: () {
        //         appHaptic();
        //         appContext.pop();
        //       }));
        //   appOpenBottomSheet(WidgetRatingDriver());
        // }
      });

      // Xử lý khi đơn hàng bị hủy
      socket?.on('order_cancelled', (data) async {
        debugPrint('Debug socket: order_cancelled: $data');

        // final socketResponse = _parseSocketResponse(data);
        // if (socketResponse.isSuccess && socketResponse.data != null) {
        //   orderStatus.value = AppOrderProcessStatus.values
        //       .byName(socketResponse.data!['processStatus']);

        //   appContext.pop();
        //   await appOpenDialog(WidgetDialogNotification(
        //       icon: 'icon60',
        //       title: "Order Cancelled!".tr(),
        //       message: "Your order has been cancelled.\nPlease try again.",
        //       buttonText: "Done".tr(),
        //       onPressed: () {
        //         appHaptic();
        //         appContext.pop();
        //       }));
        // }
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

  // Phương thức giải phóng tài nguyên
  void dispose() {
    debugPrint('Debug socket: Hủy CustomerSocketController');
    socket?.disconnect();
    socket?.dispose();
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
