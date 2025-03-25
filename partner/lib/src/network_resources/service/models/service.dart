class ServiceModel {
  int? id;
  String? iconUrl;
  String? name;
  String? description;
  int? isStoreRegister;
  int? isActive;
  List<ServiceAdditional>? additionals;

  ServiceModel(
      {this.id,
      this.iconUrl,
      this.name,
      this.description,
      this.isStoreRegister,
      this.isActive,
      this.additionals});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["icon_url"] is String) {
      iconUrl = json["icon_url"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["is_store_register"] is int) {
      isStoreRegister = json["is_store_register"];
    }
    if (json["is_active"] is int) {
      isActive = json["is_active"];
    }
    if (json["additionals"] is List) {
      additionals = json["additionals"] == null
          ? null
          : (json["additionals"] as List)
              .map((e) => ServiceAdditional.fromJson(e))
              .toList();
    }
  }

  static List<ServiceModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(ServiceModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["icon_url"] = iconUrl;
    _data["name"] = name;
    _data["description"] = description;
    _data["is_store_register"] = isStoreRegister;
    _data["is_active"] = isActive;
    if (additionals != null) {
      _data["additionals"] = additionals?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class ServiceAdditional {
  int? id;
  String? name;
  String? description;
  int? isStoreRegister;
  int? isActive;

  ServiceAdditional(
      {this.id,
      this.name,
      this.description,
      this.isStoreRegister,
      this.isActive});

  ServiceAdditional.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["is_store_register"] is int) {
      isStoreRegister = json["is_store_register"];
    }
    if (json["is_active"] is int) {
      isActive = json["is_active"];
    }
  }

  static List<ServiceAdditional> fromList(List<Map<String, dynamic>> list) {
    return list.map(ServiceAdditional.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["description"] = description;
    _data["is_store_register"] = isStoreRegister;
    _data["is_active"] = isActive;
    return _data;
  }
}
