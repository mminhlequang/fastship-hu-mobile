class NewsModel {
  int? id;
  String? name;
  String? image;
  String? description;
  String? content;
  String? category;
  String? createdAt;
  String? link;

  NewsModel({
    this.id,
    this.name,
    this.image,
    this.description,
    this.content,
    this.category,
    this.createdAt,
    this.link,
  });

  NewsModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["image"] is String) {
      image = json["image"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["content"] is String) {
      content = json["content"];
    }
    if (json["category"] is String) {
      category = json["category"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    if (json["link"] is String) {
      link = json["link"];
    }
  }

  static List<NewsModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(NewsModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["image"] = image;
    _data["description"] = description;
    _data["content"] = content;
    _data["category"] = category;
    _data["created_at"] = createdAt;
    _data["link"] = link;
    return _data;
  }
}
