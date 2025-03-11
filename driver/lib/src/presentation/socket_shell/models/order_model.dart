class Order {
  final String orderId;
  final String customerId;
  final Map<String, dynamic> orderDetails;
  final String status;
  final String? assignedDriver;
  final Map<String, dynamic> timestamps;

  Order({
    required this.orderId,
    required this.customerId,
    required this.orderDetails,
    required this.status,
    this.assignedDriver,
    required this.timestamps,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'] ?? '',
      customerId: json['customerId'] ?? '',
      orderDetails: json['orderDetails'] ?? {},
      status: json['status'] ?? 'pending',
      assignedDriver: json['assignedDriver'],
      timestamps: json['timestamps'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'orderDetails': orderDetails,
      'status': status,
      'assignedDriver': assignedDriver,
      'timestamps': timestamps,
    };
  }
}

class OrderStatus {
  static const String pending = 'pending'; // Đơn mới tạo, đang chờ phân công
  static const String assigned = 'assigned'; // Đã được gán cho tài xế
  static const String accepted = 'accepted'; // Tài xế đã xác nhận nhận đơn
  static const String picked = 'picked'; // Tài xế đã lấy đơn
  static const String inProgress =
      'in_progress'; // Tài xế đang di chuyển đến điểm giao
  static const String cancelled = 'cancelled'; // Đơn bị hủy
  static const String completed = 'completed'; // Đơn hoàn thành
}
