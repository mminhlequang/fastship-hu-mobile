import 'package:internal_core/internal_core.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

class _ReportEndpoint {
  _ReportEndpoint._();

  // Report Overview
  static String getReportOverview() => "/api/v1/reports/overview";

  // Revenue Chart
  static String getRevenueChart() => "/api/v1/reports/revenue-chart";

  // Top Selling Items
  static String getTopSellingItems() => "/api/v1/reports/top-selling-items";

  // Recent Reviews
  static String getRecentReviews() => "/api/v1/reports/recent-reviews";

  // Recent Orders
  static String getRecentOrders() => "/api/v1/reports/recent-orders";

  // Cancelled Orders
  static String getCancelledOrders() => "/api/v1/reports/cancelled-orders";

  // Performance Metrics
  static String getPerformanceMetrics() =>
      "/api/v1/reports/performance-metrics";
}

abstract class ReportApi {
  // Report Overview
  Future<NetworkResponse> getReportOverview(Map<String, dynamic> params);

  // Revenue Chart
  Future<NetworkResponse> getRevenueChart(Map<String, dynamic> params);

  // Top Selling Items
  Future<NetworkResponse> getTopSellingItems(Map<String, dynamic> params);

  // Recent Reviews
  Future<NetworkResponse> getRecentReviews(Map<String, dynamic> params);

  // Recent Orders
  Future<NetworkResponse> getRecentOrders(Map<String, dynamic> params);

  // Cancelled Orders
  Future<NetworkResponse> getCancelledOrders(Map<String, dynamic> params);

  // Performance Metrics
  Future<NetworkResponse> getPerformanceMetrics(Map<String, dynamic> params);
}

class ReportApiImp extends ReportApi {
  @override
  Future<NetworkResponse> getReportOverview(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_ReportEndpoint.getReportOverview(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => ReportOverviewModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getRevenueChart(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_ReportEndpoint.getRevenueChart(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => ReportRevenueChartModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getTopSellingItems(
    Map<String, dynamic> params,
  ) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_ReportEndpoint.getTopSellingItems(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List)
                      .map((e) => ReportTopSellingItemModel.fromJson(e))
                      .toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getRecentReviews(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_ReportEndpoint.getRecentReviews(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List)
                      .map((e) => ReportRecentReviewModel.fromJson(e))
                      .toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getRecentOrders(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_ReportEndpoint.getRecentOrders(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List)
                      .map((e) => ReportRecentOrderModel.fromJson(e))
                      .toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getCancelledOrders(
    Map<String, dynamic> params,
  ) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_ReportEndpoint.getCancelledOrders(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List)
                      .map((e) => ReportCancelledOrderModel.fromJson(e))
                      .toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getPerformanceMetrics(
    Map<String, dynamic> params,
  ) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_ReportEndpoint.getPerformanceMetrics(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => ReportPerformanceMetricsModel.fromJson(json),
        );
      },
    );
  }
}
