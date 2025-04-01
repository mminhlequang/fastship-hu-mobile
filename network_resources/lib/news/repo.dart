import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';

class NewsRepo {
  NewsRepo._();

  static NewsRepo? _instance;

  factory NewsRepo([NewsApi? api]) {
    _instance ??= NewsRepo._();
    _instance!._api = api ?? NewsApiImp();
    return _instance!;
  }

  late NewsApi _api;

  Future<NetworkResponse> getNews(Map<String, dynamic> params) async {
    return await _api.getNews(params);
  }

  Future<NetworkResponse> getNewsDetail(int id) async {
    return await _api.getNewsDetail(id);
  }
}
