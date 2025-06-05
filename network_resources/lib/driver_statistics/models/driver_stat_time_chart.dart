
class DriverStatTimeChart {
  List<_ChartData>? chartData;
  int? maxValue;
  double? totalOnlineHours;
  double? averageOnlineHours;
  double? efficiency;

  DriverStatTimeChart({this.chartData, this.maxValue, this.totalOnlineHours, this.averageOnlineHours, this.efficiency});

  DriverStatTimeChart.fromJson(Map<String, dynamic> json) {
    chartData = json["chartData"] == null ? null : (json["chartData"] as List).map((e) => _ChartData.fromJson(e)).toList();
    maxValue = json["maxValue"];
    totalOnlineHours = json["totalOnlineHours"];
    averageOnlineHours = json["averageOnlineHours"];
    efficiency = json["efficiency"];
  }

  static List<DriverStatTimeChart> fromList(List<Map<String, dynamic>> list) {
    return list.map(DriverStatTimeChart.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(chartData != null) {
      _data["chartData"] = chartData?.map((e) => e.toJson()).toList();
    }
    _data["maxValue"] = maxValue;
    _data["totalOnlineHours"] = totalOnlineHours;
    _data["averageOnlineHours"] = averageOnlineHours;
    _data["efficiency"] = efficiency;
    return _data;
  }
}

class _ChartData {
  String? label;
  String? date;
  double? value;
  int? onlineMinutes;
  int? activeMinutes;
  int? idleMinutes;

  _ChartData({this.label, this.date, this.value, this.onlineMinutes, this.activeMinutes, this.idleMinutes});

  _ChartData.fromJson(Map<String, dynamic> json) {
    label = json["label"];
    date = json["date"];
    value = json["value"];
    onlineMinutes = json["onlineMinutes"];
    activeMinutes = json["activeMinutes"];
    idleMinutes = json["idleMinutes"];
  }

  static List<_ChartData> fromList(List<Map<String, dynamic>> list) {
    return list.map(_ChartData.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["label"] = label;
    _data["date"] = date;
    _data["value"] = value;
    _data["onlineMinutes"] = onlineMinutes;
    _data["activeMinutes"] = activeMinutes;
    _data["idleMinutes"] = idleMinutes;
    return _data;
  }
}