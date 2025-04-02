import 'package:internal_core/internal_core.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

class _OrderEndpoint {
  _OrderEndpoint._();
  static String getOrdersByUser() => "/api/v1/order/get_orders_by_user";
  static String getOrdersByStore() => "/api/v1/order/get_orders_by_store";
  static String getOrderDetail() => "/api/v1/order/detail";
  static String createOrder() => "/api/v1/order/create";
  static String updateOrder() => "/api/v1/order/update";
  static String cancelOrder() => "/api/v1/order/cancel";
}

abstract class OrderApi {
  Future<NetworkResponse> getOrdersByUser(Map<String, dynamic> params);
  Future<NetworkResponse> getOrdersByStore(Map<String, dynamic> params);
  Future<NetworkResponse> getOrderDetail(Map<String, dynamic> params);
  Future<NetworkResponse> createOrder(Map<String, dynamic> params);
  Future<NetworkResponse> updateOrder(Map<String, dynamic> params);
  Future<NetworkResponse> cancelOrder(Map<String, dynamic> params);
}

class OrderApiImp extends OrderApi {
  @override
  Future<NetworkResponse> getOrdersByUser(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_OrderEndpoint.getOrdersByUser(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List).map((e) => OrderModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getOrdersByStore(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_OrderEndpoint.getOrdersByStore(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List).map((e) => OrderModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getOrderDetail(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_OrderEndpoint.getOrderDetail(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => OrderModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> createOrder(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_OrderEndpoint.createOrder(), data: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => CreateOrderResponse.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> updateOrder(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_OrderEndpoint.updateOrder(), data: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => OrderModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> cancelOrder(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_OrderEndpoint.cancelOrder(), data: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => OrderModel.fromJson(json),
        );
      },
    );
  }
}
