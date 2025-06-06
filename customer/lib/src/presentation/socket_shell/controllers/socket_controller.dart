import 'dart:async';
import 'dart:convert';

import 'package:app/src/presentation/navigation/cubit/navigation_cubit.dart';
import 'package:app/src/presentation/widgets/widget_dialog_notification.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_network/network_resources/model/model.dart';
import 'package:latlong2/latlong.dart';
import 'package:network_resources/network_resources.dart';
import 'package:network_resources/order/models/models.dart';
import 'package:network_resources/order/repo.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:toastification/toastification.dart';

import '../models/socket_response.dart';

CustomerSocketController get socketController =>
    findInstance<CustomerSocketController>();

class CustomerSocketController {
  IO.Socket? socket;

  OrderModel? currentOrder;

  final ValueNotifier<AppOrderProcessStatus?> orderStatus =
      ValueNotifier<AppOrderProcessStatus?>(null);
  final ValueNotifier<AppOrderStoreStatus?> statusStore =
      ValueNotifier<AppOrderStoreStatus?>(null);
  final ValueNotifier<bool> socketConnected = ValueNotifier<bool>(false);
  final ValueNotifier<LatLng?> driverLocation = ValueNotifier<LatLng?>(null);

  // Các callback để cập nhật UI
  Function(AppOrderProcessStatus)? onOrderStatusChanged;

  _resetState() {
    orderStatus.value = null;
    statusStore.value = null;
    currentOrder = null;
    driverLocation.value = null;
  }

