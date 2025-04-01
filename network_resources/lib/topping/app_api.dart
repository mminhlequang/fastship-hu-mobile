import 'package:internal_core/internal_core.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import '../product/model/product.dart';
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

  // Variation endpoints
  static String createVariation() => "/api/v1/variation/create";
  static String updateVariation() => "/api/v1/variation/update";
  static String deleteVariation() => "/api/v1/variation/delete";
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

  // Variation methods
  Future<NetworkResponse> createVariation(Map<String, dynamic> data);
  Future<NetworkResponse> updateVariation(Map<String, dynamic> data);
  Future<NetworkResponse> deleteVariation(int id);
}

class MyAppApiImp extends MyAppApi {
  // Topping implementations
  @override
  Future<NetworkResponse> getToppings(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_MyAppEndpoint.getToppings(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
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
          token: await appPrefs.getNormalToken(),
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
          token: await appPrefs.getNormalToken(),
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
          token: await appPrefs.getNormalToken(),
        ).post(_MyAppEndpoint.deleteTopping(), data: {'id': id});
        return NetworkResponse.fromResponse(
          response,
          value: response.data['status'] == true,
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
          token: await appPrefs.getNormalToken(),
        ).get(_MyAppEndpoint.getGroupToppings(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List)
                      .map((e) => GroupToppingModel.fromJson(e))
                      .toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> createGroupTopping(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
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
          token: await appPrefs.getNormalToken(),
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
          token: await appPrefs.getNormalToken(),
        ).post(_MyAppEndpoint.deleteGroupTopping(), data: {'id': id});
        return NetworkResponse.fromResponse(
          response,
          value: response.data['status'] == true,
        );
      },
    );
  }

  @override
  Future<NetworkResponse> createVariation(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_MyAppEndpoint.createVariation(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => VariationModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> updateVariation(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_MyAppEndpoint.updateVariation(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => VariationModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> deleteVariation(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_MyAppEndpoint.deleteVariation(), data: {'id': id});
        return NetworkResponse.fromResponse(
          response,
          value: response.data['status'] == true,
        );
      },
    );
  }
}
