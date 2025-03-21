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

class ToppingModel {
  int? id;
  int? quantity;
  String? name;
  double? price;

  ToppingModel({
    this.id,
    this.quantity,
    this.name,
    this.price,
  });

  ToppingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    name = json['name'];
    price = json['price']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = quantity;
    return data;
  }
}

class ProductModel {
  int? id;
  String? name;
  String? description;
  String? image;
  double? price;
  double? pricePromotion;
  int? isPromotion;
  int? isPopular;
  int? status;
  String? createdAt;
  String? updatedAt;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.price,
    this.pricePromotion,
    this.isPromotion,
    this.isPopular,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    price = json['price']?.toDouble();
    pricePromotion = json['price_promotion']?.toDouble();
    isPromotion = json['is_promotion'];
    isPopular = json['is_popular'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['price'] = price;
    data['price_promotion'] = pricePromotion;
    data['is_promotion'] = isPromotion;
    data['is_popular'] = isPopular;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class StoreModel {
  int? id;
  String? name;
  String? image;
  String? address;

  StoreModel({
    this.id,
    this.name,
    this.image,
    this.address,
  });

  StoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['address'] = address;
    return data;
  }
}
