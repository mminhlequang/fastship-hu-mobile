import 'package:app/src/utils/utils.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import '../auth/models/models.dart';
import 'models/models.dart';

class _MyAppEndpoint {
  _MyAppEndpoint._();
  static String updateProfile() => "/api/v1/driver/update_profile";
  static String upload() => "/api/v1/driver/upload";
}

abstract class MyAppApi {
  Future<NetworkResponse> updateProfile(Map<String, dynamic> data);
  Future<NetworkResponse> uploadFile(String filePath, String type);
}

class MyAppApiImp extends MyAppApi {
  @override
  Future<NetworkResponse> updateProfile(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.updateProfile(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => AccountModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> uploadFile(String filePath, String type) async {
    return await handleNetworkError(
      proccess: () async {
        FormData formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(filePath, filename: filePath),
          'type': type,
        });

        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.upload(), data: formData);
        return NetworkResponse.fromResponse(response);
      },
    );
  }
}
