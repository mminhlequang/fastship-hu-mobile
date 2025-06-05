
class DriverStatIncomeBreakdown {
  double? grossIncome;
  List<Breakdown>? breakdown;
  double? netIncomePercentage;
  int? totalDeductions;

  DriverStatIncomeBreakdown({this.grossIncome, this.breakdown, this.netIncomePercentage, this.totalDeductions});

  DriverStatIncomeBreakdown.fromJson(Map<String, dynamic> json) {
    grossIncome = json["grossIncome"];
    breakdown = json["breakdown"] == null ? null : (json["breakdown"] as List).map((e) => Breakdown.fromJson(e)).toList();
    netIncomePercentage = json["netIncomePercentage"];
    totalDeductions = json["totalDeductions"];
  }

  static List<DriverStatIncomeBreakdown> fromList(List<Map<String, dynamic>> list) {
    return list.map(DriverStatIncomeBreakdown.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["grossIncome"] = grossIncome;
    if(breakdown != null) {
      _data["breakdown"] = breakdown?.map((e) => e.toJson()).toList();
    }
    _data["netIncomePercentage"] = netIncomePercentage;
    _data["totalDeductions"] = totalDeductions;
    return _data;
  }
}

class Breakdown {
  String? type;
  String? label;
  double? amount;
  double? percentage;
  String? color;
  bool? isPositive;

  Breakdown({this.type, this.label, this.amount, this.percentage, this.color, this.isPositive});

  Breakdown.fromJson(Map<String, dynamic> json) {
    type = json["type"];
    label = json["label"];
    amount = json["amount"];
    percentage = json["percentage"];
    color = json["color"];
    isPositive = json["isPositive"];
  }

  static List<Breakdown> fromList(List<Map<String, dynamic>> list) {
    return list.map(Breakdown.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["type"] = type;
    _data["label"] = label;
    _data["amount"] = amount;
    _data["percentage"] = percentage;
    _data["color"] = color;
    _data["isPositive"] = isPositive;
    return _data;
  }
}