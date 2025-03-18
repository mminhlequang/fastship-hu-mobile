import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';

class MerchantRepo {
  MerchantRepo._();

  static MerchantRepo? _instance;

  factory MerchantRepo([MyAppApi? api]) {
    _instance ??= MerchantRepo._();
    _instance!._api = api ?? MyAppApiImp();
    return _instance!;
  }

  late MyAppApi _api;

  Future<NetworkResponse> updateProfile(Map<String, dynamic> data) async {
    return await _api.updateProfile(data);
  }

  Future<NetworkResponse> uploadFile(String filePath, String type) async {
    return await _api.uploadFile(filePath, type);
  }
}
