import 'package:app/src/utils/utils.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

class _MyAppEndpoint {
  _MyAppEndpoint._();
  static String getAddresses() => "/api/v1/address_delivery";
  static String getAddressDetail() => "/api/v1/address_delivery/detail";
  static String createAddress() => "/api/v1/address_delivery/create";
  static String updateAddress() => "/api/v1/address_delivery/update";
  static String deleteAddress() => "/api/v1/address_delivery/delete";
}

abstract class MyAppApi {
  Future<NetworkResponse> getAddresses(Map<String, dynamic> params);
  Future<NetworkResponse> getAddressDetail(int id);
  Future<NetworkResponse> createAddress(Map<String, dynamic> data);
  Future<NetworkResponse> updateAddress(Map<String, dynamic> data);
  Future<NetworkResponse> deleteAddress(int id);
}

class MyAppApiImp extends MyAppApi {
  @override
  Future<NetworkResponse> getAddresses(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_MyAppEndpoint.getAddresses(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) =>
              (json as List).map((e) => AddressModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getAddressDetail(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_MyAppEndpoint.getAddressDetail(), queryParameters: {'id': id});
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => AddressModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> createAddress(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.createAddress(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => AddressModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> updateAddress(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.updateAddress(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => AddressModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> deleteAddress(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.deleteAddress(), data: {'id': id});
        return NetworkResponse.fromResponse(
          response,
        );
      },
    );
  }
}
