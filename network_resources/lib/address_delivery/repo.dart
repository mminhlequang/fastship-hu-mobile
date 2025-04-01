import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';

class AddressDeliveryRepo {
  AddressDeliveryRepo._();

  static AddressDeliveryRepo? _instance;

  factory AddressDeliveryRepo([MyAppApi? api]) {
    _instance ??= AddressDeliveryRepo._();
    _instance!._api = api ?? MyAppApiImp();
    return _instance!;
  }

  late MyAppApi _api;

  Future<NetworkResponse> getAddresses(Map<String, dynamic> params) async {
    return await _api.getAddresses(params);
  }

  Future<NetworkResponse> getAddressDetail(int id) async {
    return await _api.getAddressDetail(id);
  }

  Future<NetworkResponse> createAddress(Map<String, dynamic> data) async {
    return await _api.createAddress(data);
  }

  Future<NetworkResponse> updateAddress(Map<String, dynamic> data) async {
    return await _api.updateAddress(data);
  }

  Future<NetworkResponse> deleteAddress(int id) async {
    return await _api.deleteAddress(id);
  }
}
