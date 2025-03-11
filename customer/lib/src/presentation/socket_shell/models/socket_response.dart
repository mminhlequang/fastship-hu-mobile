class SocketResponse {
  final bool isSuccess;
  final String timestamp;
  final String messageCode;
  final dynamic data;

  SocketResponse({
    required this.isSuccess,
    required this.timestamp,
    required this.messageCode,
    this.data,
  });

  factory SocketResponse.fromJson(Map<String, dynamic> json) {
    return SocketResponse(
      isSuccess: json['isSuccess'] ?? false,
      timestamp: json['timestamp'] ?? DateTime.now().toIso8601String(),
      messageCode: json['messageCode'] ?? 'UNKNOWN',
      data: json['data'],
    );
  }

  bool get isError => !isSuccess;
}

// Class MessageCodes để đồng bộ với server
class MessageCodes {
  // Mã thành công
  static const String SUCCESS = 'SUCCESS';

  // Mã lỗi xác thực
  static const String AUTH_FAILED = 'AUTH_FAILED';
  static const String TOKEN_INVALID = 'TOKEN_INVALID';
  static const String TOKEN_EXPIRED = 'TOKEN_EXPIRED';
  static const String TOKEN_MISSING = 'TOKEN_MISSING';
  static const String CUSTOMER_ID_MISSING = 'CUSTOMER_ID_MISSING';
  static const String ADMIN_KEY_INVALID = 'ADMIN_KEY_INVALID';

  // Mã lỗi đơn hàng
  static const String ORDER_NOT_FOUND = 'ORDER_NOT_FOUND';
  static const String ORDER_CREATION_FAILED = 'ORDER_CREATION_FAILED';
  static const String ORDER_ID_MISSING = 'ORDER_ID_MISSING';
  static const String ORDER_INVALID_STATUS = 'ORDER_INVALID_STATUS';
  static const String ORDER_INVALID_TRANSITION = 'ORDER_INVALID_TRANSITION';
  static const String ORDER_DRIVER_ASSIGNMENT_FAILED =
      'ORDER_DRIVER_ASSIGNMENT_FAILED';
  static const String ORDER_CANCEL_FAILED = 'ORDER_CANCEL_FAILED';
  static const String ORDER_UPDATE_FAILED = 'ORDER_UPDATE_FAILED';
  static const String NO_AVAILABLE_DRIVER = 'NO_AVAILABLE_DRIVER';

  // Mã lỗi tài xế
  static const String DRIVER_NOT_FOUND = 'DRIVER_NOT_FOUND';
  static const String DRIVER_OFFLINE = 'DRIVER_OFFLINE';
  static const String DRIVER_BUSY = 'DRIVER_BUSY';
  static const String DRIVER_UPDATE_FAILED = 'DRIVER_UPDATE_FAILED';
  static const String LOCATION_INVALID = 'LOCATION_INVALID';
  static const String DRIVER_NOT_AUTHORIZED = 'DRIVER_NOT_AUTHORIZED';

  // Mã lỗi chung
  static const String INVALID_PARAMS = 'INVALID_PARAMS';
  static const String PERMISSION_DENIED = 'PERMISSION_DENIED';
  static const String SERVER_ERROR = 'SERVER_ERROR';
  static const String CUSTOMER_NOT_AUTHORIZED = 'CUSTOMER_NOT_AUTHORIZED';
}
