import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'model/address_delivery.dart';

class _AddressDeliveryEndpoint {
  _AddressDeliveryEndpoint._();
  static String getAll() => "/api/v1/address_delivery";
  static String getDetail(String id) => "/api/v1/address_delivery/detail/$id";
  static String create() => "/api/v1/address_delivery/create";
  static String update() => "/api/v1/address_delivery/update";
  static String delete() => "/api/v1/address_delivery/delete";
}

abstract class AddressDeliveryApi {
  Future<NetworkResponse> getAll();
  Future<NetworkResponse> getDetail(String id);
  Future<NetworkResponse> create(Map<String, dynamic> params);
  Future<NetworkResponse> update(Map<String, dynamic> params);
  Future<NetworkResponse> delete(String id);
}

class AddressDeliveryApiImp extends AddressDeliveryApi {
  @override
  Future<NetworkResponse> getAll() async {
    return await handleNetworkError(
      proccess: () async {
        Response response =
            await AppClient().get(_AddressDeliveryEndpoint.getAll());
        return NetworkResponse.fromResponse(response,
            converter: (json) => (json as List)
                .map((e) => AddressDelivery.fromJson(e))
                .toList());
      },
    );
  }

  @override
  Future<NetworkResponse> getDetail(String id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response =
            await AppClient().get(_AddressDeliveryEndpoint.getDetail(id));
        return NetworkResponse.fromResponse(response,
            converter: (json) => AddressDelivery.fromJson(json));
      },
    );
  }

  @override
  Future<NetworkResponse> create(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient()
            .post(_AddressDeliveryEndpoint.create(), data: params);
        return NetworkResponse.fromResponse(response);
      },
    );
  }

  @override
  Future<NetworkResponse> update(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient()
            .post(_AddressDeliveryEndpoint.update(), data: params);
        return NetworkResponse.fromResponse(response);
      },
    );
  }

  @override
  Future<NetworkResponse> delete(String id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient()
            .post(_AddressDeliveryEndpoint.delete(), data: {'id': id});
        return NetworkResponse.fromResponse(response);
      },
    );
  }
}
