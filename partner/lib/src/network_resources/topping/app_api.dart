import 'package:app/src/utils/utils.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

class _MyAppEndpoint {
  _MyAppEndpoint._();
  // Topping endpoints
  static String getToppings() => "/api/v1/topping/get_my_stores";
  static String createTopping() => "/api/v1/topping/create";
  static String updateTopping() => "/api/v1/topping/update";
  static String deleteTopping() => "/api/v1/topping/delete";

  // Group Topping endpoints
  static String getGroupToppings() => "/api/v1/group/get_my_stores";
  static String createGroupTopping() => "/api/v1/group/create";
  static String updateGroupTopping() => "/api/v1/group/update";
  static String deleteGroupTopping() => "/api/v1/group/delete";
}

abstract class MyAppApi {
  // Topping methods
  Future<NetworkResponse> getToppings(Map<String, dynamic> params);
  Future<NetworkResponse> createTopping(Map<String, dynamic> data);
  Future<NetworkResponse> updateTopping(Map<String, dynamic> data);
  Future<NetworkResponse> deleteTopping(int id);

  // Group Topping methods
  Future<NetworkResponse> getGroupToppings(Map<String, dynamic> params);
  Future<NetworkResponse> createGroupTopping(Map<String, dynamic> data);
  Future<NetworkResponse> updateGroupTopping(Map<String, dynamic> data);
  Future<NetworkResponse> deleteGroupTopping(int id);
}

class MyAppApiImp extends MyAppApi {
  // Topping implementations
  @override
  Future<NetworkResponse> getToppings(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_MyAppEndpoint.getToppings(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) =>
              (json as List).map((e) => ToppingModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> createTopping(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        // Handle multipart/form-data
        FormData formData = FormData.fromMap(data);
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.createTopping(), data: formData);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => ToppingModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> updateTopping(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        // Handle multipart/form-data
        FormData formData = FormData.fromMap(data);
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.updateTopping(), data: formData);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => ToppingModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> deleteTopping(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.deleteTopping(), data: {'id': id});
        return NetworkResponse.fromResponse(
          response,
        );
      },
    );
  }

  // Group Topping implementations
  @override
  Future<NetworkResponse> getGroupToppings(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_MyAppEndpoint.getGroupToppings(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) =>
              (json as List).map((e) => GroupToppingModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> createGroupTopping(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.createGroupTopping(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => GroupToppingModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> updateGroupTopping(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.updateGroupTopping(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => GroupToppingModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> deleteGroupTopping(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.deleteGroupTopping(), data: {'id': id});
        return NetworkResponse.fromResponse(
          response,
        );
      },
    );
  }
}
