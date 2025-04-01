import 'package:network_resources/category/model/category.dart';

class StoreModel {
  int? id;
  String? name;
  String? phone;
  String? contactType;
  String? contactFullName;
  String? contactCompany;
  String? contactCompanyAddress;
  String? contactPhone;
  String? contactEmail;
  String? contactCardId;
  String? contactCardIdIssueDate;
  String? contactCardIdImageFront;
  String? contactCardIdImageBack;
  String? contactTax;
  String? avatarImage;
  String? facadeImage;
  int? rating;
  int? isOpen;
  List<OperatingHours>? operatingHours;
  List<BannerImages>? bannerImages;
  List<CategoryModel>? categories;
  List<ContactDocuments>? contactDocuments;
  String? address;
  String? street;
  String? zip;
  String? city;
  String? state;
  String? country;
  String? countryCode;
  double? lat;
  double? lng;
  int? isFavorite;
  int? active;
  String? createdAt;

  StoreModel({
    this.id,
    this.name,
    this.phone,
    this.contactType,
    this.contactFullName,
    this.contactCompany,
    this.contactCompanyAddress,
    this.contactPhone,
    this.contactEmail,
    this.contactCardId,
    this.contactCardIdIssueDate,
    this.contactCardIdImageFront,
    this.contactCardIdImageBack,
    this.contactTax,
    this.avatarImage,
    this.facadeImage,
    this.rating,
    this.isOpen,
    this.operatingHours,
    this.categories,
    this.bannerImages,
    this.contactDocuments,
    this.address,
    this.street,
    this.zip,
    this.city,
    this.state,
    this.country,
    this.countryCode,
    this.lat,
    this.lng,
    this.isFavorite,
    this.active,
    this.createdAt,
  });

  StoreModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["phone"] is String) {
      phone = json["phone"];
    }
    if (json["contact_type"] is String) {
      contactType = json["contact_type"];
    }
    if (json["contact_full_name"] is String) {
      contactFullName = json["contact_full_name"];
    }
    if (json["contact_company"] is String) {
      contactCompany = json["contact_company"];
    }
    if (json["contact_company_address"] is String) {
      contactCompanyAddress = json["contact_company_address"];
    }
    if (json["contact_phone"] is String) {
      contactPhone = json["contact_phone"];
    }
    if (json["contact_email"] is String) {
      contactEmail = json["contact_email"];
    }
    if (json["contact_card_id"] is String) {
      contactCardId = json["contact_card_id"];
    }
    if (json["contact_card_id_issue_date"] is String) {
      contactCardIdIssueDate = json["contact_card_id_issue_date"];
    }
    if (json["contact_card_id_image_front"] is String) {
      contactCardIdImageFront = json["contact_card_id_image_front"];
    }
    if (json["contact_card_id_image_back"] is String) {
      contactCardIdImageBack = json["contact_card_id_image_back"];
    }
    if (json["contact_tax"] is String) {
      contactTax = json["contact_tax"];
    }
    if (json["avatar_image"] is String) {
      avatarImage = json["avatar_image"];
    }
    if (json["facade_image"] is String) {
      facadeImage = json["facade_image"];
    }
    if (json["rating"] is int) {
      rating = json["rating"];
    }
    if (json["is_open"] is int) {
      isOpen = json["is_open"];
    }
    if (json["categories"] is List) {
      categories =
          json["categories"] == null
              ? null
              : (json["categories"] as List)
                  .map((e) => CategoryModel.fromJson(e))
                  .toList();
    }
    if (json["operating_hours"] is List) {
      operatingHours =
          json["operating_hours"] == null
              ? null
              : (json["operating_hours"] as List)
                  .map((e) => OperatingHours.fromJson(e))
                  .toList();
    }
    if (json["banner_images"] is List) {
      bannerImages =
          json["banner_images"] == null
              ? null
              : (json["banner_images"] as List)
                  .map((e) => BannerImages.fromJson(e))
                  .toList();
    }
    if (json["contact_documents"] is List) {
      contactDocuments =
          json["contact_documents"] == null
              ? null
              : (json["contact_documents"] as List)
                  .map((e) => ContactDocuments.fromJson(e))
                  .toList();
    }
    if (json["address"] is String) {
      address = json["address"];
    }
    if (json["street"] is String) {
      street = json["street"];
    }
    if (json["zip"] is String) {
      zip = json["zip"];
    }
    if (json["city"] is String) {
      city = json["city"];
    }
    if (json["state"] is String) {
      state = json["state"];
    }
    if (json["country"] is String) {
      country = json["country"];
    }
    if (json["country_code"] is String) {
      countryCode = json["country_code"];
    }
    if (json["lat"] is double) {
      lat = json["lat"];
    }
    if (json["lng"] is double) {
      lng = json["lng"];
    }
    if (json["is_favorite"] is int) {
      isFavorite = json["is_favorite"];
    }
    if (json["active"] is int) {
      active = json["active"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
  }

  static List<StoreModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(StoreModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["phone"] = phone;
    _data["contact_type"] = contactType;
    _data["contact_full_name"] = contactFullName;
    _data["contact_company"] = contactCompany;
    _data["contact_company_address"] = contactCompanyAddress;
    _data["contact_phone"] = contactPhone;
    _data["contact_email"] = contactEmail;
    _data["contact_card_id"] = contactCardId;
    _data["contact_card_id_issue_date"] = contactCardIdIssueDate;
    _data["contact_card_id_image_front"] = contactCardIdImageFront;
    _data["contact_card_id_image_back"] = contactCardIdImageBack;
    _data["contact_tax"] = contactTax;
    _data["avatar_image"] = avatarImage;
    _data["facade_image"] = facadeImage;
    _data["rating"] = rating;
    _data["is_open"] = isOpen;
    if (categories != null) {
      _data["categories"] = categories?.map((e) => e.toJson()).toList();
    }
    if (operatingHours != null) {
      _data["operating_hours"] =
          operatingHours?.map((e) => e.toJson()).toList();
    }
    if (bannerImages != null) {
      _data["banner_images"] = bannerImages?.map((e) => e.toJson()).toList();
    }
    if (contactDocuments != null) {
      _data["contact_documents"] =
          contactDocuments?.map((e) => e.toJson()).toList();
    }
    _data["address"] = address;
    _data["street"] = street;
    _data["zip"] = zip;
    _data["city"] = city;
    _data["state"] = state;
    _data["country"] = country;
    _data["country_code"] = countryCode;
    _data["lat"] = lat;
    _data["lng"] = lng;
    _data["is_favorite"] = isFavorite;
    _data["active"] = active;
    _data["created_at"] = createdAt;
    return _data;
  }
}

class ContactDocuments {
  int? id;
  String? image;

  ContactDocuments({this.id, this.image});

  ContactDocuments.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["image"] is String) {
      image = json["image"];
    }
  }

  static List<ContactDocuments> fromList(List<Map<String, dynamic>> list) {
    return list.map(ContactDocuments.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["image"] = image;
    return _data;
  }
}

class BannerImages {
  int? id;
  String? image;

  BannerImages({this.id, this.image});

  BannerImages.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["image"] is String) {
      image = json["image"];
    }
  }

  static List<BannerImages> fromList(List<Map<String, dynamic>> list) {
    return list.map(BannerImages.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["image"] = image;
    return _data;
  }
}

class OperatingHours {
  int? day;
  int? isOff;
  String? startTime;
  String? endTime;

  OperatingHours({this.day, this.isOff, this.startTime, this.endTime});

  OperatingHours.fromJson(Map<String, dynamic> json) {
    if (json["day"] is int) {
      day = json["day"];
    }
    if (json["start_time"] is String) {
      startTime = json["start_time"];
    }
    if (json["end_time"] is String) {
      endTime = json["end_time"];
    }
    if (json["is_off"] is int) {
      isOff = json["is_off"];
    }
  }

  static List<OperatingHours> fromList(List<Map<String, dynamic>> list) {
    return list.map(OperatingHours.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["day"] = day;
    _data["start_time"] = startTime;
    _data["end_time"] = endTime;
    _data["is_off"] = isOff;
    return _data;
  }
}
