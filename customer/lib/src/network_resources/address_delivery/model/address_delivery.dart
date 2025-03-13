class AddressDelivery {
  final String? id;
  final String? userId;
  final String? name;
  final String? phone;
  final String? address;
  final String? ward;
  final String? district;
  final String? city;
  final bool? isDefault;
  final String? createdAt;
  final String? updatedAt;

  AddressDelivery({
    this.id,
    this.userId,
    this.name,
    this.phone,
    this.address,
    this.ward,
    this.district,
    this.city,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressDelivery.fromJson(Map<String, dynamic> json) {
    return AddressDelivery(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      ward: json['ward'] as String?,
      district: json['district'] as String?,
      city: json['city'] as String?,
      isDefault: json['isDefault'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'phone': phone,
      'address': address,
      'ward': ward,
      'district': district,
      'city': city,
      'isDefault': isDefault,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  AddressDelivery copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    String? address,
    String? ward,
    String? district,
    String? city,
    bool? isDefault,
    String? createdAt,
    String? updatedAt,
  }) {
    return AddressDelivery(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      ward: ward ?? this.ward,
      district: district ?? this.district,
      city: city ?? this.city,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
