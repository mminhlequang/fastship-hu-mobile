import 'package:app/src/utils/utils.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

class _MyAppEndpoint {
  _MyAppEndpoint._();
  static String getStores() => "/api/v1/store/get_stores";
  static String getStoresByLatLng() => "/api/v1/store/by_lat_lng";
  static String getMyStores() => "/api/v1/store/get_my_stores";
  static String getStoreDetail() => "/api/v1/store/detail";
  static String getStoreRating() => "/api/v1/store/get_rating";
  static String getStoreMenus() => "/api/v1/store/get_menus";
  static String createStore() => "/api/v1/store/create";
  static String updateStore() => "/api/v1/store/update";
  static String deleteStore() => "/api/v1/store/delete";
  static String uploadImage() => "/api/v1/store/upload";
  static String ratingStore() => "/api/v1/store/rating/insert";
  static String replyRating() => "/api/v1/store/rating/reply";
  static String favoriteStore() => "/api/v1/store/favorite/insert";
  static String sortCategories() => "/api/v1/store/sort_categproes";
  static String sortToppings() => "/api/v1/store/sort_toppings";
  static String sortProducts() => "/api/v1/store/sort_products";
}

abstract class MyAppApi {
  Future<NetworkResponse> getStores(Map<String, dynamic> params);
  Future<NetworkResponse> getStoresByLatLng(Map<String, dynamic> params);
  Future<NetworkResponse> getMyStores(Map<String, dynamic> params);
  Future<NetworkResponse> getStoreDetail(Map<String, dynamic> params);
  Future<NetworkResponse> getStoreRating(Map<String, dynamic> params);
  Future<NetworkResponse> getStoreMenus(Map<String, dynamic> params);
  Future<NetworkResponse> createStore(Map<String, dynamic> data);
  Future<NetworkResponse> updateStore(Map<String, dynamic> data);
  Future<NetworkResponse> deleteStore(int id);
  Future<NetworkResponse> uploadImage(dynamic filePath);
  Future<NetworkResponse> ratingStore(Map<String, dynamic> data);
  Future<NetworkResponse> replyRating(Map<String, dynamic> data);
  Future<NetworkResponse> favoriteStore(int id);
  Future<NetworkResponse> sortCategories(Map<String, dynamic> data);
  Future<NetworkResponse> sortToppings(Map<String, dynamic> data);
  Future<NetworkResponse> sortProducts(Map<String, dynamic> data);
}

class MyAppApiImp extends MyAppApi {
  @override
  Future<NetworkResponse> getStores(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_MyAppEndpoint.getStores(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) =>
              (json as List).map((e) => StoreModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getStoresByLatLng(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_MyAppEndpoint.getStoresByLatLng(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) =>
              (json as List).map((e) => StoreModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getMyStores(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_MyAppEndpoint.getMyStores(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) =>
              (json as List).map((e) => StoreModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getStoreDetail(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_MyAppEndpoint.getStoreDetail(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => StoreModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getStoreRating(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_MyAppEndpoint.getStoreRating(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) =>
              (json as List).map((e) => RatingModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getStoreMenus(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_MyAppEndpoint.getStoreMenus(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) =>
              (json as List).map((e) => MenuModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> createStore(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.createStore(), data: data);
        return NetworkResponse.fromResponse(
          response,
          value: response.data['status'] == true,
        );
      },
    );
  }

  @override
  Future<NetworkResponse> updateStore(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.updateStore(), data: data);
        return NetworkResponse.fromResponse(
          response,
          value: response.data['status'] == true,
        );
      },
    );
  }

  @override
  Future<NetworkResponse> deleteStore(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.deleteStore(), data: {'id': id});
        return NetworkResponse.fromResponse(
          response,
        );
      },
    );
  }

  @override
  Future<NetworkResponse> uploadImage(dynamic filePath) async {
    return await handleNetworkError(
      proccess: () async {
        FormData formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(filePath, filename: filePath),
          // 'type': type,
        });

        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.uploadImage(), data: formData);
        return NetworkResponse.fromResponse(response);
      },
    );
  }

  @override
  Future<NetworkResponse> ratingStore(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.ratingStore(), data: data);
        return NetworkResponse.fromResponse(
          response,
        );
      },
    );
  }

  @override
  Future<NetworkResponse> replyRating(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.replyRating(), data: data);
        return NetworkResponse.fromResponse(
          response,
        );
      },
    );
  }

  @override
  Future<NetworkResponse> favoriteStore(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.favoriteStore(), data: {'id': id});
        return NetworkResponse.fromResponse(
          response,
        );
      },
    );
  }

  @override
  Future<NetworkResponse> sortCategories(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.sortCategories(), data: data);
        return NetworkResponse.fromResponse(
          response,
        );
      },
    );
  }

  @override
  Future<NetworkResponse> sortToppings(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.sortToppings(), data: data);
        return NetworkResponse.fromResponse(
          response,
        );
      },
    );
  }

  @override
  Future<NetworkResponse> sortProducts(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.sortProducts(), data: data);
        return NetworkResponse.fromResponse(
          response,
        );
      },
    );
  }
}
