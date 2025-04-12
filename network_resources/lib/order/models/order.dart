import 'package:network_resources/auth/models/models.dart';
import 'package:network_resources/cart/models/models.dart';
import 'package:network_resources/enums.dart';
import 'package:network_resources/store/models/models.dart';
import 'package:network_resources/transaction/models/payment_provider.dart';

class DriverNewOrderModel {
  OrderModel? order;
  int? responseTimeout;
  String? timestamp;

  DriverNewOrderModel({this.order, this.responseTimeout, this.timestamp});

  DriverNewOrderModel.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? OrderModel.fromJson(json['order']) : null;
    responseTimeout = json['responseTimeout'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order'] = order?.toJson();
    data['responseTimeout'] = responseTimeout;
    data['timestamp'] = timestamp;
    return data;
  }
}

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
  String? currency;
  String? deliveryType;
  String? storeStatus;
  String? paymentStatus;
  String? processStatus;
  dynamic note;
  dynamic cancelNote;
  PaymentWalletProvider? payment;
  StoreModel? store;
  AccountModel? customer;
  AccountModel? driver;
  List<CartItemModel>? items;
  dynamic phone;
  String? street;
  String? zip;
  String? city;
  String? state;
  String? country;
  String? countryCode;
  double? lat;
  double? lng;
  String? address;
  num? shipFee;
  num? tip;
  num? discount;
  num? applicationFee;
  num? subtotal;
  num? total;
  dynamic shipDistance;
  dynamic shipEstimateTime;
  dynamic shipPolyline;
  dynamic shipHereRaw;
  dynamic voucher;
  String? timeOrder;
  dynamic timePickupEstimate;
  dynamic timePickup;
  dynamic timeDelivery;

  AppOrderDeliveryType get deliveryTypeEnum => AppOrderDeliveryType.values
      .byName(deliveryType ?? AppOrderDeliveryType.ship.name);

  AppOrderStoreStatus get storeStatusEnum => AppOrderStoreStatus.values
      .byName(storeStatus ?? AppOrderStoreStatus.pending.name);

  AppPaymentOrderStatus get paymentStatusEnum => AppPaymentOrderStatus.values
      .byName(paymentStatus ?? AppPaymentOrderStatus.pending.name);

  AppOrderProcessStatus get processStatusEnum => AppOrderProcessStatus.values
      .byName(processStatus ?? AppOrderProcessStatus.pending.name);

  OrderModel({
    this.id,
    this.code,
    this.currency,
    this.deliveryType,
    this.storeStatus,
    this.paymentStatus,
    this.processStatus,
    this.note,
    this.cancelNote,
    this.payment,
    this.store,
    this.customer,
    this.driver,
    this.items,
    this.phone,
    this.street,
    this.zip,
    this.city,
    this.state,
    this.country,
    this.countryCode,
    this.lat,
    this.lng,
    this.address,
    this.shipFee,
    this.tip,
    this.discount,
    this.applicationFee,
    this.subtotal,
    this.total,
    this.shipDistance,
    this.shipEstimateTime,
    this.shipPolyline,
    this.shipHereRaw,
    this.voucher,
    this.timeOrder,
    this.timePickupEstimate,
    this.timePickup,
    this.timeDelivery,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    code = json["code"];
    currency = json["currency"];
    deliveryType = json["delivery_type"];
    storeStatus = json["store_status"];
    paymentStatus = json["payment_status"];
    processStatus = json["process_status"];
    note = json["note"];
    cancelNote = json["cancel_note"];
    payment =
        json["payment"] == null ? null : PaymentWalletProvider.fromJson(json["payment"]);
    store = json["store"] == null ? null : StoreModel.fromJson(json["store"]);
    customer =
        json["customer"] == null ? null : AccountModel.fromJson(json["customer"]);
    driver = json["driver"] == null ? null : AccountModel.fromJson(json["driver"]);
    items =
        json["items"] == null
            ? null
            : (json["items"] as List).map((e) => CartItemModel.fromJson(e)).toList();
    phone = json["phone"];
    street = json["street"];
    zip = json["zip"];
    city = json["city"];
    state = json["state"];
    country = json["country"];
    countryCode = json["country_code"];
    lat = json["lat"]?.toDouble();
    lng = json["lng"]?.toDouble();
    address = json["address"];
    shipFee = json["ship_fee"];
    tip = json["tip"];
    discount = json["discount"];
    applicationFee = json["application_fee"];
    subtotal = json["subtotal"];
    total = json["total"];
    shipDistance = json["ship_distance"];
    shipEstimateTime = json["ship_estimate_time"];
    shipPolyline = json["ship_polyline"];
    shipHereRaw = json["ship_here_raw"];
    voucher = json["voucher"];
    timeOrder = json["time_order"];
    timePickupEstimate = json["time_pickup_estimate"];
    timePickup = json["time_pickup"];
    timeDelivery = json["time_delivery"];
  }

  static List<OrderModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(OrderModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["code"] = code;
    _data["currency"] = currency;
    _data["delivery_type"] = deliveryType;
    _data["store_status"] = storeStatus;
    _data["payment_status"] = paymentStatus;
    _data["process_status"] = processStatus;
    _data["note"] = note;
    _data["cancel_note"] = cancelNote;
    if (payment != null) {
      _data["payment"] = payment?.toJson();
    }
    if (store != null) {
      _data["store"] = store?.toJson();
    }
    if (customer != null) {
      _data["customer"] = customer?.toJson();
    }
    if (driver != null) {
      _data["driver"] = driver?.toJson();
    }
    if (items != null) {
      _data["items"] = items?.map((e) => e.toJson()).toList();
    }
    _data["phone"] = phone;
    _data["street"] = street;
    _data["zip"] = zip;
    _data["city"] = city;
    _data["state"] = state;
    _data["country"] = country;
    _data["country_code"] = countryCode;
    _data["lat"] = lat;
    _data["lng"] = lng;
    _data["address"] = address;
    _data["ship_fee"] = shipFee;
    _data["tip"] = tip;
    _data["discount"] = discount;
    _data["application_fee"] = applicationFee;
    _data["subtotal"] = subtotal;
    _data["total"] = total;
    _data["ship_distance"] = shipDistance;
    _data["ship_estimate_time"] = shipEstimateTime;
    _data["ship_polyline"] = shipPolyline;
    _data["ship_here_raw"] = shipHereRaw;
    _data["voucher"] = voucher;
    _data["time_order"] = timeOrder;
    _data["time_pickup_estimate"] = timePickupEstimate;
    _data["time_pickup"] = timePickup;
    _data["time_delivery"] = timeDelivery;
    return _data;
  }
} 
