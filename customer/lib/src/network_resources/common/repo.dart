import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';
import 'model/banner.dart';
import 'model/config.dart';
import 'model/category.dart';
import 'model/shop.dart';
import 'model/food.dart';

class CommonRepo {
  CommonRepo._();

  static CommonRepo? _instance;

  factory CommonRepo([CommonApi? api]) {
    _instance ??= CommonRepo._();
    _instance!._api = api ?? CommonApiImp();
    return _instance!;
  }

  late CommonApi _api;

  Future<List<Banner>?> getBanners() async {
    NetworkResponse response = await _api.getBanners();
    return response.data;
  }

  Future<Config?> getConfig() async {
    NetworkResponse response = await _api.getConfig();
    return response.data;
  }

  Future<List<Category>?> getCategories() async {
    NetworkResponse response = await _api.getCategories();
    return response.data;
  }

  Future<List<Shop>?> getShops() async {
    NetworkResponse response = await _api.getShops();
    return response.data;
  }

  Future<List<Food>?> getFoods() async {
    NetworkResponse response = await _api.getFoods();
    return response.data;
  }
}
