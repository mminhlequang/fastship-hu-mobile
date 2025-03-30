import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';

class BannersRepo {
  BannersRepo._();

  static BannersRepo? _instance;

  factory BannersRepo([BannersApi? api]) {
    _instance ??= BannersRepo._();
    _instance!._api = api ?? BannersApiImp();
    return _instance!;
  }

  late BannersApi _api;

  Future<NetworkResponse> getBanners() async {
    return await _api.getBanners();
  }
}
