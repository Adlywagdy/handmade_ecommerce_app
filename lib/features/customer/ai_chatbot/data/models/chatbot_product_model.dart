import 'package:handmade_ecommerce_app/core/utils/parse_utils.dart';

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

  String get imageUrl => images.isNotEmpty ? images.first : '';

  factory ChatbotProductModel.fromFirestore({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return ChatbotProductModel(
      id: id,
      name: data['name'] ?? '',
      categoryId: data['categoryId'] ?? '',
      description: data['description'] ?? '',
      price: parseDouble(data['price']) ?? 0,
      rating: parseDouble(data['rating']) ?? 0,
      stock: parseInt(data['stock']) ?? 0,
      tags: List<String>.from(data['tags'] ?? []),
      images: List<String>.from(data['images'] ?? []),
    );
  }
}
