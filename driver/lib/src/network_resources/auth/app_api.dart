import 'package:app/src/utils/utils.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

class _MyAppEndpoint {
  _MyAppEndpoint._();
  static String register() => "/api/v1/register";
  static String login() => "/api/v1/login";
  static String updatePassword() => "/api/v1/update_password";
  static String resetPassword() => "/api/v1/reset_password";
  static String profile() => "/api/v1/profile";
  static String updateProfile() => "/api/v1/update_profile";
  static String checkPhone() => "/api/v1/check_phone";
  static String updateDeviceToken() => "/api/v1/update_device_token";
  static String refreshToken() => "/api/v1/refresh_token";
  static String deleteAccount() => "/api/v1/delete_account";
}

abstract class MyAppApi {
  Future<NetworkResponse> register(Map<String, dynamic> data);
  Future<NetworkResponse> login(Map<String, dynamic> data);
  Future<NetworkResponse> updatePassword(Map<String, dynamic> data);
  Future<NetworkResponse> resetPassword(Map<String, dynamic> data);
  Future<NetworkResponse> getProfile();
  Future<NetworkResponse> updateProfile(Map<String, dynamic> data);
  Future<NetworkResponse> checkPhone(Map<String, dynamic> data);
  Future<NetworkResponse> updateDeviceToken(Map<String, dynamic> data);
  Future<NetworkResponse> refreshToken(Map<String, dynamic> data);
  Future<NetworkResponse> deleteAccount();
}

class MyAppApiImp extends MyAppApi {
  @override
  Future<NetworkResponse> register(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response =
            await AppClient().post(_MyAppEndpoint.register(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => ResponseLogin.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> login(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response =
            await AppClient().post(_MyAppEndpoint.login(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => ResponseLogin.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> updatePassword(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response =
            await AppClient().post(_MyAppEndpoint.updatePassword(), data: data);
        return NetworkResponse.fromResponse(response);
      },
    );
  }

  @override
  Future<NetworkResponse> resetPassword(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response =
            await AppClient().post(_MyAppEndpoint.resetPassword(), data: data);
        return NetworkResponse.fromResponse(response);
      },
    );
  }

  @override
  Future<NetworkResponse> getProfile() async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_MyAppEndpoint.profile());
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => AccountModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> updateProfile(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response =
            await AppClient().post(_MyAppEndpoint.updateProfile(), data: data);
        return NetworkResponse.fromResponse(response);
      },
    );
  }

  @override
  Future<NetworkResponse> checkPhone(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response =
            await AppClient().post(_MyAppEndpoint.checkPhone(), data: data);
        return NetworkResponse.fromResponse(response);
      },
    );
  }

  @override
  Future<NetworkResponse> updateDeviceToken(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient()
            .post(_MyAppEndpoint.updateDeviceToken(), data: data);
        return NetworkResponse.fromResponse(response);
      },
    );
  }

  @override
  Future<NetworkResponse> refreshToken(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response =
            await AppClient().post(_MyAppEndpoint.refreshToken(), data: data);
        return NetworkResponse.fromResponse(response);
      },
    );
  }

  @override
  Future<NetworkResponse> deleteAccount() async {
    return await handleNetworkError(
      proccess: () async {
        Response response =
            await AppClient().post(_MyAppEndpoint.deleteAccount());
        return NetworkResponse.fromResponse(response);
      },
    );
  }
}
