
class MyWallet {
  num? availableBalance;
  num? frozenBalance;
  String? currency;

  MyWallet({this.availableBalance, this.frozenBalance, this.currency});

  MyWallet.fromJson(Map<String, dynamic> json) {
    if (json["available_balance"] is num) {
      availableBalance = json["available_balance"];
    }
    if (json["frozen_balance"] is num) {
      frozenBalance = json["frozen_balance"];
    }
    if(json["currency"] is String) {
      currency = json["currency"];
    }
  }

  static List<MyWallet> fromList(List<Map<String, dynamic>> list) {
    return list.map(MyWallet.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["available_balance"] = availableBalance;
    _data["frozen_balance"] = frozenBalance;
    _data["currency"] = currency;
    return _data;
  }
}