import 'package:app/src/network_resources/store/models/store.dart';

class OrderModel {
  int? id;
  String? code;
  int? userId;
  int? storeId;
  int? driverId;
  String? status;
  String? paymentMethod;
  String? paymentStatus;
  double? totalAmount;
  double? deliveryFee;
  double? discountAmount;
  double? finalAmount;
  String? deliveryAddress;
  String? deliveryNote;
  String? deliveryTime;
  int? itemCount;
  List<OrderItemModel>? items;
  StoreModel? store;
  String? createdAt;
  String? updatedAt;

  OrderModel({
    this.id,
    this.code,
    this.userId,
    this.storeId,
    this.driverId,
    this.status,
    this.paymentMethod,
    this.paymentStatus,
    this.totalAmount,
    this.deliveryFee,
    this.discountAmount,
    this.finalAmount,
    this.deliveryAddress,
    this.deliveryNote,
    this.deliveryTime,
    this.itemCount,
    this.items,
    this.store,
    this.createdAt,
    this.updatedAt,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    userId = json['user_id'];
    storeId = json['store_id'];
    driverId = json['driver_id'];
    status = json['status'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    totalAmount = json['total_amount']?.toDouble();
    deliveryFee = json['delivery_fee']?.toDouble();
    discountAmount = json['discount_amount']?.toDouble();
    finalAmount = json['final_amount']?.toDouble();
    deliveryAddress = json['delivery_address'];
    deliveryNote = json['delivery_note'];
    deliveryTime = json['delivery_time'];
    itemCount = json['item_count'];
    if (json['items'] != null) {
      items = <OrderItemModel>[];
      json['items'].forEach((v) {
        items!.add(OrderItemModel.fromJson(v));
      });
    }
    store = json['store'] != null ? StoreModel.fromJson(json['store']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['user_id'] = userId;
    data['store_id'] = storeId;
    data['driver_id'] = driverId;
    data['status'] = status;
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
    data['total_amount'] = totalAmount;
    data['delivery_fee'] = deliveryFee;
    data['discount_amount'] = discountAmount;
    data['final_amount'] = finalAmount;
    data['delivery_address'] = deliveryAddress;
    data['delivery_note'] = deliveryNote;
    data['delivery_time'] = deliveryTime;
    data['item_count'] = itemCount;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (store != null) {
      data['store'] = store!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class OrderItemModel {
  int? id;
  int? orderId;
  int? productId;
  int? quantity;
  double? price;
  double? totalPrice;
  String? note;
  List<OrderItemVariationModel>? variations;
  List<OrderItemToppingModel>? toppings;
  String? createdAt;
  String? updatedAt;

  OrderItemModel({
    this.id,
    this.orderId,
    this.productId,
    this.quantity,
    this.price,
    this.totalPrice,
    this.note,
    this.variations,
    this.toppings,
    this.createdAt,
    this.updatedAt,
  });

  OrderItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    price = json['price']?.toDouble();
    totalPrice = json['total_price']?.toDouble();
    note = json['note'];
    if (json['variations'] != null) {
      variations = <OrderItemVariationModel>[];
      json['variations'].forEach((v) {
        variations!.add(OrderItemVariationModel.fromJson(v));
      });
    }
    if (json['toppings'] != null) {
      toppings = <OrderItemToppingModel>[];
      json['toppings'].forEach((v) {
        toppings!.add(OrderItemToppingModel.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['quantity'] = quantity;
    data['price'] = price;
    data['total_price'] = totalPrice;
    data['note'] = note;
    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    if (toppings != null) {
      data['toppings'] = toppings!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class OrderItemVariationModel {
  int? id;
  int? orderItemId;
  int? variationId;
  String? name;
  double? price;
  String? createdAt;
  String? updatedAt;

  OrderItemVariationModel({
    this.id,
    this.orderItemId,
    this.variationId,
    this.name,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  OrderItemVariationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderItemId = json['order_item_id'];
    variationId = json['variation_id'];
    name = json['name'];
    price = json['price']?.toDouble();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_item_id'] = orderItemId;
    data['variation_id'] = variationId;
    data['name'] = name;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class OrderItemToppingModel {
  int? id;
  int? orderItemId;
  int? toppingId;
  String? name;
  double? price;
  String? createdAt;
  String? updatedAt;

  OrderItemToppingModel({
    this.id,
    this.orderItemId,
    this.toppingId,
    this.name,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  OrderItemToppingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderItemId = json['order_item_id'];
    toppingId = json['topping_id'];
    name = json['name'];
    price = json['price']?.toDouble();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_item_id'] = orderItemId;
    data['topping_id'] = toppingId;
    data['name'] = name;
    data['price'] = price;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
