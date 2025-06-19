import 'dart:async';
import 'dart:convert';

import 'package:app/src/constants/constants.dart';
import 'package:app/src/services/location_service.dart';
import 'package:app/src/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internal_core/internal_core.dart';
import 'package:latlong2/latlong.dart';
import 'package:network_resources/network_resources.dart';
import 'package:network_resources/order/models/models.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vibration/vibration.dart';

import '../models/socket_response.dart';

// List of predefined locations with latitude and longitude
const List<LatLng> listLocation = [
  LatLng(47.49661, 19.06875),
  LatLng(47.49663, 19.06888),
  LatLng(47.49674, 19.06934),
  LatLng(47.49675, 19.06939),
  LatLng(47.49689, 19.0699),
  LatLng(47.49695, 19.07007),
  LatLng(47.49707, 19.07043),
  LatLng(47.49682, 19.07045),
  LatLng(47.49664, 19.07049),
  LatLng(47.49642, 19.07057),
  LatLng(47.49625, 19.07064),
  LatLng(47.49619, 19.07066),
  LatLng(47.49606, 19.0707),
  LatLng(47.49571, 19.07078),
  LatLng(47.49539, 19.07083),
  LatLng(47.49423, 19.07096),
  LatLng(47.49356, 19.07102),
  LatLng(47.49347, 19.07039),
  LatLng(47.49337, 19.06979),
  LatLng(47.49356, 19.06978),
  LatLng(47.49419, 19.06974),
  LatLng(47.49454, 19.06971),
];

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

  final LocationService _locationService = LocationService();
  bool _isInBackground = false;
  StreamSubscription<LatLng>? _locationSubscription;

  bool get isOnline => _isOnline;

  void init() {
    _initializeSocket();
    _initializeLocationService();
    if (AppPrefs.instance.autoActiveOnlineStatus) {
      setOnlineStatus(true);
    }
  }

  void _initializeSocket() async {
    try {
      socket = IO.io(
        socketIOUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableForceNew()
            .setAuth({
              'token': await AppPrefs.instance.getNormalToken(),
              'userType': 'driver',
            })
            .build(),
      );

      socket?.onConnect((_) {
        debugPrint('Debug socket: connected to $socketIOUrl');
        socketConnected.value = true;
        socket?.emit("joinRoom", "driver_${AppPrefs.instance.user?.id}");
      });

      socket?.on('current_order_info', (data) {
        debugPrint('Debug socket: current_order_info ${data}');
        _handleNewOrder(data, isOldOrder: true);
      });

      socket?.onDisconnect((_) {
        debugPrint('Debug socket: disconnect ');
        socketConnected.value = false;
      });

      socket?.on('driver_new_order_request', (data) {
        debugPrint('Debug socket: driver_new_order_request ${data}');
        _handleNewOrder(data);
      });

      socket?.on('order_cancelled', (data) {
        debugPrint('Debug socket: order_cancelled ${data}');
        _handleOrderCanceled(data);
      });

      // Thêm xử lý event nhận phản hồi xác thực thành công
      socket?.on('authentication_success', (data) {
        debugPrint('Debug socket: authentication_success ${data}');
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
        debugPrint('Debug socket: authentication_error ${data}');
        final socketResponse = _parseSocketResponse(data);
        // Có thể thêm xử lý khi xác thực thất bại
      });

      socket?.on('error', (data) {
        debugPrint('Debug socket: error ${data}');
        final socketResponse = _parseSocketResponse(data);
      });

      socket?.connect();
      debugPrint('Debug socket: Đã gọi lệnh kết nối');
    } catch (e) {
      debugPrint('Debug socket: Lỗi kết nối socket: $e');
    }
  }

  Future<void> _initializeLocationService() async {
    await _locationService.initialize();
    // Lắng nghe sự kiện vị trí từ LocationService
    _locationSubscription = _locationService.locationStream.listen((latLng) {
      updateLocationInBackground(latLng);
    });
  }

  Future askPermissionWithExplanationDialog() async {
    final result = await showModalBottomSheet(
      context: appContext,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(appContext),
        duration: const Duration(milliseconds: 300),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              16.sw, 40.sw, 16.sw, 24.sw + context.mediaQueryPadding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 36.sw,
                backgroundColor: hexColor('#74CA45').withValues(alpha: .25),
                child: WidgetAppSVG('ic_redirect'),
              ),
              Gap(32.sw),
              Text(
                'Allow Location Access'.tr(),
                style: w700TextStyle(fontSize: 20.sw),
              ),
              Gap(8.sw),
              Text(
                'You\'ll need to give Fast Ship permission to always use your location to get notifications about order near you'
                    .tr(),
                style: w400TextStyle(fontSize: 16.sw),
                textAlign: TextAlign.center,
              ),
              Gap(32.sw),
              WidgetRippleButton(
                onTap: () => Navigator.pop(context, true),
                color: appColorPrimary,
                child: SizedBox(
                  height: 48.sw,
                  child: Center(
                    child: Text(
                      'Continue'.tr(),
                      style: w500TextStyle(
                        fontSize: 16.sw,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(8.sw),
              WidgetRippleButton(
                onTap: () {
                  openAppSettings();
                },
                borderSide: BorderSide(color: appColorPrimary),
                child: SizedBox(
                  height: 48.sw,
                  child: Center(
                    child: Text(
                      'Open settings'.tr(),
                      style: w500TextStyle(
                        fontSize: 16.sw,
                        color: appColorPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (result == true) {
      await Permission.locationWhenInUse.request();
      await Permission.locationAlways.request();
    }
  }

  /// Set online status for driver. Only allow online if location permission is granted.
  Future<bool> setOnlineStatus(bool isOnline) async {
    if (isOnline) {
      final hasPermission =
          await _locationService.isLocationPermissionGranted();
      if (!hasPermission) {
        debugPrint('Debug socket: Không thể online do chưa có quyền location');
        await askPermissionWithExplanationDialog();
        if (!(await _locationService.isLocationPermissionGranted())) {
          appShowSnackBar(
              msg: 'Location permission is required to be online'.tr());
          return false;
        }
      }
    }
    debugPrint('Debug socket: Đặt trạng thái online: $isOnline');
    _isOnline = isOnline;

    // Gửi trạng thái lên server
    _emitDriverStatus(isOnline);

    // Quản lý timer vị trí và background service
    if (isOnline) {
      if (_isInBackground) {
        _locationService.startService();
      } else {
        _startLocationUpdates();
      }
    } else {
      _stopLocationUpdates();
      _locationService.stopService();
    }
    return true;
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
        Timer.periodic(const Duration(seconds: kDebugMode ? 15 : 30), (_) {
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
      LatLng latLng = LatLng(position.latitude, position.longitude);
      //TODO: remove later
      fakeIndexLocation++;
      latLng =
          fakeIndexLocation != -1 && fakeIndexLocation < listLocation.length
              ? listLocation[fakeIndexLocation]
              : LatLng(47.500976, 19.061095);

      currentLocation.value = latLng;

      if (socket?.connected == true && _isOnline) {
        debugPrint(
            'Debug socket: Gửi vị trí lên server ${latLng.latitude}, ${latLng.longitude}');
        socket?.emit('driver_update_location', {
          'latitude': latLng.latitude,
          'longitude': latLng.longitude,
        });
      } else {
        debugPrint(
            'Debug socket: Không thể gửi vị trí - socket: ${socket?.connected}, online: $_isOnline');
      }
    } catch (e) {
      debugPrint('Debug socket: Lỗi lấy vị trí: $e');
    }
  }

  void _handleNewOrder(dynamic data, {bool isOldOrder = false}) {
    final socketResponse = _parseSocketResponse(data);

    if (socketResponse.isSuccess && socketResponse.data != null) {
      // Chuyển đổi dữ liệu thành đối tượng Order
      // {
      //   order: order.getOrderData(),
      //   responseTimeout: 30, // Thời gian chờ phản hồi (giây)
      //   timestamp: new Date().toISOString()
      // }
      clearAllRouters();
      final driverNewOrder = DriverNewOrderModel.fromJson(socketResponse.data);
      currentOrder = driverNewOrder.order;
      responseTimeout = driverNewOrder.responseTimeout;
      timestampOrderReceived = DateTime.parse(driverNewOrder.timestamp!);
      if (isOldOrder) {
        orderStatus.value = currentOrder!.processStatusEnum;
      } else {
        orderStatus.value = AppOrderProcessStatus.findDriver;
      }
      debugPrint(
          'Debug socket: Thông tin đơn hàng mới: ${jsonEncode(currentOrder)}');

      // Thông báo cho UI
      debugPrint('Debug socket: Gọi callback cập nhật trạng thái đơn hàng');
      onNewOrder?.call(currentOrder!);

      // Rung điện thoại
      debugPrint('Debug socket: Kích hoạt rung');
      Vibration.vibrate(pattern: [500, 1000, 500, 1000]);
      if (!isOldOrder) {
        Timer(Duration(seconds: responseTimeout!), () {
          if (orderStatus.value == AppOrderProcessStatus.findDriver) {
            currentOrder = null;
            orderStatus.value = AppOrderProcessStatus.pending;
          }
        });
      }
    } else {
      debugPrint(
          'Debug socket: Lỗi khi nhận đơn hàng mới: ${socketResponse.messageCode}');
    }
  }

  void _handleOrderCanceled(dynamic data) {
    currentOrder = null;
    orderStatus.value = AppOrderProcessStatus.cancelled;

    Timer(const Duration(seconds: 10), () {
      orderStatus.value = AppOrderProcessStatus.pending;
    });
  }

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

  int fakeIndexLocation = -1;
  void updateOrderStatus(AppOrderProcessStatus status) {
    if (status == AppOrderProcessStatus.driverPicked) {
      fakeIndexLocation = -1;
      fakeIndexLocation++;
    }
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

            Timer(const Duration(seconds: 10), () {
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

  // Phương thức để cập nhật vị trí từ background service
  void updateLocationInBackground(LatLng location) {
    currentLocation.value = location;
    if (socket?.connected == true && _isOnline) {
      debugPrint(
          'Debug socket: Gửi vị trí từ background ${location.latitude}, ${location.longitude}');
      socket?.emit('driver_update_location', {
        'latitude': location.latitude,
        'longitude': location.longitude,
      });
    }
  }

  // Xử lý khi app chuyển background
  void onAppBackground() {
    _isInBackground = true;
    if (_isOnline) {
      _locationService.startService();
    }
  }

  // Xử lý khi app chuyển foreground
  void onAppForeground() {
    _isInBackground = false;
    if (_isOnline) {
      _locationService.stopService();
      _startLocationUpdates();
    }
  }

  void dispose() {
    debugPrint('Debug socket: Hủy SocketController');
    socket?.disconnect();
    socket?.dispose();
    _locationTimer?.cancel();
    _locationService.stopService();
    _locationSubscription?.cancel();
    // orderStatus.dispose();
    // socketConnected.dispose();
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
