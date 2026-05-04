import 'chatbot_product_model.dart';

class ChatbotMessageModel {
  final String text;
  final bool isUser;
  final DateTime createdAt;
  final List<ChatbotProductModel> recommendedProducts;

  ChatbotMessageModel({
    required this.text,
    required this.isUser,
    DateTime? createdAt,
    this.recommendedProducts = const [],
  }) : createdAt = createdAt ?? DateTime.now();

  bool get hasRecommendations => recommendedProducts.isNotEmpty;
}