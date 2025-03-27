import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';

class CartRepo {
  CartRepo._();

  static CartRepo? _instance;

  factory CartRepo([MyAppApi? api]) {
    _instance ??= CartRepo._();
    _instance!._api = api ?? MyAppApiImp();
    return _instance!;
  }

  late MyAppApi _api;

  Future<NetworkResponse> getCarts(Map<String, dynamic> params) async {
    return await _api.getCarts(params);
  }

  Future<NetworkResponse> createCart(Map<String, dynamic> data) async {
    return await _api.createCart(data);
  }

  Future<NetworkResponse> updateCart(Map<String, dynamic> data) async {
    return await _api.updateCart(data);
  }

  Future<NetworkResponse> deleteCart(int id) async {
    return await _api.deleteCart(id);
  }
}
