import 'payment_provider.dart';

class PaymentAccount {
  int? id;
  String? accountType;
  String? accountNumber;
  String? accountName;
  String? bankName;
  String? currency;
  int? paymentWalletProviderId;
  PaymentWalletProvider? paymentWalletProvider;
  int? isVerified;
  int? isDefault;

  PaymentAccount(
      {this.id,
      this.accountType,
      this.accountNumber,
      this.accountName,
      this.bankName,
      this.paymentWalletProviderId,
      this.paymentWalletProvider,
      this.isVerified,
      this.isDefault,
      this.currency});

  PaymentAccount.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["account_type"] is String) {
      accountType = json["account_type"];
    }
    if (json["account_number"] is String) {
      accountNumber = json["account_number"];
    }
    if (json["account_name"] is String) {
      accountName = json["account_name"];
    }
    if (json["bank_name"] is String) {
      bankName = json["bank_name"];
    }
    if (json["payment_wallet_provider_provider_id"] is int) {
      paymentWalletProviderId = json["payment_wallet_provider_provider_id"];
    }
    if (json["is_verified"] is int) {
      isVerified = json["is_verified"];
    }
    if (json["currency"] is String) {
      currency = json["currency"];
    }
    if (json["payment_wallet_provider"] is Map<String, dynamic>) {
      paymentWalletProvider =
          PaymentWalletProvider.fromJson(json["payment_wallet_provider"]);
    }
    if (json["is_default"] is int) {
      isDefault = json["is_default"];
    }
  }

  static List<PaymentAccount> fromList(List<Map<String, dynamic>> list) {
    return list.map(PaymentAccount.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["account_type"] = accountType;
    _data["account_number"] = accountNumber;
    _data["account_name"] = accountName;
    _data["bank_name"] = bankName;
    _data["payment_wallet_provider_provider_id"] = paymentWalletProviderId;
    _data["is_verified"] = isVerified;
    _data["is_default"] = isDefault;
    _data["currency"] = currency;
    _data["payment_wallet_provider"] = paymentWalletProvider?.toJson();
    return _data;
  }
}
