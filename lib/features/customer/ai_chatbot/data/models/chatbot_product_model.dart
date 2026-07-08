class ChatbotProductModel {
  final String id;
  final String name;
  final String categoryId;
  final String description;
  final double price;
  final double rating;
  final int stock;
  final List<String> tags;
  final List<String> images;

  ChatbotProductModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.description,
    required this.price,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.images,
  });

  String get imageUrl {
    if (images.isEmpty) return '';
    return images.first;
  }

  factory ChatbotProductModel.fromFirestore({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return ChatbotProductModel(
      id: id,
      name: data['name'] ?? '',
      categoryId: data['categoryId'] ?? '',
      description: data['description'] ?? '',
      price: _toDouble(data['price']),
      rating: _toDouble(data['rating']),
      stock: _toInt(data['stock']),
      tags: List<String>.from(data['tags'] ?? []),
      images: List<String>.from(data['images'] ?? []),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value.toDouble();

    if (value is double) return value;

    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;

    if (value is double) return value.toInt();

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }
}