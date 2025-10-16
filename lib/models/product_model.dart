class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final String categoryName;
  final List<String> images;
  final String unit; // kg, tonna, quti
  final double weight;
  final int stock;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.categoryName,
    this.images = const [],
    required this.unit,
    required this.weight,
    required this.stock,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.tags = const [],
    this.isAvailable = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      images: List<String>.from(json['images'] ?? []),
      unit: json['unit'],
      weight: json['weight'].toDouble(),
      stock: json['stock'],
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      isAvailable: json['isAvailable'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'images': images,
      'unit': unit,
      'weight': weight,
      'stock': stock,
      'rating': rating,
      'reviewCount': reviewCount,
      'tags': tags,
      'isAvailable': isAvailable,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? categoryId,
    String? categoryName,
    List<String>? images,
    String? unit,
    double? weight,
    int? stock,
    double? rating,
    int? reviewCount,
    List<String>? tags,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      images: images ?? this.images,
      unit: unit ?? this.unit,
      weight: weight ?? this.weight,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      tags: tags ?? this.tags,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String? parentId;
  final List<CategoryModel> subcategories;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.parentId,
    this.subcategories = const [],
    this.isActive = true,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      parentId: json['parentId'],
      subcategories: (json['subcategories'] as List<dynamic>?)
          ?.map((sub) => CategoryModel.fromJson(sub))
          .toList() ?? [],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'parentId': parentId,
      'subcategories': subcategories.map((sub) => sub.toJson()).toList(),
      'isActive': isActive,
    };
  }
}
