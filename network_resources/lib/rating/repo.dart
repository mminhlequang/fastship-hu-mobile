import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';

class RatingRepo {
  RatingRepo._();

  static RatingRepo? _instance;

  factory RatingRepo([RatingApi? api]) {
    _instance ??= RatingRepo._();
    _instance!._api = api ?? RatingApiImp();
    return _instance!;
  }

  late RatingApi _api;

  // Product Rating
  Future<NetworkResponse> getProductRatings(Map<String, dynamic> params) async {
    return await _api.getProductRatings(params);
  }

  Future<NetworkResponse> insertProductRating(Map<String, dynamic> data) async {
    return await _api.insertProductRating(data);
  }

  Future<NetworkResponse> replyProductRating(Map<String, dynamic> data) async {
    return await _api.replyProductRating(data);
  }

  // Store Rating
  Future<NetworkResponse> getStoreRatings(Map<String, dynamic> params) async {
    return await _api.getStoreRatings(params);
  }

  Future<NetworkResponse> insertStoreRating(Map<String, dynamic> data) async {
    return await _api.insertStoreRating(data);
  }

  Future<NetworkResponse> replyStoreRating(Map<String, dynamic> data) async {
    return await _api.replyStoreRating(data);
  }

  // Driver Rating
  Future<NetworkResponse> getDriverRatings(Map<String, dynamic> params) async {
    return await _api.getDriverRatings(params);
  }

  Future<NetworkResponse> insertDriverRating(Map<String, dynamic> data) async {
    return await _api.insertDriverRating(data);
  }

  // Upload File
  Future<NetworkResponse> uploadFile(dynamic filePath) async {
    return await _api.uploadFile(filePath);
  }
}
