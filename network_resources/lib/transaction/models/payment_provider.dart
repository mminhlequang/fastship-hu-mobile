class PaymentWalletProvider {
  int? id;
  String? name;
  String? iconUrl;
  int? isActive;

  PaymentWalletProvider({this.id, this.name, this.iconUrl, this.isActive});

  PaymentWalletProvider.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["is_active"] is int) {
      isActive = json["is_active"];
    }
    if (json["icon_url"] is String) {
      iconUrl = json["icon_url"];
    }
  }

  static List<PaymentWalletProvider> fromList(List<Map<String, dynamic>> list) {
    return list.map(PaymentWalletProvider.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["icon_url"] = iconUrl;
    _data["is_active"] = isActive;
    return _data;
  }
}
