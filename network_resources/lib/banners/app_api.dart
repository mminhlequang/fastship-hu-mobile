import 'package:internal_core/internal_core.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

class _BannersEndpoint {
  _BannersEndpoint._();
  static String getBanners() => "/api/v1/banners";
}

abstract class BannersApi {
  Future<NetworkResponse> getBanners(Map<String, dynamic> params);
}

class BannersApiImp extends BannersApi {
  @override
  Future<NetworkResponse> getBanners(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_BannersEndpoint.getBanners(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List).map((e) => BannerModel.fromJson(e)).toList(),
        );
      },
    );
  }
}
