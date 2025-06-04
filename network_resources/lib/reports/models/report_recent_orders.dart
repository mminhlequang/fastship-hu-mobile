class ReportRecentOrderModel {
  int? id;
  String? orderNumber;
  String? status;
  double? totalAmount;
  int? totalItems;
  String? paymentMethod;
  String? paymentStatus;
  int? customerId;
  String? customerName;
  String? customerPhone;
  String? customerAddress;
  int? driverId;
  String? driverName;
  String? driverPhone;
  String? createdAt;
  String? updatedAt;

  ReportRecentOrderModel({
    this.id,
    this.orderNumber,
    this.status,
    this.totalAmount,
    this.totalItems,
    this.paymentMethod,
    this.paymentStatus,
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.customerAddress,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.createdAt,
    this.updatedAt,
  });

  ReportRecentOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    status = json['status'];
    totalAmount = json['total_amount']?.toDouble();
    totalItems = json['total_items'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    customerAddress = json['customer_address'];
    driverId = json['driver_id'];
    driverName = json['driver_name'];
    driverPhone = json['driver_phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (orderNumber != null) data['order_number'] = orderNumber;
    if (status != null) data['status'] = status;
    if (totalAmount != null) data['total_amount'] = totalAmount;
    if (totalItems != null) data['total_items'] = totalItems;
    if (paymentMethod != null) data['payment_method'] = paymentMethod;
    if (paymentStatus != null) data['payment_status'] = paymentStatus;
    if (customerId != null) data['customer_id'] = customerId;
    if (customerName != null) data['customer_name'] = customerName;
    if (customerPhone != null) data['customer_phone'] = customerPhone;
    if (customerAddress != null) data['customer_address'] = customerAddress;
    if (driverId != null) data['driver_id'] = driverId;
    if (driverName != null) data['driver_name'] = driverName;
    if (driverPhone != null) data['driver_phone'] = driverPhone;
    if (createdAt != null) data['created_at'] = createdAt;
    if (updatedAt != null) data['updated_at'] = updatedAt;
    return data;
  }
}
