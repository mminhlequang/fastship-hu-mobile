import 'package:network_resources/product/model/product.dart';
import 'package:network_resources/store/models/models.dart';
import 'package:network_resources/topping/models/models.dart';

class CartModel {
  int? id;
  StoreModel? store;
  List<CartItemModel>? cartItems;

  CartModel({this.id, this.store, this.cartItems});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    store = json["store"] == null ? null : StoreModel.fromJson(json["store"]);
    cartItems =
        json["cart_items"] == null
            ? null
            : (json["cart_items"] as List)
                .map((e) => CartItemModel.fromJson(e))
                .toList();
  }

  static List<CartModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(CartModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if (store != null) {
      _data["store"] = store?.toJson();
    }
    if (cartItems != null) {
      _data["cart_items"] = cartItems?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class CartItemModel {
  int? id;
  ProductModel? product;
  List<VariationValue>? variations;
  List<ToppingModel>? toppings;
  int? quantity;
  num? price;

  CartItemModel({
    this.id,
    this.product,
    this.variations,
    this.toppings,
    this.quantity,
    this.price,
  });

  CartItemModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    product =
        json["product"] == null ? null : ProductModel.fromJson(json["product"]);
    variations =
        json["variations"] == null
            ? null
            : (json["variations"] as List)
                .map((e) => VariationValue.fromJson(e))
                .toList();
    toppings =
        json["toppings"] == null
            ? null
            : (json["toppings"] as List)
                .map((e) => ToppingModel.fromJson(e))
                .toList();
    quantity = json["quantity"];
    price = json["price"];
  }

  static List<CartItemModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(CartItemModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if (product != null) {
      _data["product"] = product?.toJson();
    }
    if (variations != null) {
      _data["variations"] = variations?.map((e) => e.toJson()).toList();
    }
    if (toppings != null) {
      _data["toppings"] = toppings?.map((e) => e.toJson()).toList();
    }
    _data["quantity"] = quantity;
    _data["price"] = price;
    return _data;
  }
}
