import 'package:internal_core/internal_core.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

class _MyAppEndpoint {
  _MyAppEndpoint._();
  static String getServices() => "/api/v1/get_services";
}

abstract class MyAppApi {
  Future<NetworkResponse> getServices(Map<String, dynamic> params);
}

class MyAppApiImp extends MyAppApi {
  @override
  Future<NetworkResponse> getServices(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_MyAppEndpoint.getServices(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List).map((e) => ServiceModel.fromJson(e)).toList(),
        );
      },
    );
  }
}
