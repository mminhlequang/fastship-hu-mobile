
class DriverStatDetail {
  List<IncomeDetails>? incomeDetails;
  Summary? summary;

  DriverStatDetail({this.incomeDetails, this.summary});

  DriverStatDetail.fromJson(Map<String, dynamic> json) {
    incomeDetails = json["incomeDetails"] == null ? null : (json["incomeDetails"] as List).map((e) => IncomeDetails.fromJson(e)).toList();
    summary = json["summary"] == null ? null : Summary.fromJson(json["summary"]);
  }

  static List<DriverStatDetail> fromList(List<Map<String, dynamic>> list) {
    return list.map(DriverStatDetail.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(incomeDetails != null) {
      _data["incomeDetails"] = incomeDetails?.map((e) => e.toJson()).toList();
    }
    if(summary != null) {
      _data["summary"] = summary?.toJson();
    }
    return _data;
  }
}

class Summary {
  double? totalGross;
  int? totalDeductions;
  double? totalNet;
  double? profitMargin;

  Summary({this.totalGross, this.totalDeductions, this.totalNet, this.profitMargin});

  Summary.fromJson(Map<String, dynamic> json) {
    totalGross = json["totalGross"];
    totalDeductions = json["totalDeductions"];
    totalNet = json["totalNet"];
    profitMargin = json["profitMargin"];
  }

  static List<Summary> fromList(List<Map<String, dynamic>> list) {
    return list.map(Summary.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["totalGross"] = totalGross;
    _data["totalDeductions"] = totalDeductions;
    _data["totalNet"] = totalNet;
    _data["profitMargin"] = profitMargin;
    return _data;
  }
}

class IncomeDetails {
  String? type;
  String? label;
  double? amount;
  String? currency;
  bool? isPositive;
  bool? isTotal;
  String? description;

  IncomeDetails({this.type, this.label, this.amount, this.currency, this.isPositive, this.isTotal, this.description});

  IncomeDetails.fromJson(Map<String, dynamic> json) {
    type = json["type"];
    label = json["label"];
    amount = json["amount"];
    currency = json["currency"];
    isPositive = json["isPositive"];
    isTotal = json["isTotal"];
    description = json["description"];
  }

  static List<IncomeDetails> fromList(List<Map<String, dynamic>> list) {
    return list.map(IncomeDetails.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["type"] = type;
    _data["label"] = label;
    _data["amount"] = amount;
    _data["currency"] = currency;
    _data["isPositive"] = isPositive;
    _data["isTotal"] = isTotal;
    _data["description"] = description;
    return _data;
  }
}