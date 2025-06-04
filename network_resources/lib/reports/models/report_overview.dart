
class ReportOverviewModel {
  int? todayRevenue;
  int? yesterdayRevenue;
  int? todayOrders;
  int? yesterdayOrders;
  int? totalCustomers;
  int? avgOrderValue;
  double? growthRate;

  ReportOverviewModel({this.todayRevenue, this.yesterdayRevenue, this.todayOrders, this.yesterdayOrders, this.totalCustomers, this.avgOrderValue, this.growthRate});

  ReportOverviewModel.fromJson(Map<String, dynamic> json) {
    if(json["today_revenue"] is int) {
      todayRevenue = json["today_revenue"];
    }
    if(json["yesterday_revenue"] is int) {
      yesterdayRevenue = json["yesterday_revenue"];
    }
    if(json["today_orders"] is int) {
      todayOrders = json["today_orders"];
    }
    if(json["yesterday_orders"] is int) {
      yesterdayOrders = json["yesterday_orders"];
    }
    if(json["total_customers"] is int) {
      totalCustomers = json["total_customers"];
    }
    if(json["avg_order_value"] is int) {
      avgOrderValue = json["avg_order_value"];
    }
    if(json["growth_rate"] is double) {
      growthRate = json["growth_rate"];
    }
  }

  static List<ReportOverviewModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(ReportOverviewModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["today_revenue"] = todayRevenue;
    _data["yesterday_revenue"] = yesterdayRevenue;
    _data["today_orders"] = todayOrders;
    _data["yesterday_orders"] = yesterdayOrders;
    _data["total_customers"] = totalCustomers;
    _data["avg_order_value"] = avgOrderValue;
    _data["growth_rate"] = growthRate;
    return _data;
  }
}