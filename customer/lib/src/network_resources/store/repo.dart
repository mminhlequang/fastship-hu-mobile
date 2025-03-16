import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';
import 'model/store.dart';

class StoreRepo {
  StoreRepo._();

  static StoreRepo? _instance;

  factory StoreRepo([StoreApi? api]) {
    _instance ??= StoreRepo._();
    _instance!._api = api ?? StoreApiImp();
    return _instance!;
  }

  late StoreApi _api;

  Future<List<Store>?> getStores() async {
    NetworkResponse response = await _api.getStores();
    return response.data;
  }
}
