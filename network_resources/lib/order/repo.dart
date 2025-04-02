import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';

class OrderRepo {
  OrderRepo._();

  static OrderRepo? _instance;

  factory OrderRepo([OrderApi? api]) {
    _instance ??= OrderRepo._();
    _instance!._api = api ?? OrderApiImp();
    return _instance!;
  }

  late OrderApi _api;

  Future<NetworkResponse> getOrdersByUser(Map<String, dynamic> params) async {
    return await _api.getOrdersByUser(params);
  }

  Future<NetworkResponse> getOrdersByStore(Map<String, dynamic> params) async {
    return await _api.getOrdersByStore(params);
  }

  Future<NetworkResponse> getOrderDetail(Map<String, dynamic> params) async {
    return await _api.getOrderDetail(params);
  }

  Future<NetworkResponse> createOrder(Map<String, dynamic> params) async {
    return await _api.createOrder(params);
  }

  Future<NetworkResponse> updateOrder(Map<String, dynamic> params) async {
    return await _api.updateOrder(params);
  }

  Future<NetworkResponse> cancelOrder(Map<String, dynamic> params) async {
    return await _api.cancelOrder(params);
  }
}
