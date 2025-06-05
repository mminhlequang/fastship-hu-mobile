
class DriverStatisticOverviewModel {
  NetIncome? netIncome;
  GrossIncome? grossIncome;
  Stats? stats;
  Period? period;

  DriverStatisticOverviewModel({this.netIncome, this.grossIncome, this.stats, this.period});

  DriverStatisticOverviewModel.fromJson(Map<String, dynamic> json) {
    netIncome = json["netIncome"] == null ? null : NetIncome.fromJson(json["netIncome"]);
    grossIncome = json["grossIncome"] == null ? null : GrossIncome.fromJson(json["grossIncome"]);
    stats = json["stats"] == null ? null : Stats.fromJson(json["stats"]);
    period = json["period"] == null ? null : Period.fromJson(json["period"]);
  }

  static List<DriverStatisticOverviewModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(DriverStatisticOverviewModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(netIncome != null) {
      _data["netIncome"] = netIncome?.toJson();
    }
    if(grossIncome != null) {
      _data["grossIncome"] = grossIncome?.toJson();
    }
    if(stats != null) {
      _data["stats"] = stats?.toJson();
    }
    if(period != null) {
      _data["period"] = period?.toJson();
    }
    return _data;
  }
}

class Period {
  String? type;
  String? startDate;
  String? endDate;
  String? displayName;

  Period({this.type, this.startDate, this.endDate, this.displayName});

  Period.fromJson(Map<String, dynamic> json) {
    type = json["type"];
    startDate = json["startDate"];
    endDate = json["endDate"];
    displayName = json["displayName"];
  }

  static List<Period> fromList(List<Map<String, dynamic>> list) {
    return list.map(Period.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["type"] = type;
    _data["startDate"] = startDate;
    _data["endDate"] = endDate;
    _data["displayName"] = displayName;
    return _data;
  }
}

class Stats {
  TotalTrips? totalTrips;
  OnlineHours? onlineHours;
  AverageRating? averageRating;

  Stats({this.totalTrips, this.onlineHours, this.averageRating});

  Stats.fromJson(Map<String, dynamic> json) {
    totalTrips = json["totalTrips"] == null ? null : TotalTrips.fromJson(json["totalTrips"]);
    onlineHours = json["onlineHours"] == null ? null : OnlineHours.fromJson(json["onlineHours"]);
    averageRating = json["averageRating"] == null ? null : AverageRating.fromJson(json["averageRating"]);
  }

  static List<Stats> fromList(List<Map<String, dynamic>> list) {
    return list.map(Stats.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(totalTrips != null) {
      _data["totalTrips"] = totalTrips?.toJson();
    }
    if(onlineHours != null) {
      _data["onlineHours"] = onlineHours?.toJson();
    }
    if(averageRating != null) {
      _data["averageRating"] = averageRating?.toJson();
    }
    return _data;
  }
}

class AverageRating {
  double? rating;
  int? totalRatings;
  double? changePercentage;
  String? changeDirection;

  AverageRating({this.rating, this.totalRatings, this.changePercentage, this.changeDirection});

  AverageRating.fromJson(Map<String, dynamic> json) {
    rating = json["rating"];
    totalRatings = json["totalRatings"];
    changePercentage = json["changePercentage"];
    changeDirection = json["changeDirection"];
  }

  static List<AverageRating> fromList(List<Map<String, dynamic>> list) {
    return list.map(AverageRating.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["rating"] = rating;
    _data["totalRatings"] = totalRatings;
    _data["changePercentage"] = changePercentage;
    _data["changeDirection"] = changeDirection;
    return _data;
  }
}

class OnlineHours {
  double? hours;
  int? minutes;
  int? totalMinutes;
  double? changePercentage;
  String? changeDirection;

  OnlineHours({this.hours, this.minutes, this.totalMinutes, this.changePercentage, this.changeDirection});

  OnlineHours.fromJson(Map<String, dynamic> json) {
    hours = json["hours"];
    minutes = json["minutes"];
    totalMinutes = json["totalMinutes"];
    changePercentage = json["changePercentage"];
    changeDirection = json["changeDirection"];
  }

  static List<OnlineHours> fromList(List<Map<String, dynamic>> list) {
    return list.map(OnlineHours.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["hours"] = hours;
    _data["minutes"] = minutes;
    _data["totalMinutes"] = totalMinutes;
    _data["changePercentage"] = changePercentage;
    _data["changeDirection"] = changeDirection;
    return _data;
  }
}

class TotalTrips {
  int? count;
  double? changePercentage;
  String? changeDirection;

  TotalTrips({this.count, this.changePercentage, this.changeDirection});

  TotalTrips.fromJson(Map<String, dynamic> json) {
    count = json["count"];
    changePercentage = json["changePercentage"];
    changeDirection = json["changeDirection"];
  }

  static List<TotalTrips> fromList(List<Map<String, dynamic>> list) {
    return list.map(TotalTrips.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["count"] = count;
    _data["changePercentage"] = changePercentage;
    _data["changeDirection"] = changeDirection;
    return _data;
  }
}

class GrossIncome {
  double? amount;
  String? currency;

  GrossIncome({this.amount, this.currency});

  GrossIncome.fromJson(Map<String, dynamic> json) {
    amount = json["amount"];
    currency = json["currency"];
  }

  static List<GrossIncome> fromList(List<Map<String, dynamic>> list) {
    return list.map(GrossIncome.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["amount"] = amount;
    _data["currency"] = currency;
    return _data;
  }
}

class NetIncome {
  double? amount;
  String? currency;
  double? changePercentage;
  String? changeDirection;

  NetIncome({this.amount, this.currency, this.changePercentage, this.changeDirection});

  NetIncome.fromJson(Map<String, dynamic> json) {
    amount = json["amount"];
    currency = json["currency"];
    changePercentage = json["changePercentage"];
    changeDirection = json["changeDirection"];
  }

  static List<NetIncome> fromList(List<Map<String, dynamic>> list) {
    return list.map(NetIncome.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["amount"] = amount;
    _data["currency"] = currency;
    _data["changePercentage"] = changePercentage;
    _data["changeDirection"] = changeDirection;
    return _data;
  }
}