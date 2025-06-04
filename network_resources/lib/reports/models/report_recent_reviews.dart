
class ReportRecentReviewModel {
  String? reviewId;
  String? customerName;
  String? customerAvatar;
  int? rating;
  String? comment;
  String? createdAt;

  ReportRecentReviewModel({this.reviewId, this.customerName, this.customerAvatar, this.rating, this.comment, this.createdAt});

  ReportRecentReviewModel.fromJson(Map<String, dynamic> json) {
    if(json["review_id"] is String) {
      reviewId = json["review_id"];
    }
    if(json["customer_name"] is String) {
      customerName = json["customer_name"];
    }
    if(json["customer_avatar"] is String) {
      customerAvatar = json["customer_avatar"];
    }
    if(json["rating"] is int) {
      rating = json["rating"];
    }
    if(json["comment"] is String) {
      comment = json["comment"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<ReportRecentReviewModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(ReportRecentReviewModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["review_id"] = reviewId;
    _data["customer_name"] = customerName;
    _data["customer_avatar"] = customerAvatar;
    _data["rating"] = rating;
    _data["comment"] = comment;
    _data["created_at"] = createdAt;
    return _data;
  }
}