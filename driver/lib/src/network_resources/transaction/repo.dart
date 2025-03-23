import 'package:internal_network/network_resources/resources.dart';

import 'app_api.dart';

class TransactionRepo {
  TransactionRepo._();

  static TransactionRepo? _instance;

  factory TransactionRepo([MyAppApi? api]) {
    _instance ??= TransactionRepo._();
    _instance!._api = api ?? MyAppApiImp();
    return _instance!;
  }

  late MyAppApi _api;

  Future<NetworkResponse> getTransactions() async {
    return await _api.getTransactions();
  }

  Future<NetworkResponse> getTransactionDetail(String id) async {
    return await _api.getTransactionDetail(id);
  }

  Future<NetworkResponse> requestTopUp(Map<String, dynamic> data) async {
    return await _api.requestTopUp(data);
  }

  Future<NetworkResponse> requestWithdraw(Map<String, dynamic> data) async {
    return await _api.requestWithdraw(data);
  }

  Future<NetworkResponse> getMyWallet(Map<String, dynamic> data) async {
    return await _api.getMyWallet(data);
  }

  Future<NetworkResponse> getPaymentWalletProvider() async {
    return await _api.getPaymentWalletProvider();
  }

  Future<NetworkResponse> getPaymentAccounts() async {
    return await _api.getPaymentAccounts();
  }

  Future<NetworkResponse> createPaymentAccounts(Map<String, dynamic> data) async {
    return await _api.createPaymentAccounts(data);
  }

  Future<NetworkResponse> updatePaymentAccounts(Map<String, dynamic> data) async {
    return await _api.updatePaymentAccounts(data);
  }

  Future<NetworkResponse> deletePaymentAccounts(Map<String, dynamic> data) async {
    return await _api.deletePaymentAccounts(data);
  }
}
