import '../models/chatbot_product_model.dart';
import '../models/user_preferences_model.dart';

class RecommendationService {
  List<ChatbotProductModel> getRecommendations(
    UserPreferencesModel preferences,
    List<ChatbotProductModel> products,
  ) {
    final scoredProducts = products
        .map((p) => (product: p, score: _calculateScore(p, preferences)))
        .where((item) => item.score > 0)
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    return scoredProducts.take(2).map((item) => item.product).toList();
  }

  int _calculateScore(
    ChatbotProductModel product,
    UserPreferencesModel preferences,
  ) {
    int score = 0;

    final productTags = product.tags
        .map((tag) => tag.toLowerCase().trim())
        .toList();

    final productCategory = product.categoryId.toLowerCase().trim();

    if (preferences.category != null &&
        productCategory == preferences.category!.toLowerCase().trim()) {
      score += 5;
    }

    if (preferences.roomType != null &&
        productTags.contains(preferences.roomType!.toLowerCase().trim())) {
      score += 3;
    }

    if (preferences.roomSize != null &&
        productTags.contains(preferences.roomSize!.toLowerCase().trim())) {
      score += 2;
    }

    if (preferences.style != null &&
        productTags.contains(preferences.style!.toLowerCase().trim())) {
      score += 3;
    }

    for (final color in preferences.colors) {
      if (productTags.contains(color.toLowerCase().trim())) {
        score += 2;
      }
    }

    for (final tag in preferences.tags) {
      if (productTags.contains(tag.toLowerCase().trim())) {
        score += 1;
      }
    }

    if (preferences.budget != null && product.price <= preferences.budget!) {
      score += 2;
    }

    if (product.stock > 0) {
      score += 1;
    }

    if (product.rating >= 4.5) {
      score += 1;
    }

    return score;
  }
}
