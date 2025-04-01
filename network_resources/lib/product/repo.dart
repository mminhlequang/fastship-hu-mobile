import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';
import 'model/product.dart';

class ProductRepo {
  ProductRepo._();

  static ProductRepo? _instance;

  factory ProductRepo([ProductApi? api]) {
    _instance ??= ProductRepo._();
    _instance!._api = api ?? ProductApiImp();
    return _instance!;
  }

  late ProductApi _api;

  Future<NetworkResponse> getProducts(Map<String, dynamic> params) async {
    return await _api.getProducts(params);
  }

  Future<NetworkResponse> getProductDetail(int id) async {
    return await _api.getProductDetail(id);
  }

  Future<NetworkResponse> getFavoriteProducts(
      Map<String, dynamic> params) async {
    return await _api.getFavoriteProducts(params);
  }

  Future<NetworkResponse> createProduct(Map<String, dynamic> data) async {
    return await _api.createProduct(data);
  }

  Future<NetworkResponse> updateProduct(Map<String, dynamic> data) async {
    return await _api.updateProduct(data);
  }

  Future<NetworkResponse> deleteProduct(int id) async {
    return await _api.deleteProduct(id);
  }

  Future<NetworkResponse> favoriteProduct(int id) async {
    return await _api.favoriteProduct(id);
  }

  Future<NetworkResponse> uploadImage(dynamic filePath) async {
    return await _api.uploadImage(filePath);
  }
}
