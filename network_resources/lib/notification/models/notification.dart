abstract class NotificationModelType {
  static const String system = 'system';
  static const String news = 'news';
  static const String promotion = 'promotion';
  static const String order = 'order';
  static const String transaction = 'transaction';
}

class NotificationModel {
  int? id;
  String? title;
  String? description;
  dynamic content;
  String? image;
  String? type;
  int? referenceId;
  int? isRead;
  String? createdAt;

  NotificationModel({this.id, this.title, this.description, this.content, this.image, this.type, this.referenceId, this.isRead, this.createdAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    description = json["description"];
    content = json["content"];
    image = json["image"];
    type = json["type"];
    referenceId = json["reference_id"];
    isRead = json["is_read"];
    createdAt = json["created_at"];
  }

  static List<NotificationModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(NotificationModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["title"] = title;
    _data["description"] = description;
    _data["content"] = content;
    _data["image"] = image;
    _data["type"] = type;
    _data["reference_id"] = referenceId;
    _data["is_read"] = isRead;
    _data["created_at"] = createdAt;
    return _data;
  }
}