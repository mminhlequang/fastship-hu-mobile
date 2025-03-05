class TransactionModel {
  int? id;
  String? code;
  int? userId;
  int? amount;
  String? type;
  String? status;
  String? note;
  String? createdAt;
  String? updatedAt;

  TransactionModel({
    this.id,
    this.code,
    this.userId,
    this.amount,
    this.type,
    this.status,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    userId = json['user_id'];
    amount = json['amount'];
    type = json['type'];
    status = json['status'];
    note = json['note'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['user_id'] = userId;
    data['amount'] = amount;
    data['type'] = type;
    data['status'] = status;
    data['note'] = note;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
