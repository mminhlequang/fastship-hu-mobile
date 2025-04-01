import 'package:internal_core/internal_core.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

class _RatingEndpoint {
  _RatingEndpoint._();
  // Product Rating
  static String getProductRatings() => "/api/v1/rating/get_rating_product";
  static String insertProductRating() => "/api/v1/rating/insert_rating_product";
  static String replyProductRating() => "/api/v1/rating/reply_rating_product";

  // Store Rating
  static String getStoreRatings() => "/api/v1/rating/get_rating_store";
  static String insertStoreRating() => "/api/v1/rating/insert_rating_store";
  static String replyStoreRating() => "/api/v1/rating/reply_rating_store";

  // Driver Rating
  static String getDriverRatings() => "/api/v1/rating/get_rating_driver";
  static String insertDriverRating() => "/api/v1/rating/insert_rating_driver";

  // Upload File
  static String uploadFile() => "/api/v1/rating/upload";
}

abstract class RatingApi {
  // Product Rating
  Future<NetworkResponse> getProductRatings(Map<String, dynamic> params);
  Future<NetworkResponse> insertProductRating(Map<String, dynamic> data);
  Future<NetworkResponse> replyProductRating(Map<String, dynamic> data);

  // Store Rating
  Future<NetworkResponse> getStoreRatings(Map<String, dynamic> params);
  Future<NetworkResponse> insertStoreRating(Map<String, dynamic> data);
  Future<NetworkResponse> replyStoreRating(Map<String, dynamic> data);

  // Driver Rating
  Future<NetworkResponse> getDriverRatings(Map<String, dynamic> params);
  Future<NetworkResponse> insertDriverRating(Map<String, dynamic> data);

  // Upload File
  Future<NetworkResponse> uploadFile(dynamic filePath);
}

class RatingApiImp extends RatingApi {
  @override
  Future<NetworkResponse> getProductRatings(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_RatingEndpoint.getProductRatings(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List).map((e) => RatingModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> insertProductRating(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_RatingEndpoint.insertProductRating(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => RatingModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> replyProductRating(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_RatingEndpoint.replyProductRating(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => RatingModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getStoreRatings(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_RatingEndpoint.getStoreRatings(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List).map((e) => RatingModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> insertStoreRating(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_RatingEndpoint.insertStoreRating(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => RatingModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> replyStoreRating(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_RatingEndpoint.replyStoreRating(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => RatingModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getDriverRatings(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_RatingEndpoint.getDriverRatings(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List).map((e) => RatingModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> insertDriverRating(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_RatingEndpoint.insertDriverRating(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => RatingModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> uploadFile(dynamic filePath) async {
    return await handleNetworkError(
      proccess: () async {
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(filePath, filename: filePath),
        });
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_RatingEndpoint.uploadFile(), data: formData);
        return NetworkResponse.fromResponse(response);
      },
    );
  }
}
