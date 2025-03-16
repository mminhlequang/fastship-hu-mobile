import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'model/store.dart';

class _StoreEndpoint {
  _StoreEndpoint._();
  static String getStores() => "/api/v1/store/get_stores";
}

abstract class StoreApi {
  Future<NetworkResponse> getStores();
}

class StoreApiImp extends StoreApi {
  @override
  Future<NetworkResponse> getStores() async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient().get(_StoreEndpoint.getStores());
        return NetworkResponse.fromResponse(response,
            converter: (json) =>
                (json as List).map((e) => Store.fromJson(e)).toList());
      },
    );
  }
}
