class ToppingModel {
  int? id;
  String? nameVi;
  String? nameEn;
  String? nameZh;
  String? nameHu;
  String? image;
  double? price;
  int? status;
  int? storeId;
  int? arrange;
  String? createdAt;
  String? updatedAt;

  ToppingModel({
    this.id,
    this.nameVi,
    this.nameEn,
    this.nameZh,
    this.nameHu,
    this.image,
    this.price,
    this.status,
    this.storeId,
    this.arrange,
    this.createdAt,
    this.updatedAt,
  });

  ToppingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameVi = json['name_vi'];
    nameEn = json['name_en'];
    nameZh = json['name_zh'];
    nameHu = json['name_hu'];
    image = json['image'];
    price = json['price']?.toDouble();
    status = json['status'];
    storeId = json['store_id'];
    arrange = json['arrange'];
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
    data['price'] = price;
    data['status'] = status;
    data['store_id'] = storeId;
    data['arrange'] = arrange;
    return data;
  }

  // Hàm để chuyển đổi đối tượng thành FormData
  Map<String, dynamic> toFormData() {
    final Map<String, dynamic> data = toJson();
    return data;
  }
}
