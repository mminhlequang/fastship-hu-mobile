import 'package:network_resources/auth/models/models.dart';
import 'package:network_resources/cart/models/models.dart';
import 'package:network_resources/enums.dart';
import 'package:network_resources/store/models/models.dart';
import 'package:network_resources/transaction/models/payment_provider.dart';

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
  num? totalPrice;
  String? currency;
  String? paymentType;
  String? paymentStatus;
  String? processStatus;
  dynamic note;
  PaymentWalletProvider? payment;
  StoreModel? store;
  AccountModel? customer;
  AccountModel? driver;
  List<CartItemModel>? items;
  num? fee;
  num? priceTip;
  num? distance;
  String? phone;
  String? street;
  String? zip;
  String? city;
  String? state;
  String? country;
  String? countryCode;
  double? lat;
  double? lng;
  String? address;
  dynamic voucher;
  int? voucherValue;
  String? timeOrder;
  dynamic timePickupEstimate;
  dynamic timePickup;
  dynamic timeDelivery;


  //Getters to handle
  
  AppPaymentOrderStatus get paymentStatusEnum => AppPaymentOrderStatus.values
      .byName(paymentStatus ?? AppPaymentOrderStatus.pending.name);

  AppOrderProcessStatus get processStatusEnum => AppOrderProcessStatus.values
      .byName(processStatus ?? AppOrderProcessStatus.pending.name);

  OrderModel({
    this.id,
    this.code,
    this.totalPrice,
    this.currency,
    this.paymentType,
    this.paymentStatus,
    this.processStatus,
    this.note,
    this.payment,
    this.store,
    this.customer,
    this.driver,
    this.items,
    this.fee,
    this.priceTip,
    this.distance,
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
    this.voucher,
    this.voucherValue,
    this.timeOrder,
    this.timePickupEstimate,
    this.timePickup,
    this.timeDelivery,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    code = json["code"];
    totalPrice = json["total_price"];
    currency = json["currency"];
    paymentType = json["payment_type"];
    paymentStatus = json["payment_status"];
    processStatus = json["process_status"];
    note = json["note"];
    payment =
        json["payment"] == null
            ? null
            : PaymentWalletProvider.fromJson(json["payment"]);
    store = json["store"] == null ? null : StoreModel.fromJson(json["store"]);
    customer =
        json["customer"] == null
            ? null
            : AccountModel.fromJson(json["customer"]);
    driver =
        json["driver"] == null ? null : AccountModel.fromJson(json["driver"]);
    items =
        json["items"] == null
            ? null
            : (json["items"] as List)
                .map((e) => CartItemModel.fromJson(e))
                .toList();
    fee = json["fee"];
    priceTip = json["price_tip"];
    distance = json["distance"];
    phone = json["phone"];
    street = json["street"];
    zip = json["zip"];
    city = json["city"];
    state = json["state"];
    country = json["country"];
    countryCode = json["country_code"];
    lat = json["lat"];
    lng = json["lng"];
    address = json["address"];
    voucher = json["voucher"];
    voucherValue = json["voucher_value"];
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
    _data["total_price"] = totalPrice;
    _data["currency"] = currency;
    _data["payment_type"] = paymentType;
    _data["payment_status"] = paymentStatus;
    _data["process_status"] = processStatus;
    _data["note"] = note;
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
    _data["fee"] = fee;
    _data["price_tip"] = priceTip;
    _data["distance"] = distance;
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
    _data["voucher"] = voucher;
    _data["voucher_value"] = voucherValue;
    _data["time_order"] = timeOrder;
    _data["time_pickup_estimate"] = timePickupEstimate;
    _data["time_pickup"] = timePickup;
    _data["time_delivery"] = timeDelivery;
    return _data;
  }
}
