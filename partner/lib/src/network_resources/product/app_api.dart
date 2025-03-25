import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'model/product.dart';

class _ProductEndpoint {
  _ProductEndpoint._();
  static String getProducts() => "/api/v1/product/get_products";
}

abstract class ProductApi {
  Future<NetworkResponse> getProducts();
}

class ProductApiImp extends ProductApi {
  @override
  Future<NetworkResponse> getProducts() async {
    return await handleNetworkError(
      proccess: () async {
        Response response =
            await AppClient().get(_ProductEndpoint.getProducts());
        return NetworkResponse.fromResponse(response,
            converter: (json) =>
                (json as List).map((e) => Product.fromJson(e)).toList());
      },
    );
  }
}
