import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'model/feedback_type.dart';
import 'model/banner.dart';
import 'model/config.dart';
import 'model/category.dart';
import 'model/shop.dart';
import 'model/food.dart';

class _MyAppEndpoint {
  _MyAppEndpoint._();
  static String demo() => "/v2/demo";
}

class _CommonEndpoint {
  _CommonEndpoint._();
  static String getBanners() => "/api/v1/banners";
  static String getConfig() => "/api/v1/config";
  static String getCategories() => "/api/v1/categories/get_categories";
  static String getShops() => "/api/v1/store/get_stores";
  static String getFoods() => "/api/v1/product/get_products";
}

abstract class MyAppApi {
  Future<NetworkResponse> demo(params);
}

abstract class CommonApi {
  Future<NetworkResponse> getBanners();
  Future<NetworkResponse> getConfig();
  Future<NetworkResponse> getCategories();
  Future<NetworkResponse> getShops();
  Future<NetworkResponse> getFoods();
}

class MyAppApiImp extends MyAppApi {
  @override
  Future<NetworkResponse> demo(params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient()
            .get(_MyAppEndpoint.demo(), queryParameters: params);
        return NetworkResponse.fromResponse(response,
            converter: (json) =>
                (json as List).map((e) => FeedbackType.fromJson(e)).toList());
      },
    );
  }
}

class CommonApiImp extends CommonApi {
  @override
  Future<NetworkResponse> getBanners() async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient().get(_CommonEndpoint.getBanners());
        return NetworkResponse.fromResponse(response,
            converter: (json) =>
                (json as List).map((e) => Banner.fromJson(e)).toList());
      },
    );
  }

  @override
  Future<NetworkResponse> getConfig() async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient().get(_CommonEndpoint.getConfig());
        return NetworkResponse.fromResponse(response,
            converter: (json) => Config.fromJson(json));
      },
    );
  }

  @override
  Future<NetworkResponse> getCategories() async {
    return await handleNetworkError(
      proccess: () async {
        Response response =
            await AppClient().get(_CommonEndpoint.getCategories());
        return NetworkResponse.fromResponse(response,
            converter: (json) =>
                (json as List).map((e) => Category.fromJson(e)).toList());
      },
    );
  }

  @override
  Future<NetworkResponse> getShops() async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient().get(_CommonEndpoint.getShops());
        return NetworkResponse.fromResponse(response,
            converter: (json) =>
                (json as List).map((e) => Shop.fromJson(e)).toList());
      },
    );
  }

  @override
  Future<NetworkResponse> getFoods() async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient().get(_CommonEndpoint.getFoods());
        return NetworkResponse.fromResponse(response,
            converter: (json) =>
                (json as List).map((e) => Food.fromJson(e)).toList());
      },
    );
  }
}
