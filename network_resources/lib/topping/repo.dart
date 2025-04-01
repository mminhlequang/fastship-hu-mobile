import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';

class ToppingRepo {
  ToppingRepo._();

  static ToppingRepo? _instance;

  factory ToppingRepo([MyAppApi? api]) {
    _instance ??= ToppingRepo._();
    _instance!._api = api ?? MyAppApiImp();
    return _instance!;
  }

  late MyAppApi _api;

  // Topping APIs
  Future<NetworkResponse> getToppings(Map<String, dynamic> params) async {
    return await _api.getToppings(params);
  }

  Future<NetworkResponse> createTopping(Map<String, dynamic> data) async {
    return await _api.createTopping(data);
  }

  Future<NetworkResponse> updateTopping(Map<String, dynamic> data) async {
    return await _api.updateTopping(data);
  }

  Future<NetworkResponse> deleteTopping(int id) async {
    return await _api.deleteTopping(id);
  }

  // Group Topping APIs
  Future<NetworkResponse> getGroupToppings(Map<String, dynamic> params) async {
    return await _api.getGroupToppings(params);
  }

  Future<NetworkResponse> createGroupTopping(Map<String, dynamic> data) async {
    return await _api.createGroupTopping(data);
  }

  Future<NetworkResponse> updateGroupTopping(Map<String, dynamic> data) async {
    return await _api.updateGroupTopping(data);
  }

  Future<NetworkResponse> deleteGroupTopping(int id) async {
    return await _api.deleteGroupTopping(id);
  }

  Future<NetworkResponse> createVariation(Map<String, dynamic> data) async {
    return await _api.createVariation(data);
  }

  Future<NetworkResponse> updateVariation(Map<String, dynamic> data) async {
    return await _api.updateVariation(data);
  }

  Future<NetworkResponse> deleteVariation(int id) async {
    return await _api.deleteVariation(id);
  }
}
