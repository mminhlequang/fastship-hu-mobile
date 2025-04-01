import 'models.dart';

class GroupToppingModel {
  int? id;
  String? nameVi;
  String? nameEn;
  String? nameZh;
  String? nameHu;
  String? toppingIds;
  String? productIds;
  String? variationIds;
  int? storeId;
  int? maxQuantity;
  List<ToppingModel>? toppings;
  String? createdAt;
  String? updatedAt;

  GroupToppingModel({
    this.id,
    this.nameVi,
    this.nameEn,
    this.nameZh,
    this.nameHu,
    this.toppingIds,
    this.productIds,
    this.variationIds,
    this.storeId,
    this.maxQuantity,
    this.toppings,
    this.createdAt,
    this.updatedAt,
  });

  GroupToppingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameVi = json['name_vi'];
    nameEn = json['name_en'];
    nameZh = json['name_zh'];
    nameHu = json['name_hu'];
    toppingIds = json['topping_ids'];
    productIds = json['product_ids'];
    variationIds = json['variation_ids'];
    storeId = json['store_id'];
    maxQuantity = json['max_quantity'];
    if (json['toppings'] != null) {
      toppings = <ToppingModel>[];
      json['toppings'].forEach((v) {
        toppings!.add(ToppingModel.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['name_vi'] = nameVi;
    data['name_en'] = nameEn;
    data['name_zh'] = nameZh;
    data['name_hu'] = nameHu;
    data['topping_ids'] = toppingIds;
    data['product_ids'] = productIds;
    data['variation_ids'] = variationIds;
    data['store_id'] = storeId;
    data['max_quantity'] = maxQuantity;
    return data;
  }
}

 