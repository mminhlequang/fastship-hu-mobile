import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'model/category.dart';

class _CategoryEndpoint {
  _CategoryEndpoint._();
  static String getCategories() => "/api/v1/categories/get_categories";
}

abstract class CategoryApi {
  Future<NetworkResponse> getCategories(Map<String, dynamic> params);
}

class CategoryApiImp extends CategoryApi {
  @override
  Future<NetworkResponse> getCategories(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response =
            await AppClient().get(_CategoryEndpoint.getCategories(), queryParameters: params);
        return NetworkResponse.fromResponse(response,
            converter: (json) =>
                (json as List).map((e) => CategoryModel.fromJson(e)).toList());
      },
    );
  }
}
