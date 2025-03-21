class StoreModel {
  int? id;
  String? name;
  String? type;
  String? phone;
  String? phoneOther;
  String? phoneContact;
  String? email;
  String? license;
  String? cccd;
  String? cccdDate;
  String? image;
  String? banner;
  String? imageCccdBefore;
  String? imageCccdAfter;
  String? imageLicense;
  String? imageTaxCode;
  List<String>? images;
  String? taxCode;
  int? serviceId;
  List<int>? services;
  List<int>? foods;
  List<int>? products;
  double? fee;
  List<OperatingHour>? operatingHours;
  String? address;
  double? lat;
  double? lng;
  String? street;
  String? zip;
  String? city;
  String? state;
  String? country;
  String? countryCode;
  String? cardBank;
  String? cardNumber;
  String? cardHolderName;
  double? distance;
  int? isOpen;
  double? rate;
  int? countRating;
  int? countOrder;
  int? isFavorite;
  String? createdAt;
  String? updatedAt;

  StoreModel({
    this.id,
    this.name,
    this.type,
    this.phone,
    this.phoneOther,
    this.phoneContact,
    this.email,
    this.license,
    this.cccd,
    this.cccdDate,
    this.image,
    this.banner,
    this.imageCccdBefore,
    this.imageCccdAfter,
    this.imageLicense,
    this.imageTaxCode,
    this.images,
    this.taxCode,
    this.serviceId,
    this.services,
    this.foods,
    this.products,
    this.fee,
    this.operatingHours,
    this.address,
    this.lat,
    this.lng,
    this.street,
    this.zip,
    this.city,
    this.state,
    this.country,
    this.countryCode,
    this.cardBank,
    this.cardNumber,
    this.cardHolderName,
    this.distance,
    this.isOpen,
    this.rate,
    this.countRating,
    this.countOrder,
    this.isFavorite,
    this.createdAt,
    this.updatedAt,
  });

  StoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    phone = json['phone'];
    phoneOther = json['phone_other'];
    phoneContact = json['phone_contact'];
    email = json['email'];
    license = json['license'];
    cccd = json['cccd'];
    cccdDate = json['cccd_date'];
    image = json['image'];
    banner = json['banner'];
    imageCccdBefore = json['image_cccd_before'];
    imageCccdAfter = json['image_cccd_after'];
    imageLicense = json['image_license'];
    imageTaxCode = json['image_tax_code'];
    images = json['images'] != null ? List<String>.from(json['images']) : null;
    taxCode = json['tax_code'];
    serviceId = json['service_id'];
    services =
        json['services'] != null ? List<int>.from(json['services']) : null;
    foods = json['foods'] != null ? List<int>.from(json['foods']) : null;
    products =
        json['products'] != null ? List<int>.from(json['products']) : null;
    fee = json['fee']?.toDouble();
    if (json['operating_hours'] != null) {
      operatingHours = <OperatingHour>[];
      json['operating_hours'].forEach((v) {
        operatingHours!.add(OperatingHour.fromJson(v));
      });
    }
    address = json['address'];
    lat = json['lat']?.toDouble();
    lng = json['lng']?.toDouble();
    street = json['street'];
    zip = json['zip'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    countryCode = json['country_code'];
    cardBank = json['card_bank'];
    cardNumber = json['card_number'];
    cardHolderName = json['card_holder_name'];
    distance = json['distance']?.toDouble();
    isOpen = json['is_open'];
    rate = json['rate']?.toDouble();
    countRating = json['count_rating'];
    countOrder = json['count_order'];
    isFavorite = json['is_favorite'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['phone'] = phone;
    data['phone_other'] = phoneOther;
    data['phone_contact'] = phoneContact;
    data['email'] = email;
    data['license'] = license;
    data['cccd'] = cccd;
    data['cccd_date'] = cccdDate;
    data['image'] = image;
    data['banner'] = banner;
    data['image_cccd_before'] = imageCccdBefore;
    data['image_cccd_after'] = imageCccdAfter;
    data['image_license'] = imageLicense;
    data['image_tax_code'] = imageTaxCode;
    data['images'] = images;
    data['tax_code'] = taxCode;
    data['service_id'] = serviceId;
    data['services'] = services;
    data['foods'] = foods;
    data['products'] = products;
    data['fee'] = fee;
    if (operatingHours != null) {
      data['operating_hours'] = operatingHours!.map((v) => v.toJson()).toList();
    }
    data['address'] = address;
    data['lat'] = lat;
    data['lng'] = lng;
    data['street'] = street;
    data['zip'] = zip;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['country_code'] = countryCode;
    data['card_bank'] = cardBank;
    data['card_number'] = cardNumber;
    data['card_holder_name'] = cardHolderName;
    data['distance'] = distance;
    data['is_open'] = isOpen;
    data['rate'] = rate;
    data['count_rating'] = countRating;
    data['count_order'] = countOrder;
    data['is_favorite'] = isFavorite;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class OperatingHour {
  int? day;
  List<String>? hours;

  OperatingHour({this.day, this.hours});

  OperatingHour.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    hours = json['hours'] != null ? List<String>.from(json['hours']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['hours'] = hours;
    return data;
  }
}