  void initializeSocket() async {
    try {
      socket = IO.io(
        socketIOUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableForceNew()
            .setAuth({
              'token': await AppPrefs.instance.getNormalToken(),
              'userType': 'customer',
            })
            .build(),
      );

      socket?.onConnect((_) {
        debugPrint('Debug socket: connected');
        socketConnected.value = true;
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

      // Xử lý khi trạng thái đơn hàng thay đổi từ driver
      socket?.on('order_status_updated', (data) async {
        debugPrint('[Debug socket] order_status_updated: $data');
        final socketResponse = _parseSocketResponse(data);
        if (socketResponse.isSuccess && socketResponse.data != null) {
          if (socketResponse.data!['processStatus'] != null) {
            final newProcessStatus = AppOrderProcessStatus.values
                .byName(socketResponse.data!['processStatus']);
            if (orderStatus.value != newProcessStatus) {
              appShowToastification(
                title: "Order Status Updated".tr(),
                description: newProcessStatus.textNotification.tr(),
                type: ToastificationType.success,
              );
            }
            orderStatus.value = newProcessStatus;
          }
          if (socketResponse.data!['storeStatus'] != null) {
            final newStoreStatus = AppOrderStoreStatus.values
                .byName(socketResponse.data!['storeStatus']);
            if (statusStore.value != newStoreStatus) {
              appShowToastification(
                title: "Store Status Updated".tr(),
                description: newStoreStatus.textNotification.tr(),
                type: ToastificationType.success,
              );
            }
            statusStore.value = newStoreStatus;
          }

          _refreshOrder();
        }
      });

      //driver_location_update: {orderId: 278, driverId: 13, location: {lat: 37.785834, lng: -122.406417}, timestamp: 2025-06-01T14:16:06.587Z}
      socket?.on('driver_location_update', (data) {
        final Map<String, dynamic> socketResponse =
            data is String ? jsonDecode(data) : Map<String, dynamic>.from(data);
        driverLocation.value = LatLng(socketResponse['location']['lat'],
            socketResponse['location']['lng']);
        print(
            'Debug socket: driverLocation: ${driverLocation.value?.latitude}, ${driverLocation.value?.longitude}');
      });

      socket?.on('order_completed', (data) async {
        debugPrint('Debug socket: order_completed: $data');

        final socketResponse = _parseSocketResponse(data);
        if (socketResponse.isSuccess && socketResponse.data != null) {
          _resetState();

          appContext.pop();

          // Randomly select a title and message to display
          final List<String> titles = [
            "Order Completed!".tr(),
            "Your Meal is Ready!".tr(),
            "Enjoy Your Meal!".tr(),
            "Bon Appétit!".tr(),
            "Meal Time!".tr()
          ];
          final List<String> messages = [
            "Enjoy your meal!\nSee you in the next order :)",
            "Bon appétit!\nLooking forward to serving you again!",
            "Hope you have a delicious meal!\nCome back soon!",
            "Savor your meal!\nWe can't wait to see you again!",
            "Have a great meal!\nThank you for choosing us!"
          ];
          final String randomTitle = (titles..shuffle()).first;
          final String randomMessage = (messages..shuffle()).first;

          await appOpenDialog(WidgetDialogNotification(
              iconPng: 'image3',
              title: randomTitle,
              message: randomMessage,
              buttonText: "Done".tr(),
              onPressed: () {
                appHaptic();
                appContext.pop();
              }));
          navigationCubit.changeIndex(3);
        }
      });

      // Xử lý khi đơn hàng bị hủy
      socket?.on('order_cancelled', (data) async {
        debugPrint('Debug socket: order_cancelled: $data');

        final socketResponse = _parseSocketResponse(data);
        if (socketResponse.isSuccess && socketResponse.data != null) {
          bool isCancelledByUser =
              socketResponse.data!["cancelledBy"]?['type'] == 'customer';

          appContext.pop();

          await appOpenDialog(
            WidgetDialogNotification(
              iconPng: 'image5',
              title: isCancelledByUser
                  ? "We're so sad about your cancellation".tr()
                  : "Order Cancelled!".tr(),
              message: isCancelledByUser
                  ? "We will continue to improve our service & satisfy you on the next order."
                      .tr()
                  : "Your order has been cancelled.\nPlease try again.",
              buttonText: "Done".tr(),
              onPressed: () {
                appHaptic();
                appContext.pop();
                navigationCubit.changeIndex(3);
              },
            ),
          );
          _resetState();
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
      AppOrderProcessStatus processStatus = AppOrderProcessStatus.values
          .byName(socketResponse.data!['process_status']);

      if (processStatus == AppOrderProcessStatus.storeAccepted) {
        await Future.delayed(Duration(seconds: 1));
        await _refreshOrder();
        if (!_createOrderCompleter.isCompleted) {
          _createOrderCompleter.complete(true);
        }
      } else {
        AppFindDriverStatus findDriverStatus = AppFindDriverStatus.values
            .byName(socketResponse.data!['find_driver_status']);
        switch (findDriverStatus) {
          case AppFindDriverStatus.finding:
            break;
          case AppFindDriverStatus.availableDrivers:
            break;
          case AppFindDriverStatus.found:
            orderStatus.value = AppOrderProcessStatus.driverAccepted;
            await Future.delayed(Duration(seconds: 2));
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
  }

  late Completer<bool> _userPickedUpCompleter;
  Future<bool> userPickedUp(String orderId) async {
    if (currentOrder != null && socket?.connected == true) {
      _userPickedUpCompleter = Completer<bool>();

      debugPrint(
          'Debug socket: Gửi yêu cầu cập nhật trạng thái đơn hàng ID: $orderId  ');
      orderStatus.value = AppOrderProcessStatus.completed;
      statusStore.value = AppOrderStoreStatus.completed;

      // Gửi cập nhật lên server
      socket?.emit('complete_order', {
        'orderId': orderId,
      });

      // Lắng nghe phản hồi
      socket?.once('order_completed_confirmation', (data) {
        final socketResponse = _parseSocketResponse(data);
        _userPickedUpCompleter.complete(socketResponse.isSuccess);
        if (socketResponse.isSuccess) {
          debugPrint(
              'Debug socket: Trạng thái đơn hàng đã được hoàn thành thành công');

          // currentOrder = null;

          // Timer(const Duration(seconds: 10), () {
          //   orderStatus.value = AppOrderProcessStatus.pending;
          // });
        } else {
          // orderStatus.value = AppOrderProcessStatus.completed;
          debugPrint(
              'Debug socket: Lỗi khi hoàn thành đơn hàng: ${socketResponse.messageCode}');
          // appShowSnackBar(msg: 'Error when complete order'.tr());
        }
      });
      return await _userPickedUpCompleter.future;
    } else {
      debugPrint(
          'Debug socket: Không thể cập nhật trạng thái - đơn hàng hiện tại: ${currentOrder != null}, socket kết nối: ${socket?.connected}');

      return false;
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
        return "Being processed";
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
        return "Being processed";
    }
  }
}

extension AppOrderStoreStatusExtension on AppOrderStoreStatus {
  String get textNotification {
    switch (this) {
      case AppOrderStoreStatus.pending:
        return "Store is being processed";
      case AppOrderStoreStatus.completed:
        return "Store completed";
      default:
        return "Being processed";
    }
  }
}
