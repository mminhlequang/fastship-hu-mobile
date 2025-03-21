import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';

class StoreRepo {
  StoreRepo._();

  static StoreRepo? _instance;

  factory StoreRepo([MyAppApi? api]) {
    _instance ??= StoreRepo._();
    _instance!._api = api ?? MyAppApiImp();
    return _instance!;
  }

  late MyAppApi _api;

  Future<NetworkResponse> getStores(Map<String, dynamic> params) async {
    return await _api.getStores(params);
  }

  Future<NetworkResponse> getStoresByLatLng(Map<String, dynamic> params) async {
    return await _api.getStoresByLatLng(params);
  }

  Future<NetworkResponse> getMyStores(Map<String, dynamic> params) async {
    return await _api.getMyStores(params);
  }

  Future<NetworkResponse> getStoreDetail(int id) async {
    return await _api.getStoreDetail(id);
  }

  Future<NetworkResponse> getStoreRating(Map<String, dynamic> params) async {
    return await _api.getStoreRating(params);
  }

  Future<NetworkResponse> getStoreMenus(Map<String, dynamic> params) async {
    return await _api.getStoreMenus(params);
  }

  Future<NetworkResponse> createStore(Map<String, dynamic> data) async {
    return await _api.createStore(data);
  }

  Future<NetworkResponse> updateStore(Map<String, dynamic> data) async {
    return await _api.updateStore(data);
  }

  Future<NetworkResponse> deleteStore(int id) async {
    return await _api.deleteStore(id);
  }

  Future<NetworkResponse> uploadImage(dynamic imageFile) async {
    return await _api.uploadImage(imageFile);
  }

  Future<NetworkResponse> ratingStore(Map<String, dynamic> data) async {
    return await _api.ratingStore(data);
  }

  Future<NetworkResponse> replyRating(Map<String, dynamic> data) async {
    return await _api.replyRating(data);
  }

  Future<NetworkResponse> favoriteStore(int id) async {
    return await _api.favoriteStore(id);
  }

  Future<NetworkResponse> sortCategories(Map<String, dynamic> data) async {
    return await _api.sortCategories(data);
  }

  Future<NetworkResponse> sortToppings(Map<String, dynamic> data) async {
    return await _api.sortToppings(data);
  }

  Future<NetworkResponse> sortProducts(Map<String, dynamic> data) async {
    return await _api.sortProducts(data);
  }
}
