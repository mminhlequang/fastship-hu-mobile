
class CategoryModel {
  int? id;
  String? name;
  String? image;
  String? description;
  List<CategoryModel>? children;  
  int? totalStores;

  CategoryModel({this.id, this.name, this.image, this.description, this.children,   this.totalStores});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["image"] is String) {
      image = json["image"];
    }
    if(json["description"] is String) {
      description = json["description"];
    }
    if(json["children"] is List) {
      children = json["children"] == null ? null : (json["children"] as List).map((e) => CategoryModel.fromJson(e)).toList();
    }
    
    if(json["total_stores"] is int) {
      totalStores = json["total_stores"];
    }
  }

  static List<CategoryModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(CategoryModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["image"] = image;
    _data["description"] = description;
    if(children != null) {
      _data["children"] = children?.map((e) => e.toJson()).toList();
    }
    
    _data["total_stores"] = totalStores;
    return _data;
  }
}
 