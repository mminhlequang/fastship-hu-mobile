
class ReportTopSellingItemModel {
  String? itemId;
  String? name;
  String? image;
  int? quantity;
  int? revenue;
  int? rank;

  ReportTopSellingItemModel({this.itemId, this.name, this.image, this.quantity, this.revenue, this.rank});

  ReportTopSellingItemModel.fromJson(Map<String, dynamic> json) {
    if(json["item_id"] is String) {
      itemId = json["item_id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["image"] is String) {
      image = json["image"];
    }
    if(json["quantity"] is int) {
      quantity = json["quantity"];
    }
    if(json["revenue"] is int) {
      revenue = json["revenue"];
    }
    if(json["rank"] is int) {
      rank = json["rank"];
    }
  }

  static List<ReportTopSellingItemModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(ReportTopSellingItemModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["item_id"] = itemId;
    _data["name"] = name;
    _data["image"] = image;
    _data["quantity"] = quantity;
    _data["revenue"] = revenue;
    _data["rank"] = rank;
    return _data;
  }
}