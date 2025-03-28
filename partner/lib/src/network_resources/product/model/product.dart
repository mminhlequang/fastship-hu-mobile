import 'package:app/src/network_resources/store/models/store.dart';

class ProductModel {
  int? id;
  String? name;
  String? image;
  num? price;
  num? priceCompare;
  String? description;
  String? content;
  int? quantity;
  num? rating;
  List<dynamic>? variations;
  List<dynamic>? toppings;
  int? isFavorite;
  StoreModel? store;
  int? status;
  int? isOpen;
  List<OperatingHours>? operatingHours;
  String? createdAt;

  ProductModel(
      {this.id,
      this.name,
      this.image,
      this.price,
      this.priceCompare,
      this.description,
      this.content,
      this.quantity,
      this.rating,
      this.variations,
      this.toppings,
      this.isFavorite,
      this.store,
      this.status,
      this.isOpen,
      this.operatingHours,
      this.createdAt});

  ProductModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["image"] is String) {
      image = json["image"];
    }
    if (json["price"] is num) {
      price = json["price"];
    }
    if (json["price_compare"] is num) {
      priceCompare = json["price_compare"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["content"] is String) {
      content = json["content"];
    }
    if (json["quantity"] is int) {
      quantity = json["quantity"];
    }
    if (json["rating"] is num) {
      rating = json["rating"];
    }
    if (json["variations"] is List) {
      variations = json["variations"] ?? [];
    }
    if (json["toppings"] is List) {
      toppings = json["toppings"] ?? [];
    }
    if (json["is_favorite"] is int) {
      isFavorite = json["is_favorite"];
    }
    if (json["store"] is Map) {
      store = json["store"] == null ? null : StoreModel.fromJson(json["store"]);
    }
    if (json["status"] is int) {
      status = json["status"];
    }
    if (json["is_open"] is int) {
      isOpen = json["is_open"];
    }
    if (json["operating_hours"] is List) {
      operatingHours = json["operating_hours"] == null
          ? null
          : (json["operating_hours"] as List)
              .map((e) => OperatingHours.fromJson(e))
              .toList();
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<ProductModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(ProductModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["image"] = image;
    _data["price"] = price;
    _data["price_compare"] = priceCompare;
    _data["description"] = description;
    _data["content"] = content;
    _data["quantity"] = quantity;
    _data["rating"] = rating;
    if (variations != null) {
      _data["variations"] = variations;
    }
    if (toppings != null) {
      _data["toppings"] = toppings;
    }
    _data["is_favorite"] = isFavorite;
    if (store != null) {
      _data["store"] = store?.toJson();
    }
    _data["status"] = status;
    _data["is_open"] = isOpen;
    if (operatingHours != null) {
      _data["operating_hours"] =
          operatingHours?.map((e) => e.toJson()).toList();
    }
    _data["created_at"] = createdAt;
    return _data;
  }
}
