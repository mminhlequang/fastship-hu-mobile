import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';

class ServiceRepo {
  ServiceRepo._();

  static ServiceRepo? _instance;

  factory ServiceRepo([MyAppApi? api]) {
    _instance ??= ServiceRepo._();
    _instance!._api = api ?? MyAppApiImp();
    return _instance!;
  }

  late MyAppApi _api;

  Future<NetworkResponse> getServices(Map<String, dynamic> params) async {
    return await _api.getServices(params);
  }
 
}
