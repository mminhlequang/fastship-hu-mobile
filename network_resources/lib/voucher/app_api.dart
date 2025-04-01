import 'package:internal_core/internal_core.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

class _MyAppEndpoint {
  _MyAppEndpoint._();
  static String getVouchers() => "/api/v1/voucher/get_vouchers";
  static String getSavedVouchers() => "/api/v1/voucher/get_vouchers_user_saved";
  static String createVoucher() => "/api/v1/voucher/create";
  static String updateVoucher() => "/api/v1/voucher/update";
  static String saveVoucher() => "/api/v1/voucher/save";
  static String deleteVoucher() => "/api/v1/voucher/delete";
  static String checkVoucher() => "/api/v1/voucher/check";
}

abstract class MyAppApi {
  Future<NetworkResponse> getVouchers(Map<String, dynamic> params);
  Future<NetworkResponse> getSavedVouchers(Map<String, dynamic> params);
  Future<NetworkResponse> createVoucher(Map<String, dynamic> data);
  Future<NetworkResponse> updateVoucher(Map<String, dynamic> data);
  Future<NetworkResponse> saveVoucher(int id);
  Future<NetworkResponse> deleteVoucher(int id);
  Future<NetworkResponse> checkVoucher(Map<String, dynamic> data);
}

class MyAppApiImp extends MyAppApi {
  @override
  Future<NetworkResponse> getVouchers(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_MyAppEndpoint.getVouchers(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List).map((e) => VoucherModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getSavedVouchers(Map<String, dynamic> params) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_MyAppEndpoint.getSavedVouchers(), queryParameters: params);
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List).map((e) => VoucherModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> createVoucher(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_MyAppEndpoint.createVoucher(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => VoucherModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> updateVoucher(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_MyAppEndpoint.updateVoucher(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => VoucherModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> saveVoucher(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_MyAppEndpoint.saveVoucher(), data: {'id': id});
        return NetworkResponse.fromResponse(response);
      },
    );
  }

  @override
  Future<NetworkResponse> deleteVoucher(int id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_MyAppEndpoint.deleteVoucher(), data: {'id': id});
        return NetworkResponse.fromResponse(response);
      },
    );
  }

  @override
  Future<NetworkResponse> checkVoucher(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_MyAppEndpoint.checkVoucher(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => VoucherModel.fromJson(json),
        );
      },
    );
  }
}
