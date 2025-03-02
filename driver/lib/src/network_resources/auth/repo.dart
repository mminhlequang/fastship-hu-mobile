import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';

class AuthRepo {
  AuthRepo._();

  static AuthRepo? _instance;

  factory AuthRepo([MyAppApi? api]) {
    _instance ??= AuthRepo._();
    _instance!._api = api ?? MyAppApiImp();
    return _instance!;
  }

  late MyAppApi _api;

  Future<NetworkResponse> register(Map<String, dynamic> data) async {
    return await _api.register(data);
  }

  Future<NetworkResponse> login(Map<String, dynamic> data) async {
    return await _api.login(data);
  }

  Future<NetworkResponse> updatePassword(Map<String, dynamic> data) async {
    return await _api.updatePassword(data);
  }

  Future<NetworkResponse> resetPassword(Map<String, dynamic> data) async {
    return await _api.resetPassword(data);
  }

  Future<NetworkResponse> getProfile() async {
    return await _api.getProfile();
  }

  Future<NetworkResponse> updateProfile(Map<String, dynamic> data) async {
    return await _api.updateProfile(data);
  }

  Future<NetworkResponse> checkPhone(Map<String, dynamic> data) async {
    return await _api.checkPhone(data);
  }

  Future<NetworkResponse> updateDeviceToken(Map<String, dynamic> data) async {
    return await _api.updateDeviceToken(data);
  }

  Future<NetworkResponse> refreshToken(Map<String, dynamic> data) async {
    return await _api.refreshToken(data);
  }

  Future<NetworkResponse> deleteAccount() async {
    return await _api.deleteAccount();
  }
}
