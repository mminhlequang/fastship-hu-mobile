class Category {
  final String id;
  final String name;
  final String? image;
  final String? description;

  Category({
    required this.id,
    required this.name,
    this.image,
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      image: json['image'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
    };
  }
}
