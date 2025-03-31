import 'package:app/src/network_resources/store/models/models.dart';

class VoucherModel {
  int? id;
  String? code;
  String? name;
  String? image;
  double? cartValue;
  double? saleMaximum;
  String? description;
  String? productIds;
  int? value;
  String? startDate;
  String? expiryDate;
  String? type;
  int? storeId;
  bool? isSaved;
  StoreModel? store;
  String? createdAt;
  String? updatedAt;

  VoucherModel({
    this.id,
    this.code,
    this.name,
    this.image,
    this.cartValue,
    this.saleMaximum,
    this.description,
    this.productIds,
    this.value,
    this.startDate,
    this.expiryDate,
    this.type,
    this.storeId,
    this.isSaved,
    this.store,
    this.createdAt,
    this.updatedAt,
  });

  VoucherModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    image = json['image'];
    cartValue = json['cart_value']?.toDouble();
    saleMaximum = json['sale_maximum']?.toDouble();
    description = json['description'];
    productIds = json['product_ids'];
    value = json['value'];
    startDate = json['start_date'];
    expiryDate = json['expiry_date'];
    type = json['type'];
    storeId = json['store_id'];
    isSaved = json['is_saved'];
    store = json['store'] != null ? StoreModel.fromJson(json['store']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['image'] = image;
    data['cart_value'] = cartValue;
    data['sale_maximum'] = saleMaximum;
    data['description'] = description;
    data['product_ids'] = productIds;
    data['value'] = value;
    data['start_date'] = startDate;
    data['expiry_date'] = expiryDate;
    data['type'] = type;
    data['store_id'] = storeId;
    return data;
  }
}

 