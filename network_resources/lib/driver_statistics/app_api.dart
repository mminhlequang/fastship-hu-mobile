import 'package:internal_core/internal_core.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

class _DriverStatisticsEndpoint {
  _DriverStatisticsEndpoint._();

  // Overview
  static String getOverview() => "/api/v1/driver/statistics/overview";

  // Income Chart
  static String getIncomeChart() => "/api/v1/driver/statistics/income-chart";

  // Trips Chart
  static String getTripsChart() => "/api/v1/driver/statistics/trips-chart";

  // Income Breakdown
  static String getIncomeBreakdown() =>
      "/api/v1/driver/statistics/income-breakdown";

  // Time Chart
  static String getTimeChart() => "/api/v1/driver/statistics/time-chart";

  // Details
  static String getDetails() => "/api/v1/driver/statistics/details";
}

abstract class DriverStatisticsApi {
  // Overview
  Future<NetworkResponse> getOverview(Map<String, dynamic> params);

  // Income Chart
  Future<NetworkResponse> getIncomeChart(Map<String, dynamic> params);

  // Trips Chart
  Future<NetworkResponse> getTripsChart(Map<String, dynamic> params);

  // Income Breakdown
  Future<NetworkResponse> getIncomeBreakdown(Map<String, dynamic> params);

  // Time Chart
  Future<NetworkResponse> getTimeChart(Map<String, dynamic> params);

  // Details
  Future<NetworkResponse> getDetails(Map<String, dynamic> params);
}

class DriverStatisticsApiImp extends DriverStatisticsApi {
  @override
  Future<NetworkResponse> getOverview(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_DriverStatisticsEndpoint.getOverview(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => DriverStatisticOverviewModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getIncomeChart(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(
          _DriverStatisticsEndpoint.getIncomeChart(),
          queryParameters: params,
        );
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => DriverStatIncomeChart.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getTripsChart(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(
          _DriverStatisticsEndpoint.getTripsChart(),
          queryParameters: params,
        );
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => DriverStatTripsChart.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getIncomeBreakdown(
    Map<String, dynamic> params,
  ) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(
          _DriverStatisticsEndpoint.getIncomeBreakdown(),
          queryParameters: params,
        );
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) => DriverStatIncomeBreakdown.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getTimeChart(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(
          _DriverStatisticsEndpoint.getTimeChart(),
          queryParameters: params,
        );
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => DriverStatTimeChart.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getDetails(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_DriverStatisticsEndpoint.getDetails(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => DriverStatDetail.fromJson(json),
        );
      },
    );
  }
}
