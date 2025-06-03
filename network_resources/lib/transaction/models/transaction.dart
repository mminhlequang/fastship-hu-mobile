enum TransactionType {
  deposit,
  withdraw,
  order,
  refund,
  other;

}

class TransactionModel {
  int? id;
  String? code;
  int? userId;
  num? amount;
  num? price;
  String? currency;
  dynamic order;
  String? description;
  String? paymentMethod;
  String? type;
  String? status;
  String? note;
  String? paidDate;
  String? createdAt;
  String? updatedAt;

  TransactionType get typeEnum {
    switch (type) {
      case 'deposit':
        return TransactionType.deposit;
      case 'withdraw':
        return TransactionType.withdraw;
      case 'order':
        return TransactionType.order;
      case 'refund':
        return TransactionType.refund;
      default:
        return TransactionType.other;
    }
  }

  TransactionModel({
    this.id,
    this.code,
    this.userId,
    this.amount,
    this.price,
    this.currency,
    this.order,
    this.description,
    this.paymentMethod,
    this.type,
    this.status,
    this.note,
    this.paidDate,
    this.createdAt,
    this.updatedAt,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    userId = json['user_id'];
    amount = json['amount'];
    price = json['price'];
    currency = json['currency'];
    order = json['order'];
    description = json['description'];
    paymentMethod = json['payment_method'];
    type = json['type'];
    status = json['status'];
    note = json['note'];
    paidDate = json['paid_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['user_id'] = userId;
    data['amount'] = amount;
    data['price'] = price;
    data['currency'] = currency;
    data['order'] = order;
    data['description'] = description;
    data['payment_method'] = paymentMethod;
    data['type'] = type;
    data['status'] = status;
    data['note'] = note;
    data['paid_date'] = paidDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
