class Shop {
  final String id;
  final String name;
  final String? image;
  final String? coverImage;
  final String? logo;
  final String? description;
  final double? rating;
  final int? reviewCount;
  final String? priceRange;
  final String? distance;
  final String? openingHours;
  final String? location;
  final String? phone;
  final List<String>? categories;
  final bool? isFavorite;

  Shop({
    required this.id,
    required this.name,
    this.image,
    this.coverImage,
    this.logo,
    this.description,
    this.rating,
    this.reviewCount,
    this.priceRange,
    this.distance,
    this.openingHours,
    this.location,
    this.phone,
    this.categories,
    this.isFavorite,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    List<String>? categoriesList;
    if (json['categories'] != null) {
      categoriesList = List<String>.from(
          json['categories'].map((category) => category.toString()));
    }

    return Shop(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      image: json['image'],
      coverImage: json['coverImage'],
      logo: json['logo'],
      description: json['description'],
      rating: json['rating'] != null
          ? double.parse(json['rating'].toString())
          : null,
      reviewCount: json['reviewCount'] != null
          ? int.parse(json['reviewCount'].toString())
          : null,
      priceRange: json['priceRange'],
      distance: json['distance'],
      openingHours: json['openingHours'],
      location: json['location'],
      phone: json['phone'],
      categories: categoriesList,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'coverImage': coverImage,
      'logo': logo,
      'description': description,
      'rating': rating,
      'reviewCount': reviewCount,
      'priceRange': priceRange,
      'distance': distance,
      'openingHours': openingHours,
      'location': location,
      'phone': phone,
      'categories': categories,
      'isFavorite': isFavorite,
    };
  }
}
