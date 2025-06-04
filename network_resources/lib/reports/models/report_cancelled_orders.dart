class ReportCancelledOrderModel {
  int? id;
  String? orderNumber;
  String? cancelReason;
  String? cancelNote;
  double? totalAmount;
  int? totalItems;
  String? paymentMethod;
  String? paymentStatus;
  int? customerId;
  String? customerName;
  String? customerPhone;
  String? customerAddress;
  String? cancelledAt;
  String? createdAt;
  String? updatedAt;

  ReportCancelledOrderModel({
    this.id,
    this.orderNumber,
    this.cancelReason,
    this.cancelNote,
    this.totalAmount,
    this.totalItems,
    this.paymentMethod,
    this.paymentStatus,
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.customerAddress,
    this.cancelledAt,
    this.createdAt,
    this.updatedAt,
  });

  ReportCancelledOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['order_number'];
    cancelReason = json['cancel_reason'];
    cancelNote = json['cancel_note'];
    totalAmount = json['total_amount']?.toDouble();
    totalItems = json['total_items'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    customerAddress = json['customer_address'];
    cancelledAt = json['cancelled_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (orderNumber != null) data['order_number'] = orderNumber;
    if (cancelReason != null) data['cancel_reason'] = cancelReason;
    if (cancelNote != null) data['cancel_note'] = cancelNote;
    if (totalAmount != null) data['total_amount'] = totalAmount;
    if (totalItems != null) data['total_items'] = totalItems;
    if (paymentMethod != null) data['payment_method'] = paymentMethod;
    if (paymentStatus != null) data['payment_status'] = paymentStatus;
    if (customerId != null) data['customer_id'] = customerId;
    if (customerName != null) data['customer_name'] = customerName;
    if (customerPhone != null) data['customer_phone'] = customerPhone;
    if (customerAddress != null) data['customer_address'] = customerAddress;
    if (cancelledAt != null) data['cancelled_at'] = cancelledAt;
    if (createdAt != null) data['created_at'] = createdAt;
    if (updatedAt != null) data['updated_at'] = updatedAt;
    return data;
  }
}
