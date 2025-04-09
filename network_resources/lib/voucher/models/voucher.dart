abstract class VoucherModelType {
  static const String percentage = 'percentage';
  static const String fixed = 'fixed';
}

class VoucherModel {
  int? id;
  String? code;
  String? name;
  String? image;
  num? cartValue;
  num? saleMaximum;
  String? description;
  String? content;
  num? value;
  dynamic productIds;
  String? startDate;
  String? expiryDate;
  String? type;
  int? active;
  int? isValid;
  String? createdAt;

  VoucherModel({this.id, this.code, this.name, this.image, this.cartValue, this.saleMaximum, this.description, this.content, this.value, this.productIds, this.startDate, this.expiryDate, this.type, this.active, this.isValid, this.createdAt});

  VoucherModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    code = json["code"];
    name = json["name"];
    image = json["image"];
    cartValue = json["cart_value"];
    saleMaximum = json["sale_maximum"];
    description = json["description"];
    content = json["content"];
    value = json["value"];
    productIds = json["product_ids"];
    startDate = json["start_date"];
    expiryDate = json["expiry_date"];
    type = json["type"];
    active = json["active"];
    isValid = json["is_valid"];
    createdAt = json["created_at"];
  }

  static List<VoucherModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(VoucherModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["code"] = code;
    _data["name"] = name;
    _data["image"] = image;
    _data["cart_value"] = cartValue;
    _data["sale_maximum"] = saleMaximum;
    _data["description"] = description;
    _data["content"] = content;
    _data["value"] = value;
    _data["product_ids"] = productIds;
    _data["start_date"] = startDate;
    _data["expiry_date"] = expiryDate;
    _data["type"] = type;
    _data["active"] = active;
    _data["is_valid"] = isValid;
    _data["created_at"] = createdAt;
    return _data;
  }
}