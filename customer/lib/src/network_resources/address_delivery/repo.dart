import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';
import 'model/address_delivery.dart';

class AddressDeliveryRepo {
  AddressDeliveryRepo._();

  static AddressDeliveryRepo? _instance;

  factory AddressDeliveryRepo([AddressDeliveryApi? api]) {
    _instance ??= AddressDeliveryRepo._();
    _instance!._api = api ?? AddressDeliveryApiImp();
    return _instance!;
  }

  late AddressDeliveryApi _api;

  Future<List<AddressDelivery>?> getAll() async {
    NetworkResponse response = await _api.getAll();
    return response.data;
  }

  Future<AddressDelivery?> getDetail(String id) async {
    NetworkResponse response = await _api.getDetail(id);
    return response.data;
  }

  Future<bool> create(Map<String, dynamic> params) async {
    NetworkResponse response = await _api.create(params);
    return response.isSuccess;
  }

  Future<bool> update(Map<String, dynamic> params) async {
    NetworkResponse response = await _api.update(params);
    return response.isSuccess;
  }

  Future<bool> delete(String id) async {
    NetworkResponse response = await _api.delete(id);
    return response.isSuccess;
  }
}
