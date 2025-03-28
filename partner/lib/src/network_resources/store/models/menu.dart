import 'package:app/src/network_resources/product/model/product.dart';
import 'package:app/src/network_resources/topping/models/models.dart';

class MenuModel {
  int? id;
  int? storeId;
  String? name;
  String? image;
  int? type;
  int? isFeature;
  List<ProductModel>? products;
  List<ToppingModel>? toppings;
  String? createdAt;
  String? updatedAt;

  MenuModel({
    this.id,
    this.storeId,
    this.name,
    this.image,
    this.type,
    this.isFeature,
    this.products,
    this.toppings,
    this.createdAt,
    this.updatedAt,
  });

  MenuModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    name = json['name'];
    image = json['image'];
    type = json['type'];
    isFeature = json['is_feature'];
    if (json['items'] != null) {
      products = <ProductModel>[];
      json['items'].forEach((v) {
        products!.add(ProductModel.fromJson(v));
      });
    }
    if (json['items'] != null) {
      toppings = <ToppingModel>[];
      json['items'].forEach((v) {
        toppings!.add(ToppingModel.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['store_id'] = storeId;
    data['name'] = name;
    data['image'] = image;
    data['type'] = type;
    data['is_feature'] = isFeature;
    if (products != null) {
      data['items'] = products!.map((v) => v.toJson()).toList();
    }
    if (toppings != null) {
      data['items'] = toppings!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
 