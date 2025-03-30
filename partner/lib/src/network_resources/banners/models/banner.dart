class BannerModel {
  int? id;
  String? title;
  String? image;
  String? link;
  String? createdAt;
  String? updatedAt;

  BannerModel({
    this.id,
    this.title,
    this.image,
    this.link,
    this.createdAt,
    this.updatedAt,
  });

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    link = json['link'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (title != null) data['title'] = title;
    if (image != null) data['image'] = image;
    if (link != null) data['link'] = link;
    if (createdAt != null) data['created_at'] = createdAt;
    if (updatedAt != null) data['updated_at'] = updatedAt;
    return data;
  }
}
