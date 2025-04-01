class AddressModel {
  int? id;
  String? name;
  String? phone;
  String? address;
  double? lat;
  double? lng;
  String? street;
  String? zip;
  String? city;
  String? state;
  String? country;
  String? countryCode;
  int? isDefault;
  String? createdAt;
  String? updatedAt;

  AddressModel({
    this.id,
    this.name,
    this.phone,
    this.address,
    this.lat,
    this.lng,
    this.street,
    this.zip,
    this.city,
    this.state,
    this.country,
    this.countryCode,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    lat = json['lat']?.toDouble();
    lng = json['lng']?.toDouble();
    street = json['street'];
    zip = json['zip'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    countryCode = json['country_code'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    data['lat'] = lat;
    data['lng'] = lng;
    data['street'] = street;
    data['zip'] = zip;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['country_code'] = countryCode;
    data['is_default'] = isDefault;
    return data;
  }
}
