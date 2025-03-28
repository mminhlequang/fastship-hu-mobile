class RatingModel {
  int? id;
  int? productId;
  int? storeId;
  int? driverId;
  int? star;
  String? content;
  String? text;
  int? orderId;
  List<String>? images;
  List<String>? videos;
  String? replyContent;
  String? createdAt;
  String? updatedAt;

  RatingModel({
    this.id,
    this.productId,
    this.storeId,
    this.driverId,
    this.star,
    this.content,
    this.text,
    this.orderId,
    this.images,
    this.videos,
    this.replyContent,
    this.createdAt,
    this.updatedAt,
  });

  RatingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    storeId = json['store_id'];
    driverId = json['driver_id'];
    star = json['star'];
    content = json['content'];
    text = json['text'];
    orderId = json['order_id'];
    images = json['images']?.cast<String>();
    videos = json['videos']?.cast<String>();
    replyContent = json['reply_content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (productId != null) data['product_id'] = productId;
    if (storeId != null) data['store_id'] = storeId;
    if (driverId != null) data['driver_id'] = driverId;
    if (star != null) data['star'] = star;
    if (content != null) data['content'] = content;
    if (text != null) data['text'] = text;
    if (orderId != null) data['order_id'] = orderId;
    if (images != null) data['images'] = images;
    if (videos != null) data['videos'] = videos;
    if (replyContent != null) data['reply_content'] = replyContent;
    if (createdAt != null) data['created_at'] = createdAt;
    if (updatedAt != null) data['updated_at'] = updatedAt;
    return data;
  }
}
