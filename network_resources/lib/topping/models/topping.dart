import 'package:equatable/equatable.dart';

class ToppingModel extends Equatable {
  int? id;
  String? name;
  String? image;
  double? price;
  int? status;
  int? storeId;
  int? arrange;
  String? createdAt;
  String? updatedAt;

  int? quantity;
  bool? isLocalImage;

  ToppingModel({
    this.id,
        this.name,
    this.image,
    this.price,
    this.status,
    this.storeId,
    this.arrange,
    this.createdAt,
    this.updatedAt,
    this.quantity,
    this.isLocalImage,
  });

  ToppingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price']?.toDouble();
    status = json['status'];
    storeId = json['store_id'];
    arrange = json['arrange'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['status'] = status;
    data['store_id'] = storeId;
    data['arrange'] = arrange;
    data['quantity'] = quantity;
    return data;
  }

  // Hàm để chuyển đổi đối tượng thành FormData
  Map<String, dynamic> toFormData() {
    final Map<String, dynamic> data = toJson();
    return data;
  }

  @override
  List<Object?> get props => [id, name, image, price];
}
