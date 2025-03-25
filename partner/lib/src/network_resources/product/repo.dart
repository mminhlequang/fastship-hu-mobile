import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';
import 'model/product.dart';

class ProductRepo {
  ProductRepo._();

  static ProductRepo? _instance;

  factory ProductRepo([ProductApi? api]) {
    _instance ??= ProductRepo._();
    _instance!._api = api ?? ProductApiImp();
    return _instance!;
  }

  late ProductApi _api;

  Future<List<Product>?> getProducts() async {
    NetworkResponse response = await _api.getProducts();
    return response.data;
  }
}
