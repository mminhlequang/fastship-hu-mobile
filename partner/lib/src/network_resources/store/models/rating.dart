class RatingModel {
  int? id;
  int? userId;
  int? storeId;
  int? star;
  String? content;
  List<String>? images;
  List<String>? videos;
  List<ReplyModel>? replies;
  String? createdAt;
  String? updatedAt;
  UserModel? user;

  RatingModel({
    this.id,
    this.userId,
    this.storeId,
    this.star,
    this.content,
    this.images,
    this.videos,
    this.replies,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  RatingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    storeId = json['store_id'];
    star = json['star'];
    content = json['content'];
    images = json['images'] != null ? List<String>.from(json['images']) : null;
    videos = json['videos'] != null ? List<String>.from(json['videos']) : null;
    if (json['replies'] != null) {
      replies = <ReplyModel>[];
      json['replies'].forEach((v) {
        replies!.add(ReplyModel.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['store_id'] = storeId;
    data['star'] = star;
    data['content'] = content;
    data['images'] = images;
    data['videos'] = videos;
    if (replies != null) {
      data['replies'] = replies!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class ReplyModel {
  int? id;
  int? userId;
  int? ratingId;
  String? content;
  String? createdAt;
  String? updatedAt;
  UserModel? user;

  ReplyModel({
    this.id,
    this.userId,
    this.ratingId,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  ReplyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    ratingId = json['rating_id'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['rating_id'] = ratingId;
    data['content'] = content;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class UserModel {
  int? id;
  String? name;
  String? avatar;
  String? phone;
  String? email;

  UserModel({
    this.id,
    this.name,
    this.avatar,
    this.phone,
    this.email,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['avatar'] = avatar;
    data['phone'] = phone;
    data['email'] = email;
    return data;
  }
}
