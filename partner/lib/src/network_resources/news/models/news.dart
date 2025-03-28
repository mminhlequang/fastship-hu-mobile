class NewsModel {
  int? id;
  String? title;
  String? content;
  String? image;
  String? description;
  String? createdAt;
  String? updatedAt;

  NewsModel({
    this.id,
    this.title,
    this.content,
    this.image,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  NewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    image = json['image'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (title != null) data['title'] = title;
    if (content != null) data['content'] = content;
    if (image != null) data['image'] = image;
    if (description != null) data['description'] = description;
    if (createdAt != null) data['created_at'] = createdAt;
    if (updatedAt != null) data['updated_at'] = updatedAt;
    return data;
  }
}
