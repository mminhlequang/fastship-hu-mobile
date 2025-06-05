
class DriverStatIncomeChart {
  List<ChartData>? chartData;
  int? maxValue;
  int? totalIncome;
  double? averageIncome;

  DriverStatIncomeChart({this.chartData, this.maxValue, this.totalIncome, this.averageIncome});

  DriverStatIncomeChart.fromJson(Map<String, dynamic> json) {
    chartData = json["chartData"] == null ? null : (json["chartData"] as List).map((e) => ChartData.fromJson(e)).toList();
    maxValue = json["maxValue"];
    totalIncome = json["totalIncome"];
    averageIncome = json["averageIncome"];
  }

  static List<DriverStatIncomeChart> fromList(List<Map<String, dynamic>> list) {
    return list.map(DriverStatIncomeChart.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(chartData != null) {
      _data["chartData"] = chartData?.map((e) => e.toJson()).toList();
    }
    _data["maxValue"] = maxValue;
    _data["totalIncome"] = totalIncome;
    _data["averageIncome"] = averageIncome;
    return _data;
  }
}

class ChartData {
  String? label;
  String? date;
  int? value;
  String? currency;

  ChartData({this.label, this.date, this.value, this.currency});

  ChartData.fromJson(Map<String, dynamic> json) {
    label = json["label"];
    date = json["date"];
    value = json["value"];
    currency = json["currency"];
  }

  static List<ChartData> fromList(List<Map<String, dynamic>> list) {
    return list.map(ChartData.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["label"] = label;
    _data["date"] = date;
    _data["value"] = value;
    _data["currency"] = currency;
    return _data;
  }
}