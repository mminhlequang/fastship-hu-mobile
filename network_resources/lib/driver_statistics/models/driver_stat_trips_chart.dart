
class DriverStatTripsChart {
  List<_ChartData>? chartData;
  int? maxValue;
  int? totalTrips;
  double? averageTrips;
  double? completionRate;

  DriverStatTripsChart({this.chartData, this.maxValue, this.totalTrips, this.averageTrips, this.completionRate});

  DriverStatTripsChart.fromJson(Map<String, dynamic> json) {
    chartData = json["chartData"] == null ? null : (json["chartData"] as List).map((e) => _ChartData.fromJson(e)).toList();
    maxValue = json["maxValue"];
    totalTrips = json["totalTrips"];
    averageTrips = json["averageTrips"];
    completionRate = json["completionRate"];
  }

  static List<DriverStatTripsChart> fromList(List<Map<String, dynamic>> list) {
    return list.map(DriverStatTripsChart.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(chartData != null) {
      _data["chartData"] = chartData?.map((e) => e.toJson()).toList();
    }
    _data["maxValue"] = maxValue;
    _data["totalTrips"] = totalTrips;
    _data["averageTrips"] = averageTrips;
    _data["completionRate"] = completionRate;
    return _data;
  }
}

class _ChartData {
  String? label;
  String? date;
  int? value;
  int? completedTrips;
  int? cancelledTrips;

  _ChartData({this.label, this.date, this.value, this.completedTrips, this.cancelledTrips});

  _ChartData.fromJson(Map<String, dynamic> json) {
    label = json["label"];
    date = json["date"];
    value = json["value"];
    completedTrips = json["completedTrips"];
    cancelledTrips = json["cancelledTrips"];
  }

  static List<_ChartData> fromList(List<Map<String, dynamic>> list) {
    return list.map(_ChartData.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["label"] = label;
    _data["date"] = date;
    _data["value"] = value;
    _data["completedTrips"] = completedTrips;
    _data["cancelledTrips"] = cancelledTrips;
    return _data;
  }
}