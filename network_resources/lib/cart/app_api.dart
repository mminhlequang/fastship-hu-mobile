import 'package:internal_core/internal_core.dart';
import 'package:internal_core/internal_core.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

class _MyAppEndpoint {
  _MyAppEndpoint._();
  static String getCarts() => "/api/v1/cart";
  static String createCart() => "/api/v1/cart/create";
  static String updateCart() => "/api/v1/cart/update";
  static String deleteCart() => "/api/v1/cart/delete";
}

abstract class MyAppApi {
  Future<NetworkResponse> getCarts(Map<String, dynamic> params);
  Future<NetworkResponse> createCart(Map<String, dynamic> data);
  Future<NetworkResponse> updateCart(Map<String, dynamic> data);
  Future<NetworkResponse> deleteCart(int id);
}

class MyAppApiImp extends MyAppApi {
  @override
  Future<NetworkResponse> getCarts(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_MyAppEndpoint.getCarts(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List).map((e) => CartModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> createCart(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_MyAppEndpoint.createCart(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => CartModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> updateCart(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_MyAppEndpoint.updateCart(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => CartModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> deleteCart(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_MyAppEndpoint.deleteCart(), data: {'id': id});
        return NetworkResponse.fromResponse(response);
      },
    );
  }
}
