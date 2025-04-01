import 'package:internal_core/internal_core.dart';
import 'package:dio/dio.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';

import 'models/order.dart';

abstract class OrderApi {
  Future<NetworkResponse> getOrders(Map<String, dynamic> params);
  Future<NetworkResponse> getOrderDetail(int id);
  Future<NetworkResponse> updateOrderStatus(Map<String, dynamic> data);
  Future<NetworkResponse> cancelOrder(int id);
  Future<NetworkResponse> completeOrder(int id);
}

class OrderApiImp extends OrderApi {
  @override
  Future<NetworkResponse> getOrders(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_OrderEndpoint.getOrders(), queryParameters: params);
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
  Future<NetworkResponse> getOrderDetail(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_OrderEndpoint.getOrderDetail(), queryParameters: {'id': id});
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => OrderModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> updateOrderStatus(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_OrderEndpoint.updateOrderStatus(), data: data);
        return NetworkResponse.fromResponse(
          response,
          value: response.data['status'] == true,
        );
      },
    );
  }

  @override
  Future<NetworkResponse> cancelOrder(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_OrderEndpoint.cancelOrder(), data: {'id': id});
        return NetworkResponse.fromResponse(
          response,
          value: response.data['status'] == true,
        );
      },
    );
  }

  @override
  Future<NetworkResponse> completeOrder(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_OrderEndpoint.completeOrder(), data: {'id': id});
        return NetworkResponse.fromResponse(
          response,
          value: response.data['status'] == true,
        );
      },
    );
  }
}

class _OrderEndpoint {
  static String getOrders() => '/orders';
  static String getOrderDetail() => '/orders/detail';
  static String updateOrderStatus() => '/orders/status';
  static String cancelOrder() => '/orders/cancel';
  static String completeOrder() => '/orders/complete';
}
