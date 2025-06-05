import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';

class DriverStatisticsRepo {
  DriverStatisticsRepo._();

  static DriverStatisticsRepo? _instance;

  factory DriverStatisticsRepo([DriverStatisticsApi? api]) {
    _instance ??= DriverStatisticsRepo._();
    _instance!._api = api ?? DriverStatisticsApiImp();
    return _instance!;
  }

  late DriverStatisticsApi _api;

  // Overview
  Future<NetworkResponse> getOverview(Map<String, dynamic> params) async {
    return await _api.getOverview(params);
  }

  // Income Chart
  Future<NetworkResponse> getIncomeChart(Map<String, dynamic> params) async {
    return await _api.getIncomeChart(params);
  }

  // Trips Chart
  Future<NetworkResponse> getTripsChart(Map<String, dynamic> params) async {
    return await _api.getTripsChart(params);
  }

  // Income Breakdown
  Future<NetworkResponse> getIncomeBreakdown(
    Map<String, dynamic> params,
  ) async {
    return await _api.getIncomeBreakdown(params);
  }

  // Time Chart
  Future<NetworkResponse> getTimeChart(Map<String, dynamic> params) async {
    return await _api.getTimeChart(params);
  }

  // Details
  Future<NetworkResponse> getDetails(Map<String, dynamic> params) async {
    return await _api.getDetails(params);
  }
}
