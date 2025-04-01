import 'package:network_resources/store/models/menu.dart';
import 'package:network_resources/store/models/store.dart';

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
  List<VariationModel>? variations;
  List<MenuModel>? toppings;
  int? isFavorite;
  StoreModel? store;
  int? status;
  int? isOpen;
  List<OperatingHours>? operatingHours;
  String? createdAt;

  ProductModel({
    this.id,
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
    this.createdAt,
  });

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
      variations =
          (json["variations"] as List)
              .map((e) => VariationModel.fromJson(e))
              .toList();
    }
    if (json["toppings"] is List) {
      toppings =
          (json["toppings"] as List).map((e) => MenuModel.fromJson(e)).toList();
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
      operatingHours =
          json["operating_hours"] == null
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
      _data["variations"] = variations?.map((e) => e.toJson()).toList();
    }
    if (toppings != null) {
      _data["toppings"] = toppings?.map((e) => e.toJson()).toList();
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

class VariationModel {
  int? id;
  String? name;
  List<VariationValue>? values;
  int? isActive;
  int? arrange;
  String? createdAt;
  String? updatedAt;

  int? quantity;
  bool? isLocalImage;

  VariationModel({
    this.id,
    this.name,
    this.values,
    this.isActive,
    this.arrange,
    this.createdAt,
    this.updatedAt,
    this.quantity,
    this.isLocalImage,
  });

  VariationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['values'] != null) {
      values = <VariationValue>[];
      json['values'].forEach((v) {
        VariationValue variationValue = VariationValue.fromJson(v);
        variationValue.parentId = id;
        values!.add(variationValue);
      });
    }
    isActive = json['is_active'];
    arrange = json['arrange'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['name'] = name;
    if (values != null) {
      data['values'] = values!.map((v) => v.toJson()).toList();
    }
    data['is_active'] = isActive;
    data['arrange'] = arrange;
    data['quantity'] = quantity;
    return data;
  }

  // Hàm để chuyển đổi đối tượng thành FormData
  Map<String, dynamic> toFormData() {
    final Map<String, dynamic> data = toJson();
    return data;
  }
}

class VariationValue {
  int? id;
  String? value;
  double? price;
  int? isDefault;
  int? parentId;

  VariationModel? variation;

  VariationValue({
    this.id,
    this.value,
    this.price,
    this.parentId,
    this.isDefault,
    this.variation,
  });

  VariationValue.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    price = json['price']?.toDouble();
    parentId = json['parent_id'];
    isDefault = json['is_default'];
    variation = json['variation'] != null
        ? VariationModel.fromJson(json['variation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    data['price'] = price;
    data['parent_id'] = parentId;
    data['is_default'] = isDefault;
    if (variation != null) {
      data['variation'] = variation?.toJson();
    }
    return data;
  }
}
