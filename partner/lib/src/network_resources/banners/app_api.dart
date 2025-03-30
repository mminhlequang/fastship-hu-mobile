import 'package:app/src/utils/utils.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

class _BannersEndpoint {
  _BannersEndpoint._();
  static String getBanners() => "/api/v1/banners";
}

abstract class BannersApi {
  Future<NetworkResponse> getBanners();
}

class BannersApiImp extends BannersApi {
  @override
  Future<NetworkResponse> getBanners() async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_BannersEndpoint.getBanners());
        return NetworkResponse.fromResponse(
          response,
          converter: (json) =>
              (json as List).map((e) => BannerModel.fromJson(e)).toList(),
        );
      },
    );
  }
}
