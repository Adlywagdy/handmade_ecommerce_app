import '../models/chatbot_product_model.dart';
import '../models/user_preferences_model.dart';

class RecommendationService {
  final List<ChatbotProductModel> _dummyProducts = [
    ChatbotProductModel(
      id: 'p003',
      name: 'Pink Floral Gel Candle',
      category: 'candles',
      price: 350,
      imageUrl: 'https://images.unsplash.com/photo-1603006905003-be475563bc59',
      colors: ['pink', 'transparent'],
      style: 'romantic',
      roomType: ['bedroom', 'living_room'],
      roomSize: ['small', 'medium'],
      tags: [
        'candle',
        'pink',
        'romantic',
        'bedroom',
        'soft',
        'floral',
      ],
    ),
    ChatbotProductModel(
      id: 'p004',
      name: 'Rose Flower Candle Set',
      category: 'candles',
      price: 300,
      imageUrl: 'https://images.unsplash.com/photo-1602874801007-bd458bb1b8b6',
      colors: ['cream', 'pink', 'peach'],
      style: 'romantic',
      roomType: ['bedroom', 'living_room'],
      roomSize: ['small', 'medium'],
      tags: [
        'candle',
        'rose',
        'pink',
        'romantic',
        'cozy',
        'bedroom',
      ],
    ),
    ChatbotProductModel(
      id: 'p049',
      name: 'Deer Moon Table Lamp',
      category: 'handmade_lamps',
      price: 680,
      imageUrl: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c',
      colors: ['white', 'gold'],
      style: 'elegant',
      roomType: ['bedroom', 'living_room', 'office'],
      roomSize: ['small', 'medium'],
      tags: [
        'lamp',
        'moon_lamp',
        'white',
        'gold',
        'bedroom',
        'cozy',
      ],
    ),
    ChatbotProductModel(
      id: 'p078',
      name: 'Pink Crochet Tulip Bouquet',
      category: 'crochet_products',
      price: 500,
      imageUrl: 'https://images.unsplash.com/photo-1525310072745-f49212b5ac6d',
      colors: ['pink', 'green', 'white'],
      style: 'romantic',
      roomType: ['bedroom', 'living_room'],
      roomSize: ['small', 'medium'],
      tags: [
        'crochet',
        'pink',
        'romantic',
        'flower',
        'bouquet',
        'bedroom',
      ],
    ),
  ];

  List<ChatbotProductModel> getRecommendations(
    UserPreferencesModel preferences,
  ) {
    final scoredProducts = _dummyProducts.map((product) {
      final score = _calculateScore(product, preferences);

      return {
        'product': product,
        'score': score,
      };
    }).where((item) {
      return item['score'] as int > 0;
    }).toList();

    scoredProducts.sort((a, b) {
      return (b['score'] as int).compareTo(a['score'] as int);
    });

    return scoredProducts
        .take(2)
        .map((item) => item['product'] as ChatbotProductModel)
        .toList();
  }

  int _calculateScore(
    ChatbotProductModel product,
    UserPreferencesModel preferences,
  ) {
    int score = 0;

    if (preferences.category != null &&
        product.category == preferences.category) {
      score += 4;
    }

    if (preferences.roomType != null &&
        product.roomType.contains(preferences.roomType)) {
      score += 3;
    }

    if (preferences.roomSize != null &&
        product.roomSize.contains(preferences.roomSize)) {
      score += 2;
    }

    if (preferences.style != null && product.style == preferences.style) {
      score += 3;
    }

    for (final color in preferences.colors) {
      if (product.colors.contains(color)) {
        score += 2;
      }
    }

    for (final tag in preferences.tags) {
      if (product.tags.contains(tag)) {
        score += 1;
      }
    }

    if (preferences.budget != null && product.price <= preferences.budget!) {
      score += 2;
    }

    return score;
  }
}