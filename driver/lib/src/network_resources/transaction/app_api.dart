import 'package:app/src/utils/utils.dart';
import 'package:internal_network/internal_network.dart';
import 'package:internal_network/network_resources/resources.dart';
import 'package:dio/dio.dart';

import 'models/models.dart';

class _MyAppEndpoint {
  _MyAppEndpoint._();
  static String transaction() => "/api/v1/transaction";
  static String transactionDetail() => "/api/v1/transaction/detail";
  static String createPayment() => "/api/v1/transaction/create_payment";
  static String withdrawal() => "/api/v1/transaction/withdrawal";
  static String confirmPayment() => "/api/v1/transaction/confirm_payment";
}

abstract class MyAppApi {
  Future<NetworkResponse> getTransactions();
  Future<NetworkResponse> getTransactionDetail(String id);
  Future<NetworkResponse> createPayment(Map<String, dynamic> data);
  Future<NetworkResponse> withdrawal(Map<String, dynamic> data);
  Future<NetworkResponse> confirmPayment(Map<String, dynamic> data);
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
          converter: (json) => TransactionModel.fromJson(json),
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
  Future<NetworkResponse> createPayment(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.createPayment(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => TransactionModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> withdrawal(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.withdrawal(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => TransactionModel.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> confirmPayment(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await AppPrefs.instance.getNormalToken(),
        ).post(_MyAppEndpoint.confirmPayment(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => TransactionModel.fromJson(json),
        );
      },
    );
  }
}
