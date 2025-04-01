import 'package:internal_core/internal_core.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

class _NewsEndpoint {
  _NewsEndpoint._();
  static String getNews() => "/api/v1/news/get_news";
  static String getNewsDetail() => "/api/news/detail";
}

abstract class NewsApi {
  Future<NetworkResponse> getNews(Map<String, dynamic> params);
  Future<NetworkResponse> getNewsDetail(int id);
}

class NewsApiImp extends NewsApi {
  @override
  Future<NetworkResponse> getNews(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_NewsEndpoint.getNews(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List).map((e) => NewsModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getNewsDetail(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_NewsEndpoint.getNewsDetail(), queryParameters: {'id': id});
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => NewsModel.fromJson(json),
        );
      },
    );
  }
}
