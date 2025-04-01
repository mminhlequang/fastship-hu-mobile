class CreateOrderResponse {
  String? clientSecret;
  OrderModel? order;

  CreateOrderResponse({this.clientSecret, this.order});

  CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    if (json['clientSecret'] == null) {
      order = OrderModel.fromJson(json);
    } else {
      clientSecret = json['clientSecret'];
      order = json['order'] != null ? OrderModel.fromJson(json['order']) : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientSecret'] = clientSecret;
    data['order'] = order?.toJson();
    return data;
  }
}

class OrderModel {
  int? id;
  String? code;
  int? storeId;
  String? storeName;
  String? storeImage;
  String? storeAddress;
  String? storePhone;
  String? storeLat;
  String? storeLng;
  int? userId;
  String? userName;
  String? userPhone;
  String? userAddress;
  String? userLat;
  String? userLng;
  String? paymentType;
  int? paymentId;
  String? paymentName;
  int? voucherId;
  String? voucherCode;
  int? voucherValue;
  double? priceTip;
  double? fee;
  String? note;
  int? approveId;
  String? approveName;
  String? cancelNote;
  String? createdAt;
  String? updatedAt;

  OrderModel({
    this.id,
    this.code,
    this.storeId,
    this.storeName,
    this.storeImage,
    this.storeAddress,
    this.storePhone,
    this.storeLat,
    this.storeLng,
    this.userId,
    this.userName,
    this.userPhone,
    this.userAddress,
    this.userLat,
    this.userLng,
    this.paymentType,
    this.paymentId,
    this.paymentName,
    this.voucherId,
    this.voucherCode,
    this.voucherValue,
    this.priceTip,
    this.fee,
    this.note,
    this.approveId,
    this.approveName,
    this.cancelNote,
    this.createdAt,
    this.updatedAt,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    storeId = json['store_id'];
    storeName = json['store_name'];
    storeImage = json['store_image'];
    storeAddress = json['store_address'];
    storePhone = json['store_phone'];
    storeLat = json['store_lat'];
    storeLng = json['store_lng'];
    userId = json['user_id'];
    userName = json['user_name'];
    userPhone = json['user_phone'];
    userAddress = json['user_address'];
    userLat = json['user_lat'];
    userLng = json['user_lng'];
    paymentType = json['payment_type'];
    paymentId = json['payment_id'];
    paymentName = json['payment_name'];
    voucherId = json['voucher_id'];
    voucherCode = json['voucher_code'];
    voucherValue = json['voucher_value'];
    priceTip = json['price_tip']?.toDouble();
    fee = json['fee']?.toDouble();
    note = json['note'];
    approveId = json['approve_id'];
    approveName = json['approve_name'];
    cancelNote = json['cancel_note'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (code != null) data['code'] = code;
    if (storeId != null) data['store_id'] = storeId;
    if (storeName != null) data['store_name'] = storeName;
    if (storeImage != null) data['store_image'] = storeImage;
    if (storeAddress != null) data['store_address'] = storeAddress;
    if (storePhone != null) data['store_phone'] = storePhone;
    if (storeLat != null) data['store_lat'] = storeLat;
    if (storeLng != null) data['store_lng'] = storeLng;
    if (userId != null) data['user_id'] = userId;
    if (userName != null) data['user_name'] = userName;
    if (userPhone != null) data['user_phone'] = userPhone;
    if (userAddress != null) data['user_address'] = userAddress;
    if (userLat != null) data['user_lat'] = userLat;
    if (userLng != null) data['user_lng'] = userLng;
    if (paymentType != null) data['payment_type'] = paymentType;
    if (paymentId != null) data['payment_id'] = paymentId;
    if (paymentName != null) data['payment_name'] = paymentName;
    if (voucherId != null) data['voucher_id'] = voucherId;
    if (voucherCode != null) data['voucher_code'] = voucherCode;
    if (voucherValue != null) data['voucher_value'] = voucherValue;
    if (priceTip != null) data['price_tip'] = priceTip;
    if (fee != null) data['fee'] = fee;
    if (note != null) data['note'] = note;
    if (approveId != null) data['approve_id'] = approveId;
    if (approveName != null) data['approve_name'] = approveName;
    if (cancelNote != null) data['cancel_note'] = cancelNote;
    if (createdAt != null) data['created_at'] = createdAt;
    if (updatedAt != null) data['updated_at'] = updatedAt;
    return data;
  }
}
