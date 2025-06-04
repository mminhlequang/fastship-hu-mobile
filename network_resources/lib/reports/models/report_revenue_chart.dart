class ReportRevenueChartModel {
  List<RevenueValue>? dailyRevenue;
  List<RevenueValue>? weeklyRevenue;
  List<RevenueValue>? monthlyRevenue;

  ReportRevenueChartModel({
    this.dailyRevenue,
    this.weeklyRevenue,
    this.monthlyRevenue,
  });

  ReportRevenueChartModel.fromJson(Map<String, dynamic> json) {
    if (json["daily_revenue"] is List) {
      dailyRevenue =
          json["daily_revenue"] == null
              ? null
              : (json["daily_revenue"] as List)
                  .map((e) => RevenueValue.fromJson(e))
                  .toList();
    }
    if (json["weekly_revenue"] is List) {
      weeklyRevenue =
          json["weekly_revenue"] == null
              ? null
              : (json["weekly_revenue"] as List)
                  .map((e) => RevenueValue.fromJson(e))
                  .toList();
    }
    if (json["monthly_revenue"] is List) {
      monthlyRevenue =
          json["monthly_revenue"] == null
              ? null
              : (json["monthly_revenue"] as List)
                  .map((e) => RevenueValue.fromJson(e))
                  .toList();
    }
  }

  static List<ReportRevenueChartModel> fromList(
    List<Map<String, dynamic>> list,
  ) {
    return list.map(ReportRevenueChartModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (dailyRevenue != null) {
      _data["daily_revenue"] = dailyRevenue?.map((e) => e.toJson()).toList();
    }
    if (weeklyRevenue != null) {
      _data["weekly_revenue"] = weeklyRevenue?.map((e) => e.toJson()).toList();
    }
    if (monthlyRevenue != null) {
      _data["monthly_revenue"] =
          monthlyRevenue?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class RevenueValue {
  String? period;
  num? value;
  String? date;

  RevenueValue({this.period, this.value, this.date});

  RevenueValue.fromJson(Map<String, dynamic> json) {
    if (json["period"] is String) {
      period = json["period"];
    }
    if (json["value"] is num) {
      value = json["value"];
    }
    if (json["date"] is String) {
      date = json["date"];
    }
  }

  static List<RevenueValue> fromList(List<Map<String, dynamic>> list) {
    return list.map(RevenueValue.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["period"] = period;
    _data["value"] = value;
    _data["date"] = date;
    return _data;
  }
}
