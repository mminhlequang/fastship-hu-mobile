class Product {
  final String id;
  final String name;
  final String? image;
  final String? description;
  final double? price;
  final double? discountPrice;
  final double? rating;
  final int? reviewCount;
  final bool? isFavorite;
  final bool? isPopular;
  final Map<String, dynamic>? restaurant;
  final List<String>? ingredients;
  final Map<String, dynamic>? nutrition;

  Product({
    required this.id,
    required this.name,
    this.image,
    this.description,
    this.price,
    this.discountPrice,
    this.rating,
    this.reviewCount,
    this.isFavorite,
    this.isPopular,
    this.restaurant,
    this.ingredients,
    this.nutrition,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String>? ingredientsList;
    if (json['ingredients'] != null) {
      ingredientsList = List<String>.from(
          json['ingredients'].map((ingredient) => ingredient.toString()));
    }

    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      image: json['image'],
      description: json['description'],
      price:
          json['price'] != null ? double.parse(json['price'].toString()) : null,
      discountPrice: json['discountPrice'] != null
          ? double.parse(json['discountPrice'].toString())
          : null,
      rating: json['rating'] != null
          ? double.parse(json['rating'].toString())
          : null,
      reviewCount: json['reviewCount'] != null
          ? int.parse(json['reviewCount'].toString())
          : null,
      isFavorite: json['isFavorite'] ?? false,
      isPopular: json['isPopular'] ?? false,
      restaurant: json['restaurant'] != null
          ? Map<String, dynamic>.from(json['restaurant'])
          : null,
      ingredients: ingredientsList,
      nutrition: json['nutrition'] != null
          ? Map<String, dynamic>.from(json['nutrition'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFavorite': isFavorite,
      'isPopular': isPopular,
      'restaurant': restaurant,
      'ingredients': ingredients,
      'nutrition': nutrition,
    };
  }
}
