import 'package:app/src/utils/utils.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

class _MyAppEndpoint {
  _MyAppEndpoint._();
  static String transaction() => "/api/v1/transaction";
  static String transactionDetail() => "/api/v1/transaction/detail";
  static String requestTopUp() => "/api/v1/transaction/request_topup";
  static String requestWithdraw() => "/api/v1/transaction/request_withdraw";
}

abstract class MyAppApi {
  Future<NetworkResponse> getTransactions();
  Future<NetworkResponse> getTransactionDetail(String id);
  Future<NetworkResponse> requestTopUp(Map<String, dynamic> data);
  Future<NetworkResponse> requestWithdraw(Map<String, dynamic> data);
}

class MyAppApiImp extends MyAppApi {
  @override
  Future<NetworkResponse> getTransactions() async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get(_MyAppEndpoint.transaction());
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => (json as List)
              .map((e) => TransactionModel.fromJson(e))
              .toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getTransactionDetail(String id) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).get('${_MyAppEndpoint.transactionDetail()}/$id');
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => TransactionModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> requestTopUp(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.requestTopUp(), data: data);
        return NetworkResponse.fromResponse(
          response,
        );
      },
    );
  }

  @override
  Future<NetworkResponse> requestWithdraw(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.requestWithdraw(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => TransactionModel.fromJson(json),
        );
      },
    );
  }
}
