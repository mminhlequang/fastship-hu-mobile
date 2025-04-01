class BannerModel {
  int? id;
  String? name;
  String? image;
  String? type;
  int? referenceId;
  String? externalLink;

  BannerModel({
    this.id,
    this.name,
    this.image,
    this.type,
    this.referenceId,
    this.externalLink,
  });

  BannerModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["image"] is String) {
      image = json["image"];
    }
    if (json["type"] is String) {
      type = json["type"];
    }
    if (json["reference_id"] is int) {
      referenceId = json["reference_id"];
    }
    if (json["external_link"] is String) {
      externalLink = json["external_link"];
    }
  }

  static List<BannerModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(BannerModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["image"] = image;
    _data["type"] = type;
    _data["reference_id"] = referenceId;
    _data["external_link"] = externalLink;
    return _data;
  }
}
