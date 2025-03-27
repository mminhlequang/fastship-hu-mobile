import 'package:app/src/network_resources/store/models/models.dart';
import 'package:app/src/network_resources/topping/models/models.dart';

class CartModel {
  int? id;
  int? userId;
  int? storeId;
  int? productId;
  int? quantity;
  List<VariationModel>? variations;
  List<ToppingModel>? toppings;
  ProductModel? product;
  StoreModel? store;
  String? createdAt;
  String? updatedAt;

  CartModel({
    this.id,
    this.userId,
    this.storeId,
    this.productId,
    this.quantity,
    this.variations,
    this.toppings,
    this.product,
    this.store,
    this.createdAt,
    this.updatedAt,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    storeId = json['store_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    if (json['variations'] != null) {
      variations = <VariationModel>[];
      json['variations'].forEach((v) {
        variations!.add(VariationModel.fromJson(v));
      });
    }
    if (json['toppings'] != null) {
      toppings = <ToppingModel>[];
      json['toppings'].forEach((v) {
        toppings!.add(ToppingModel.fromJson(v));
      });
    }
    product =
        json['product'] != null ? ProductModel.fromJson(json['product']) : null;
    store = json['store'] != null ? StoreModel.fromJson(json['store']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['store_id'] = storeId;
    data['product_id'] = productId;
    data['quantity'] = quantity;
    if (variations != null) {
      data['variations'] = variations!.map((v) => v.toJson()).toList();
    }
    if (toppings != null) {
      data['topping_ids'] = toppings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VariationModel {
  int? variationValue;

  VariationModel({this.variationValue});

  VariationModel.fromJson(Map<String, dynamic> json) {
    variationValue = json['variation_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variation_value'] = variationValue;
    return data;
  }
}
 
  