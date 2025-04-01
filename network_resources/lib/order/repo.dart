import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';
import 'models/order.dart';

class OrderRepo {
  OrderRepo._();

  static OrderRepo? _instance;

  factory OrderRepo([OrderApi? api]) {
    _instance ??= OrderRepo._();
    _instance!._api = api ?? OrderApiImp();
    return _instance!;
  }

  late OrderApi _api;

  Future<NetworkResponse> getOrders(Map<String, dynamic> params) async {
    return await _api.getOrders(params);
  }

  Future<NetworkResponse> getOrderDetail(int id) async {
    return await _api.getOrderDetail(id);
  }

  Future<NetworkResponse> updateOrderStatus(Map<String, dynamic> data) async {
    return await _api.updateOrderStatus(data);
  }

  Future<NetworkResponse> cancelOrder(int id) async {
    return await _api.cancelOrder(id);
  }

  Future<NetworkResponse> completeOrder(int id) async {
    return await _api.completeOrder(id);
  }
}
