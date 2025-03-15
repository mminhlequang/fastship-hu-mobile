class Banner {
  final int? id;
  final String? name;
  final String? image;
  final String? type;
  final int? referenceId;
  final String? description;

  Banner({
    this.id,
    this.name,
    this.image,
    this.type,
    this.referenceId,
    this.description,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: json['id'] as int?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      type: json['type'] as String?,
      referenceId: json['reference_id'] as int?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'type': type,
      'reference_id': referenceId,
      'description': description,
    };
  }

  Banner copyWith({
    int? id,
    String? name,
    String? image,
    String? type,
    int? referenceId,
    String? description,
  }) {
    return Banner(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      type: type ?? this.type,
      referenceId: referenceId ?? this.referenceId,
      description: description ?? this.description,
    );
  }
}
