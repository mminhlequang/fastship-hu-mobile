import 'package:internal_core/internal_core.dart';
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
  static String getMyWallet() => "/api/v1/transaction/get_my_wallet";
  static String getPaymentWalletProvider() =>
      "/api/v1/transaction/get_payment_wallet_provider";
  static String getPaymentAccounts() =>
      "/api/v1/transaction/get_payment_accounts";
  static String createPaymentAccounts() =>
      "/api/v1/transaction/create_payment_accounts";
  static String updatePaymentAccounts() =>
      "/api/v1/transaction/update_payment_accounts";
  static String deletePaymentAccounts() =>
      "/api/v1/transaction/delete_payment_accounts";
}

abstract class MyAppApi {
  Future<NetworkResponse> getTransactions();
  Future<NetworkResponse> getTransactionDetail(String id);
  Future<NetworkResponse> requestTopUp(Map<String, dynamic> data);
  Future<NetworkResponse> requestWithdraw(Map<String, dynamic> data);
  Future<NetworkResponse> getMyWallet(Map<String, dynamic> data);
  Future<NetworkResponse> getPaymentWalletProvider();
  Future<NetworkResponse> getPaymentAccounts();
  Future<NetworkResponse> createPaymentAccounts(Map<String, dynamic> data);
  Future<NetworkResponse> updatePaymentAccounts(Map<String, dynamic> data);
  Future<NetworkResponse> deletePaymentAccounts(Map<String, dynamic> data);
}

class MyAppApiImp extends MyAppApi {
  @override
  Future<NetworkResponse> getTransactions() async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_MyAppEndpoint.transaction());
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List)
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
          token: await appPrefs.getNormalToken(),
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
          token: await appPrefs.getNormalToken(),
        ).post(_MyAppEndpoint.requestTopUp(), data: data);
        return NetworkResponse.fromResponse(response);
      },
    );
  }

  @override
  Future<NetworkResponse> requestWithdraw(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_MyAppEndpoint.requestWithdraw(), data: data);
        return NetworkResponse.fromResponse(
          response,
          value: response.data['status'] == true,
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getMyWallet(Map<String, dynamic> data) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_MyAppEndpoint.getMyWallet(), queryParameters: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => MyWallet.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getPaymentWalletProvider() async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_MyAppEndpoint.getPaymentWalletProvider());
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List)
                      .map((e) => PaymentWalletProvider.fromJson(e))
                      .toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> getPaymentAccounts() async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).get(_MyAppEndpoint.getPaymentAccounts());
        return NetworkResponse.fromResponse(
          response,
          converter:
              (json) =>
                  (json as List)
                      .map((e) => PaymentAccount.fromJson(e))
                      .toList(),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> createPaymentAccounts(
    Map<String, dynamic> data,
  ) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_MyAppEndpoint.createPaymentAccounts(), data: data);
        return NetworkResponse.fromResponse(
          response,
          converter: (json) => PaymentAccount.fromJson(json),
        );
      },
    );
  }

  @override
  Future<NetworkResponse> updatePaymentAccounts(
    Map<String, dynamic> data,
  ) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_MyAppEndpoint.updatePaymentAccounts(), data: data);
        return NetworkResponse.fromResponse(
          response,
          value: response.data['status'] == true,
        );
      },
    );
  }

  @override
  Future<NetworkResponse> deletePaymentAccounts(
    Map<String, dynamic> data,
  ) async {
    return await handleNetworkError(
      proccess: () async {
        Response response = await AppClient(
          token: await appPrefs.getNormalToken(),
        ).post(_MyAppEndpoint.deletePaymentAccounts(), data: data);
        return NetworkResponse.fromResponse(
          response,
          value: response.data['status'] == true,
        );
      },
    );
  }
}
