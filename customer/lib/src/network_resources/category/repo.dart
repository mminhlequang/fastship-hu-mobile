import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';
import 'model/category.dart';

class CategoryRepo {
  CategoryRepo._();

  static CategoryRepo? _instance;

  factory CategoryRepo([CategoryApi? api]) {
    _instance ??= CategoryRepo._();
    _instance!._api = api ?? CategoryApiImp();
    return _instance!;
  }

  late CategoryApi _api;

  Future<NetworkResponse> getCategories(Map<String, dynamic> params) async {
    return await _api.getCategories(params);
  }
}
