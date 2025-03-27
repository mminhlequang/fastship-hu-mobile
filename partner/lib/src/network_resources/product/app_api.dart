import 'package:app/src/utils/utils.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import '../store/models/models.dart';
import 'model/product.dart';

class _ProductEndpoint {
  _ProductEndpoint._();
  static String getProducts() => "/api/v1/product/get_products";
  static String getProductDetail() => "/api/v1/product/detail";
  static String getFavoriteProducts() => "/api/v1/product/get_favorites";
  static String createProduct() => "/api/v1/product/create";
  static String updateProduct() => "/api/v1/product/update";
  static String deleteProduct() => "/api/v1/product/delete";
  static String favoriteProduct() => "/api/v1/product/favorite/insert";
  static String uploadImage() => "/api/v1/product/upload";
}

abstract class ProductApi {
  Future<NetworkResponse> getProducts(Map<String, dynamic> params);
  Future<NetworkResponse> getProductDetail(int id);
  Future<NetworkResponse> getFavoriteProducts(Map<String, dynamic> params);
  Future<NetworkResponse> createProduct(Map<String, dynamic> data);
  Future<NetworkResponse> updateProduct(Map<String, dynamic> data);
  Future<NetworkResponse> deleteProduct(int id);
  Future<NetworkResponse> favoriteProduct(int id);
  Future<NetworkResponse> uploadImage(dynamic filePath);
}

class ProductApiImp extends ProductApi {
  @override
  Future<NetworkResponse> getProducts(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_ProductEndpoint.getProducts(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) =>
              (json as List).map((e) => ProductModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getProductDetail(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_ProductEndpoint.getProductDetail(), queryParameters: {'id': id});
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => ProductModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getFavoriteProducts(
      Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_ProductEndpoint.getFavoriteProducts(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) =>
              (json as List).map((e) => ProductModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> createProduct(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_ProductEndpoint.createProduct(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => ProductModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> updateProduct(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_ProductEndpoint.updateProduct(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => ProductModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> deleteProduct(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_ProductEndpoint.deleteProduct(), data: {'id': id});
        return NetworkResponse.fromResponse(response);
      },
    );
  }

  @override
  Future<NetworkResponse> favoriteProduct(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_ProductEndpoint.favoriteProduct(), data: {'id': id});
        return NetworkResponse.fromResponse(response);
      },
    );
  }

  @override
  Future<NetworkResponse> uploadImage(dynamic filePath) async {
    return await handleNetworkError(
      proccess: () async {
        final formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(filePath, filename: filePath),
        });
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_ProductEndpoint.uploadImage(), data: formData);
        return NetworkResponse.fromResponse(response);
      },
    );
  }
}
