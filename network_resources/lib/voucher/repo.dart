import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';

class VoucherRepo {
  VoucherRepo._();

  static VoucherRepo? _instance;

  factory VoucherRepo([MyAppApi? api]) {
    _instance ??= VoucherRepo._();
    _instance!._api = api ?? MyAppApiImp();
    return _instance!;
  }

  late MyAppApi _api;

  Future<NetworkResponse> getVouchers(Map<String, dynamic> params) async {
    return await _api.getVouchers(params);
  }

  Future<NetworkResponse> getSavedVouchers(Map<String, dynamic> params) async {
    return await _api.getSavedVouchers(params);
  }

  Future<NetworkResponse> createVoucher(Map<String, dynamic> data) async {
    return await _api.createVoucher(data);
  }

  Future<NetworkResponse> updateVoucher(Map<String, dynamic> data) async {
    return await _api.updateVoucher(data);
  }

  Future<NetworkResponse> saveVoucher(int id) async {
    return await _api.saveVoucher(id);
  }

  Future<NetworkResponse> deleteVoucher(int id) async {
    return await _api.deleteVoucher(id);
  }

  Future<NetworkResponse> checkVoucher(Map<String, dynamic> data) async {
    return await _api.checkVoucher(data);
  }
}
