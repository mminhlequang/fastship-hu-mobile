import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';

class StoreReportRepo {
  StoreReportRepo._();

  static StoreReportRepo? _instance;

  factory StoreReportRepo([ReportApi? api]) {
    _instance ??= StoreReportRepo._();
    _instance!._api = api ?? ReportApiImp();
    return _instance!;
  }

  late ReportApi _api;

  // Report Overview
  Future<NetworkResponse> getReportOverview(Map<String, dynamic> params) async {
    return await _api.getReportOverview(params);
  }

  // Revenue Chart
  Future<NetworkResponse> getRevenueChart(Map<String, dynamic> params) async {
    return await _api.getRevenueChart(params);
  }

  // Top Selling Items
  Future<NetworkResponse> getTopSellingItems(
    Map<String, dynamic> params,
  ) async {
    return await _api.getTopSellingItems(params);
  }

  // Recent Reviews
  Future<NetworkResponse> getRecentReviews(Map<String, dynamic> params) async {
    return await _api.getRecentReviews(params);
  }

  // Recent Orders
  Future<NetworkResponse> getRecentOrders(Map<String, dynamic> params) async {
    return await _api.getRecentOrders(params);
  }

  // Cancelled Orders
  Future<NetworkResponse> getCancelledOrders(
    Map<String, dynamic> params,
  ) async {
    return await _api.getCancelledOrders(params);
  }

  // Performance Metrics
  Future<NetworkResponse> getPerformanceMetrics(
    Map<String, dynamic> params,
  ) async {
    return await _api.getPerformanceMetrics(params);
  }
}
