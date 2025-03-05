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

  Future<NetworkResponse> createPayment(Map<String, dynamic> data) async {
    return await _api.createPayment(data);
  }

  Future<NetworkResponse> withdrawal(Map<String, dynamic> data) async {
    return await _api.withdrawal(data);
  }

  Future<NetworkResponse> confirmPayment(Map<String, dynamic> data) async {
    return await _api.confirmPayment(data);
  }
}
