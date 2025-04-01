class ResponseLogin {
  String? accessToken;
  String? refreshToken;
  String? expiresIn;
  AccountModel? user;

  ResponseLogin(
      {this.accessToken, this.refreshToken, this.expiresIn, this.user});

  ResponseLogin.fromJson(Map<String, dynamic> json) {
    if (json["access_token"] is String) {
      accessToken = json["access_token"];
    }
    if (json["refresh_token"] is String) {
      refreshToken = json["refresh_token"];
    }
    if (json["expires_in"] is String) {
      expiresIn = json["expires_in"];
    }
    if (json["user"] is Map) {
      user = json["user"] == null ? null : AccountModel.fromJson(json["user"]);
    }
  }

  static List<ResponseLogin> fromList(List<Map<String, dynamic>> list) {
    return list.map(ResponseLogin.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["access_token"] = accessToken;
    _data["refresh_token"] = refreshToken;
    _data["expires_in"] = expiresIn;
    if (user != null) {
      _data["user"] = user?.toJson();
    }
    return _data;
  }
}

class ProfileModel {
  int? id;
  String? name;
  int? sex;
  dynamic birthday;
  dynamic codeIntroduce;
  String? address;
  dynamic cccd;
  dynamic cccdDate;
  dynamic imageCccdBefore;
  dynamic imageCccdAfter;
  dynamic addressTemp;
  dynamic isTaxCode;
  dynamic taxCode;
  dynamic paymentMethod;
  dynamic cardNumber;
  dynamic cardExpires;
  dynamic cardCvv;
  dynamic contacts;
  dynamic carId;
  dynamic license;
  dynamic imageLicenseBefore;
  dynamic imageLicenseAfter;
  int? stepId;

  ProfileModel({
    this.id,
    this.name,
    this.sex,
    this.birthday,
    this.codeIntroduce,
    this.address,
    this.cccd,
    this.cccdDate,
    this.imageCccdBefore,
    this.imageCccdAfter,
    this.addressTemp,
    this.isTaxCode,
    this.taxCode,
    this.paymentMethod,
    this.cardNumber,
    this.cardExpires,
    this.cardCvv,
    this.contacts,
    this.carId,
    this.license,
    this.imageLicenseBefore,
    this.imageLicenseAfter,
    this.stepId,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["sex"] is int) {
      sex = json["sex"];
    }
    birthday = json["birthday"];
    codeIntroduce = json["code_introduce"];
    if (json["address"] is String) {
      address = json["address"];
    }
    cccd = json["cccd"];
    cccdDate = json["cccd_date"];
    imageCccdBefore = json["image_cccd_before"];
    imageCccdAfter = json["image_cccd_after"];
    addressTemp = json["address_temp"];
    isTaxCode = json["is_tax_code"];
    taxCode = json["tax_code"];
    paymentMethod = json["payment_method"];
    cardNumber = json["card_number"];
    cardExpires = json["card_expires"];
    cardCvv = json["card_cvv"];
    contacts = json["contacts"];
    carId = json["car_id"];
    license = json["license"];
    imageLicenseBefore = json["image_license_before"];
    imageLicenseAfter = json["image_license_after"];
    if (json["step_id"] is int) {
      stepId = json["step_id"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["sex"] = sex;
    _data["birthday"] = birthday;
    _data["code_introduce"] = codeIntroduce;
    _data["address"] = address;
    _data["cccd"] = cccd;
    _data["cccd_date"] = cccdDate;
    _data["image_cccd_before"] = imageCccdBefore;
    _data["image_cccd_after"] = imageCccdAfter;
    _data["address_temp"] = addressTemp;
    _data["is_tax_code"] = isTaxCode;
    _data["tax_code"] = taxCode;
    _data["payment_method"] = paymentMethod;
    _data["card_number"] = cardNumber;
    _data["card_expires"] = cardExpires;
    _data["card_cvv"] = cardCvv;
    _data["contacts"] = contacts;
    _data["car_id"] = carId;
    _data["license"] = license;
    _data["image_license_before"] = imageLicenseBefore;
    _data["image_license_after"] = imageLicenseAfter;
    _data["step_id"] = stepId;
    return _data;
  }
}

class AccountModel {
  int? id;
  String? uid;
  String? name;
  String? avatar;
  String? phone;
  String? email;
  String? address;
  dynamic birthday;
  dynamic street;
  dynamic zip;
  dynamic city;
  dynamic state;
  dynamic country;
  dynamic countryCode;
  dynamic codeIntroduce;
  dynamic cccd;
  dynamic imageCccdBefore;
  dynamic imageCccdAfter;
  dynamic imageLicenseBefore;
  dynamic imageLicenseAfter;
  int? sex;
  dynamic lat;
  dynamic lng;
  int? rating;
  int? money;
  int? active;
  dynamic taxCode;
  int? isTaxCode;
  int? enabledNotify;
  dynamic car;
  dynamic deletedAt;
  dynamic deletedRequestAt;
  String? createdAt;
  ProfileModel? profile;

  AccountModel(
      {this.id,
      this.uid,
      this.name,
      this.avatar,
      this.phone,
      this.email,
      this.address,
      this.birthday,
      this.street,
      this.zip,
      this.city,
      this.state,
      this.country,
      this.countryCode,
      this.codeIntroduce,
      this.cccd,
      this.imageCccdBefore,
      this.imageCccdAfter,
      this.imageLicenseBefore,
      this.imageLicenseAfter,
      this.sex,
      this.lat,
      this.lng,
      this.rating,
      this.money,
      this.active,
      this.taxCode,
      this.isTaxCode,
      this.enabledNotify,
      this.car,
      this.deletedAt,
      this.deletedRequestAt,
      this.createdAt,
      this.profile});

  AccountModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["uid"] is String) {
      uid = json["uid"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["avatar"] is String) {
      avatar = json["avatar"];
    }
    if (json["phone"] is String) {
      phone = json["phone"];
    }
    if (json["email"] is String) {
      email = json["email"];
    }
    if (json["address"] is String) {
      address = json["address"];
    }
    birthday = json["birthday"];
    street = json["street"];
    zip = json["zip"];
    city = json["city"];
    state = json["state"];
    country = json["country"];
    countryCode = json["country_code"];
    codeIntroduce = json["code_introduce"];
    cccd = json["cccd"];
    imageCccdBefore = json["image_cccd_before"];
    imageCccdAfter = json["image_cccd_after"];
    imageLicenseBefore = json["image_license_before"];
    imageLicenseAfter = json["image_license_after"];
    if (json["sex"] is int) {
      sex = json["sex"];
    }
    lat = json["lat"];
    lng = json["lng"];
    if (json["rating"] is int) {
      rating = json["rating"];
    }
    if (json["money"] is int) {
      money = json["money"];
    }
    if (json["active"] is int) {
      active = json["active"];
    }
    taxCode = json["tax_code"];
    if (json["is_tax_code"] is int) {
      isTaxCode = json["is_tax_code"];
    }
    if (json["enabled_notify"] is int) {
      enabledNotify = json["enabled_notify"];
    }
    car = json["car"];
    deletedAt = json["deleted_at"];
    deletedRequestAt = json["deleted_request_at"];
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    if (json["profile"] is Map) {
      profile = json["profile"] == null
          ? null
          : ProfileModel.fromJson(json["profile"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["uid"] = uid;
    _data["name"] = name;
    _data["avatar"] = avatar;
    _data["phone"] = phone;
    _data["email"] = email;
    _data["address"] = address;
    _data["birthday"] = birthday;
    _data["street"] = street;
    _data["zip"] = zip;
    _data["city"] = city;
    _data["state"] = state;
    _data["country"] = country;
    _data["country_code"] = countryCode;
    _data["code_introduce"] = codeIntroduce;
    _data["cccd"] = cccd;
    _data["image_cccd_before"] = imageCccdBefore;
    _data["image_cccd_after"] = imageCccdAfter;
    _data["image_license_before"] = imageLicenseBefore;
    _data["image_license_after"] = imageLicenseAfter;
    _data["sex"] = sex;
    _data["lat"] = lat;
    _data["lng"] = lng;
    _data["rating"] = rating;
    _data["money"] = money;
    _data["active"] = active;
    _data["tax_code"] = taxCode;
    _data["is_tax_code"] = isTaxCode;
    _data["enabled_notify"] = enabledNotify;
    _data["car"] = car;
    _data["deleted_at"] = deletedAt;
    _data["deleted_request_at"] = deletedRequestAt;
    _data["created_at"] = createdAt;
    if (profile != null) {
      _data["profile"] = profile?.toJson();
    }
    return _data;
  }
}
