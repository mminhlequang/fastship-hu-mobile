class ApproveModel {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  ApproveModel({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  ApproveModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (name != null) data['name'] = name;
    if (createdAt != null) data['created_at'] = createdAt;
    if (updatedAt != null) data['updated_at'] = updatedAt;
    return data;
  }
}
